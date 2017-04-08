#include "common.h"
#include <include/x86.h>
#include <include/elf.h>
#include <include/mmu.h>
#include <include/irq.h>
#include <include/process.h>
#include <include/disk.h>
#include <include/memory.h>

#define OFFSET_IN_DISK (1000 * 1024)
#define USER_STACK_TOP 0x8000000
#define USER_STACK_SIZE 0x400000

void set_tss_esp0(int);
void set_segment(SegDesc *ptr, uint32_t pl, uint32_t type, uint32_t base, uint32_t limit);

void set_user_page();
void set_kern_page();
void set_kern_segment();
uint32_t seg_alloc(uint32_t, PCB*);
uint32_t page_alloc(uint32_t, uint32_t, PCB*);
void readprog(uint32_t, uint32_t, uint32_t, PCB*, unsigned char *, uint32_t);

void init_serial();
void init_i8259();
void init_idt();
void init_timer();
void init_keyboard();

void init_memory();

void load();

int print_char(int seek, char c, int color);

int kern_init() {
	set_kern_page();		// set page for kernel
	set_kern_segment();		// set segment register for kernel

	init_serial();			// init interrupts and devices
	init_i8259();
	init_idt();
	init_timer();
	init_keyboard();

	init_process();			// init PCB pointer
	init_memory();			// init memory organize

	print_char(0, 'V', 0x0f);

	load();					// load program

	while (1);
	return 0;
}

void load() {
	PCB *current = new_process();
	set_user_page(current);
	struct Elf *elf;
	struct Proghdr *ph, *eph;
	unsigned char *pa;

	elf = (struct Elf*)(0x8000);


	readseg((unsigned char*)elf, 4096, OFFSET_IN_DISK);

	ph = (struct Proghdr*)((uint8_t *)elf + elf->e_phoff);
	eph = ph + elf->e_phnum;
	for (; ph < eph; ph++) {
		if(ph->p_type != ELF_PROG_LOAD) continue;
		// printk("%x %x\n", ph, eph);
		pa = (unsigned char *)seg_alloc(ph->p_va, current);
		pa = (unsigned char *)page_alloc(ph->p_va, ph->p_memsz, current);

		printk("%x\n", ph->p_va);

		readprog(ph->p_va, ph->p_filesz, ph->p_memsz, current, pa, OFFSET_IN_DISK + ph->p_offset);
		printk("pa: %x\n", ph->p_offset);
		printk("%x\n", elf->e_entry);
		// for (i = pa + ph->p_filesz; i < pa + ph->p_memsz; *i ++ = 0);
	}

	printk("elf: %x\n", *elf);
	
	printk("PA: %x\n", *(char *)0x06000000);
	*(char *)(0x06000000) = 10;
	printk("PA: %x\n", *(char *)0x06000000);
	printk("Filling the Trap Frame (still in Kernel Mode).\n");

	TrapFrame *tf = &current->tf;
	set_tss_esp0((int)current->kstack + KSTACK_SIZE);
	tf->eax = 0; tf->ebx = 1; tf->ecx = 2; tf->edx = 3;
	uint32_t eflags = read_eflags();
	tf->eflags = eflags | FL_IF;
	tf->eip = elf->e_entry;
	tf->esp = USER_STACK_TOP;

	page_alloc(USER_STACK_TOP - USER_STACK_SIZE, USER_STACK_SIZE, current);

	printk("Ready to enter the game (User Mode).\n");

	printk("%x\n", va2pa(current->pdir));
	printk("%x\n", rcr3());


	lcr3(va2pa(current->pdir));

	printk("%x %x\n", *(char *)0x08000000, elf->e_entry);
	*(char *)0x08000000 = 0x55;
	printk("%x %x\n", *(char *)0x08000000, elf->e_entry);
	// printk("%x\n", rcr3());

	printk("Should not get here.\n");
	printk("%x\n", rcr3());
	// while (1);
	/* Should not get here. */

	asm volatile("movl %0, %%esp" : :"a"((int)tf));
	asm volatile("popa");
	asm volatile("addl %0, %%esp" : :"a"(8));

	asm volatile("mov 24(%esp), %eax\n\t"
				 "movl %eax, %ds\n\t"
				 "movl %eax, %es\n\t"
				 "movl %eax, %fs\n\t"
				 "movl %eax, %gs\n\t");
	asm volatile("iret");
}
