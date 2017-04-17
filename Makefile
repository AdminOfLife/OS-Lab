ID  := 151242041

SUFFIX  :=
SUFFIX  := _linux
# Specified on macOS
# where cross-platform compilers are used

CC  := gcc$(SUFFIX)
LD  := ld$(SUFFIX)
OBJCOPY := objcopy$(SUFFIX)
DD  := dd
QEMU    := qemu-system-i386
GDB := gdb

CFLAGS := -Wall -Werror -Wfatal-errors
CFLAGS += -MD
CFLAGS += -std=gnu11 -m32 -c
CFLAGS += -O0
CFLAGS += -I .
CFLAGS += -fno-builtin
CFLAGS += -ggdb3
CFLAGS += -fno-stack-protector

QEMU_OPTIONS := -serial stdio
#QEMU_OPTIONS += -d int
QEMU_OPTIONS += -monitor telnet:127.0.0.1:1111,server,nowait
QEMU_OPTIONS += -m 512 -no-reboot

QEMU_DEBUG_OPTIONS := -S
QEMU_DEBUG_OPTIONS += -s

GDB_OPTIONS := -ex "target remote 127.0.0.1:1234"
GDB_OPTIONS += -ex "symbol $(KERNEL)"


BOOT    := boot.bin
KERNEL  := kernel.bin
GAME    := game.bin
IMAGE   := disk.bin

OBJ_DIR	:= obj
LIB_DIR	:= lib
BOOT_DIR    := boot
KERNEL_DIR  := kernel
GAME_DIR    := game
USR_LIB_DIR := usr_lib

OBJ_LIB_DIR	:= $(OBJ_DIR)/$(LIB_DIR)
OBJ_USR_LIB_DIR	:= $(OBJ_DIR)/$(USR_LIB_DIR)
OBJ_BOOT_DIR    := $(OBJ_DIR)/$(BOOT_DIR)
OBJ_KERNEL_DIR  := $(OBJ_DIR)/$(KERNEL_DIR)
OBJ_GAME_DIR    := $(OBJ_DIR)/$(GAME_DIR)

KERNEL_LD_SCRIPT := $(shell find $(KERNEL_DIR) -name "*.ld")
GAME_LD_SCRIPT := $(shell find $(GAME_DIR) -name "*.ld")

LIB_C := $(shell find $(LIB_DIR) -name "*.c")
LIB_S := $(shell find $(LIB_DIR) -name "*.S")
LIB_O := $(LIB_C:$(LIB_DIR)/%.c=$(OBJ_LIB_DIR)/%.o)
LIB_O += $(LIB_S:$(LIB_DIR)/%.S=$(OBJ_LIB_DIR)/%.o)

USR_LIB_C := $(shell find $(USR_LIB_DIR) -name "*.c")
USR_LIB_S := $(shell find $(USR_LIB_DIR) -name "*.S")
USR_LIB_O := $(USR_LIB_C:$(USR_LIB_DIR)/%.c=$(OBJ_USR_LIB_DIR)/%.o)
USR_LIB_O += $(USR_LIB_S:$(USR_LIB_DIR)/%.S=$(OBJ_USR_LIB_DIR)/%.o)

BOOT_S := $(shell find $(BOOT_DIR) -name "*.S")
BOOT_C := $(shell find $(BOOT_DIR) -name "*.c")
BOOT_O := $(BOOT_S:%.S=$(OBJ_DIR)/%.o)
BOOT_O += $(BOOT_C:%.c=$(OBJ_DIR)/%.o)

KERNEL_C := $(shell find $(KERNEL_DIR) -name "*.c")
KERNEL_S := $(shell find $(KERNEL_DIR) -name "*.S")
KERNEL_O := $(KERNEL_C:%.c=$(OBJ_DIR)/%.o)
KERNEL_O += $(KERNEL_S:%.S=$(OBJ_DIR)/%.o)

GAME_C := $(shell find $(GAME_DIR) -name "*.c")
GAME_S := $(shell find $(GAME_DIR) -name "*.S")
GAME_O := $(GAME_C:%.c=$(OBJ_DIR)/%.o)
GAME_O += $(GAME_S:%.S=$(OBJ_DIR)/%.o)


