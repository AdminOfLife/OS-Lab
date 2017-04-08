#include <include/process.h>
#include <include/list.h>

PCB pcb[NR_PCB];
ListHead pcb_head;
ListHead unused_pcb;

void init_process() {
	list_init(&pcb_head);
	list_init(&unused_pcb);
	for(int i = 0; i < NR_PCB; ++ i) {
		pcb[i].p = false;
		list_add_after(&unused_pcb, &pcb[i].list);
	}
}

PCB *new_process() {
	assert(!list_empty(&unused_pcb));
	ListHead *new_pcb = unused_pcb.next;
	list_del(new_pcb);
	list_add_after(&pcb_head, new_pcb);
	return list_entry(new_pcb, PCB, list);
}

void Free_process(PCB *val) {
	list_del(&val->list);
	list_add_after(&pcb_head, &val->list);
}
