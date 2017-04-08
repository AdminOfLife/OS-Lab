#include "common.h"
#include <include/x86.h>
#include <include/elf.h>
#include <include/mmu.h>
#include <include/irq.h>
#include <include/process.h>
#include <include/disk.h>
#include <include/memory.h>

#define OFFSET_IN_DISK (1000*1024)
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

int kern_init() {
	set_kern_page();		// set page for kernel
	while(1);
	set_kern_segment();		// set segment register for kernel

	init_serial();			// init interrupts
	init_i8259();
	init_idt();
	init_timer();
	init_keyboard();

	init_process();			// init PCB pointer
	init_memory();			// init memory organize

//	load();					// load program

	while(1);
	return 0;
}

void load() {
	PCB *current = new_process();
	set_user_page(current);
	struct Elf *elf;
	struct Proghdr *ph, *eph;
	unsigned char* pa;

	elf = (struct Elf*)(0x0019000);

	readseg((unsigned char*)elf, 4096, OFFSET_IN_DISK);

	ph = (struct Proghdr*)((uint8_t *)elf + elf->e_phoff);
	eph = ph + elf->e_phnum;
	for(; ph < eph; ph ++) {
		if(ph->p_type != ELF_PROG_LOAD) continue;
		pa = (unsigned char *)seg_alloc(ph->p_va, current);
		pa = (unsigned char *)page_alloc(ph->p_va, ph->p_memsz, current);
		readprog(ph->p_va, ph->p_filesz, ph->p_memsz, current, pa, OFFSET_IN_DISK + ph->p_offset);
	}
	
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
	lcr3(va2pa(current->pdir));

	while (1);
	/* Should not get here. */

	/*
	asm volatile("movl %0, %%esp" : :"a"((int)tf));
	asm volatile("popa");
	asm volatile("addl %0, %%esp" : :"a"(8));

	asm volatile("mov 24(%esp), %eax\n\t"
				 "movl %eax, %ds\n\t"
				 "movl %eax, %es\n\t"
				 "movl %eax, %fs\n\t"
				 "movl %eax, %gs\n\t");
	asm volatile("iret");
	*/
}
