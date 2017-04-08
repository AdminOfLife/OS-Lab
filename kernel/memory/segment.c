#include "../common.h"
#include <include/list.h>
#include <include/mmu.h>
#include <include/memory.h>

ListHead free_seg;
ListHead used_seg;
SegMan seg[MAX_MEM / SEG_SIZE];

void init_seg() {
	list_init(&free_seg);
	list_init(&used_seg);
	for(int i = 0; i < MAX_MEM / SEG_SIZE / 2; i++) {
		seg[i].base = 0;
		seg[i].limit = 0xFFFFF;
		seg[i].cs = 2 * i + 1 + 3;
		seg[i].ds = 2 * i + 2 + 3;
		list_add_before(&free_seg, &seg[i].list);
	}
}

SegMan * Get_free_seg() {
	assert(!list_empty(&free_seg));
	ListHead *new_seg = free_seg.next;
	list_del(new_seg);
	list_add_after(&used_seg, new_seg);
	return list_entry(new_seg, SegMan, list);
}

void Free_seg(SegMan *val) {
	list_del(&val->list);
	list_add_after(&free_seg, &val->list);
}
