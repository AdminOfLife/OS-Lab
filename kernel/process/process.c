#include <include/process.h>
#include <include/list.h>
#include <include/assert.h>
#include <include/x86.h>


void set_user_page(PCB *current);

PCB pcb[NR_PCB];
ListHead unused_pcb;

PCB *empty;
ListHead ready, blocked;
PCB *running = NULL;

uint32_t pid_cc;

void set_tss_esp0(int);

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
	// ready_pc(&empty);
	empty = new_process();
	block_pc(empty);
	// run_pc(empty);
	set_user_page(empty);
}

PCB *new_process() {
	if (list_empty(&unused_pcb))
		panic("No PCB Available!\n");
	ListHead *new_pcb = unused_pcb.next;	// so that unused_pcb is always valid
	PCB *new_pc = list_entry(new_pcb, PCB, list);
	ready_pc(new_pc);
	new_pc->pid = pid_cc++;
	new_pc->tf = (TrapFrame *)(new_pc->kstack + KSTACK_SIZE - sizeof(TrapFrame));
	return new_pc;
}

void free_process(PCB *val) {
	list_del(&val->list);
	list_add_after(&unused_pcb, &val->list);
}

void schedule(TrapFrame *tf) {
	if (list_empty(&ready))
		return;
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
}

uint32_t get_pid() {
	return running->pid;
}
