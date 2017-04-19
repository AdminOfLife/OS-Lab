#ifndef KERN_INC_PROCESS_H
#define KERN_INC_PRECESS_H

#include <include/irq.h>
#include <include/list.h>
#include <include/memlayout.h>
#include <include/memory.h>
#include <include/mmu.h>

#define KSTACK_SIZE 4096
#define NR_PCB 16 

typedef struct PCB{
	TrapFrame *tf;
	uint8_t kstack[KSTACK_SIZE];
	__attribute__((__aligned__(PGSIZE)))
	pde_t pdir[NPTENTRIES];
	PgMan *page_man[NPTENTRIES];
	int num_page_man;
	ListHead list;
	uint32_t time, pid;
} __attribute__((packed)) PCB;

void init_process();
PCB* new_process();

void free_process(PCB *val);

void ready_pc(PCB *val);
void block_pc(PCB *val);
void run_pc(PCB *val);

void process_info();
void schedule(TrapFrame *tf);

#endif
