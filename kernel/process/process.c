#include <include/process.h>
#include <include/list.h>
#include <include/assert.h>
#include <include/x86.h>
#include <include/string.h>


PCB pcb[NR_PCB];
ListHead unused_pcb;

PCB *empty;
ListHead ready, blocked;
PCB *running = NULL;

uint32_t pid_cc;

void set_tss_esp0(int);
void remove_pg(PgMan *val);
void set_user_page(PCB *current);
void paging_info();

void ready_pc(PCB *val) {
	list_del(&val->list);
	list_add_after(&ready, &val->list);
}

/* TODO: Add time. */
void block_pc(PCB *val) {
	list_del(&val->list);
	list_add_after(&blocked, &val->list);
}

void run_pc(PCB *val) {
	if (running != NULL) list_add_before(&ready, &running->list);
	list_del(&val->list);
	running = val;
}

void init_process() {
	list_init(&unused_pcb);
	list_init(&ready);
	list_init(&blocked);
	for(int i = 0; i < NR_PCB; i++) {
		list_add_after(&unused_pcb, &pcb[i].list);
	}
//	ready_pc(&empty);
	empty = new_process();
	block_pc(empty);
//	run_pc(empty);
//	set_user_page(empty);
}

PCB *new_process() {
	if (list_empty(&unused_pcb))
		panic("No PCB Available!\n");
	ListHead *new_pcb = unused_pcb.next;	// so that unused_pcb is always valid
	list_del(new_pcb);
	PCB *new_pc = list_entry(new_pcb, PCB, list);
	ready_pc(new_pc);
	memset(new_pc->pdir, 0, sizeof(new_pc->pdir));
	new_pc->pid = pid_cc++;
	new_pc->tf = (TrapFrame *)(new_pc->kstack + KSTACK_SIZE - sizeof(TrapFrame));
	set_user_page(new_pc);
	new_pc->num_page_man = 0;
	return new_pc;
}

void free_process(PCB *val) {
	int i;
	for (i = 0; i < val->num_page_man; i++) {
		remove_pg(val->page_man[i]);
	}
	
	list_del(&val->list);
	list_add_after(&unused_pcb, &val->list);
}

void schedule(TrapFrame *tf) {
	process_info();
	if (list_empty(&ready))
		panic("No Ready Processes Available!\n");
	run_pc(list_entry(ready.next, PCB, list));
//	list_del(&running->list);
	set_tss_esp0((int)running->kstack + KSTACK_SIZE);
	lcr3(va2pa(running->pdir));
//	while (1);
}

void process_info() {
	printk("Pid %d, Running.\n", running->pid);
	ListHead *i;
	list_foreach(i, &ready) {
		printk("Pid %d, Ready.\n", list_entry(i, PCB, list)->pid);
	}
	list_foreach(i, &blocked) {
		printk("Pid %d, Blocked.\n", list_entry(i, PCB, list)->pid);
	}
	paging_info();
}

uint32_t get_pid() {
	return running->pid;
}

void exit() {
	PCB *old_running = running;
	schedule(old_running->tf);
	free_process(old_running);
}