$(IMAGE): $(BOOT) $(KERNEL) $(GAME)
	# @$(DD) if=/dev/zero of=$(IMAGE) count=10000		 > /dev/null
	# @$(DD) if=$(BOOT) of=$(IMAGE) conv=notrunc		  > /dev/null
	# @$(DD) if=$(KERNEL) of=$(IMAGE) seek=1 conv=notrunc > /dev/null
	@cat $(BOOT) $(KERNEL) $(GAME) > $(IMAGE)

# kernel and Bootloader
$(BOOT): $(BOOT_O)
	$(LD) -e start -Ttext=0x7C00 -m elf_i386 -nostdlib -o $@.out $^
	$(OBJCOPY) --strip-all --only-section=.text --output-target=binary $@.out $@
	@rm $@.out
	ruby mkmbr.rb $@

$(OBJ_BOOT_DIR)/%.o: $(BOOT_DIR)/%.S
	@mkdir -p $(OBJ_BOOT_DIR)
	$(CC) $(CFLAGS) -Os $< -o $@

$(OBJ_BOOT_DIR)/%.o: $(BOOT_DIR)/%.c
	@mkdir -p $(OBJ_BOOT_DIR)
	$(CC) $(CFLAGS) -Os $< -o $@

$(KERNEL): $(KERNEL_LD_SCRIPT)
$(KERNEL): $(KERNEL_O) $(LIB_O)
	$(LD) -m elf_i386 -T $(KERNEL_LD_SCRIPT) -nostdlib -o $@ $^ $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
	@perl genkern.pl $@

$(GAME): $(GAME_LD_SCRIPT)
$(GAME): $(GAME_O) $(USR_LIB_O)
	$(LD) -m elf_i386 -T $(GAME_LD_SCRIPT) -nostdlib -o $@ $^ $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)


$(OBJ_LIB_DIR)/%.o : $(LIB_DIR)/%.[cS]
	@mkdir -p $(OBJ_LIB_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_USR_LIB_DIR)/%.o : $(USR_LIB_DIR)/%.[cS]
	@mkdir -p $(OBJ_USR_LIB_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_KERNEL_DIR)/%.o: $(KERNEL_DIR)/%.[cS]
	@mkdir -p $(OBJ_DIR)/$(dir $<)
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_GAME_DIR)/%.o: $(GAME_DIR)/%.[cS]
	@mkdir -p $(OBJ_DIR)/$(dir $<)
	$(CC) $(CFLAGS) $< -o $@

# Libs (obsolete)
#
# LIB_O := $(patsubst lib/%.c, $(OBJDIR)/lib/%.o, lib/*.c)
# LIB_O += $(patsubst lib/%.S, $(OBJDIR)/lib/%.o, lib/*.S)
# 
# $(OBJDIR)/lib/%.o: lib/%.c
# 	@mkdir -p $(@D)
# 	@$(CC) -nostdinc $(CFLAGS) -c -o $@ $<
# 
# $(OBJDIR)/lib/%.o: lib/%.S
# 	@mkdir -p $(@D)
# 	@$(CC) -nostdinc $(CFLAGS) -c -o $@ $<

DEPS := $(shell find -name "*.d")
-include $(DEPS)

.PHONY: qemu qemu_make quemu-kvm clean

qemu:
	@find . -name '._*' -delete
	@make qemu_make

qemu_make: $(IMAGE)
	$(QEMU) $(QEMU_OPTIONS) $(IMAGE)

qemu-kvm: $(IMAGE)
	$(QEMU) $(QEMU_OPTIONS) --enable-kvm $(IMAGE)

debug: $(IMAGE)
	$(QEMU) $(QEMU_DEBUG_OPTIONS) $(QEMU_OPTIONS) $(IMAGE)

gdb:
	$(GDB) $(GDB_OPTIONS)

clean:
	@rm -rf $(OBJ_DIR) 2> /dev/null
	@rm -rf $(BOOT)	2> /dev/null
	@rm -rf $(KERNEL)  2> /dev/null
	@rm -rf $(GAME)   2> /dev/null
	@rm -rf $(IMAGE)   2> /dev/null

submit:
	@cd .. && tar cvj $(shell pwd | grep -o '[^/]*$$') > $(ID).tar.bz2
