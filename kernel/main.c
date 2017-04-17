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

	printk("Initialization of Interrupts and Devices Finished.\n");

	init_process();			// init PCB pointer
	init_memory();			// init memory organize

	print_char(0, 'V', 0x0f);
	/* indicates a successful initialization of virtual memory and devices */

	load();					// load program
	// sti();
	while (1);
	return 0;
}

void load() {
//	process_info();
	PCB *current_process = new_process();
	run_pc(current_process);
	process_info();
	set_user_page(current_process);
	struct Elf *elf;
	struct Proghdr *ph, *eph;
	unsigned char *pa;

	elf = (struct Elf*)(0x8000);

	printk("Loading the game from the disk\n");

	printk("ELF Magical Number: 0x%x, should be equal to 0x464c457f\n", *elf);

	readseg((unsigned char*)elf, 4096, OFFSET_IN_DISK);

	ph = (struct Proghdr*)((uint8_t *)elf + elf->e_phoff);
	eph = ph + elf->e_phnum;
	for (; ph < eph; ph++) {
		if(ph->p_type != ELF_PROG_LOAD) continue;
		pa = (unsigned char *)seg_alloc(ph->p_va, current_process);
		pa = (unsigned char *)page_alloc(ph->p_va, ph->p_memsz, current_process);
		readprog(ph->p_va, ph->p_filesz, ph->p_memsz, current_process, pa, OFFSET_IN_DISK + ph->p_offset);
	}

	printk("Filling the Trap Frame (still in Kernel Mode).\n");

	TrapFrame *tf = current_process->tf;
	set_tss_esp0((int)current_process->kstack + KSTACK_SIZE);
	tf->eax = 0; tf->ebx = 1; tf->ecx = 2; tf->edx = 3;
	tf->eflags = read_eflags() | FL_IF;
	tf->eip = elf->e_entry;
	tf->esp = USER_STACK_TOP;

	// printk("DS: 0x%x\n", tf->ds >> 3);

	printk("Allocating User Stack.\n");
	page_alloc(tf->esp - USER_STACK_SIZE, USER_STACK_SIZE, current_process);

	lcr3(va2pa(current_process->pdir));

	printk("Already loaded new CR3.\n");
	printk("Ready to enter the game (User Mode).\n");
	printk("After entering the User Mode, all outputs will have a header.\n");

	asm volatile("movl %0, %%esp" : :"a"((int)tf));
	asm volatile("popa");
	asm volatile("addl %0, %%esp" : :"a"(8));

//	asm volatile("mov $0x2b, %eax\n\t"
//				 "movl %eax, %ds\n\t"
//				 "movl %eax, %es\n\t"
//				 "movl %eax, %fs\n\t"
//				 "movl %eax, %gs\n\t");

	asm volatile("iret");
}
