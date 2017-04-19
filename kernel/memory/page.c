#include "../common.h"
#include <include/mmu.h>
#include <include/memlayout.h>
#include <include/memory.h>
#include <include/string.h>
#include <include/x86.h>
#include <include/process.h>

__attribute__((__aligned__(PGSIZE)))
pde_t kpdir[NPTENTRIES];	// kernel page directory

/* Does not need a full kernel page table with $NPDENTRIES entries. */
__attribute__((__aligned__(PGSIZE)))
pte_t kptable[MAX_MEM / 2 / PGSIZE];		// kernel page tables

__attribute__((__aligned__(PGSIZE)))
pte_t uptable[MAX_MEM / 2 / PGSIZE];

PgMan page[MAX_MEM / 2 / PTSIZE];

ListHead free_pg;
ListHead used_pg;

void set_kern_page() {
	uint32_t pdir_idx;
	pde_t * pdir = (pde_t *)kpdir;
	pte_t * ptable = (pte_t *)kptable;

	for (pdir_idx = 0; pdir_idx < MAX_MEM / 2 / PTSIZE; pdir_idx++) {
		pdir[pdir_idx] = (pde_t)va2pa(ptable) | PTE_P | PTE_W;
		pdir[pdir_idx + KERNBASE / PTSIZE] = (pde_t)va2pa(ptable) | PTE_P | PTE_W;
		// printk("%x\n", ((uint32_t)(pdir_idx + KERNBASE / PTSIZE)) << 22);
		ptable += NPDENTRIES;
	}

	// while(1);

	int32_t pframe_addr;
	ptable--;
	for (pframe_addr = MAX_MEM / 2 - PGSIZE; pframe_addr >= 0; pframe_addr -= PGSIZE) {
		// printk("%x\n", (uint32_t)(ptable - kptable));
		*ptable = (pte_t)pframe_addr | PTE_P | PTE_W;
		ptable--;
	}

	printk("Kernel Page Dir: 0x%x\n", va2pa(pdir));

	lcr3(va2pa(pdir));
}

void set_user_page(PCB *current) {
	uint32_t pdir_idx;
	pde_t *pdir = current->pdir;
	pte_t *ptable = (pte_t *)va2pa(uptable);

	for (pdir_idx = 0; pdir_idx < 0x400000 / PTSIZE; pdir_idx++) {
		pdir[pdir_idx] = (pde_t)(&ptable[pdir_idx * NPDENTRIES]) | 0x7;
		pdir[pdir_idx + KERNBASE / PTSIZE] = (pde_t)(&ptable[pdir_idx * NPDENTRIES]) | 0x7;
	}
//	printk("Current User Page Dir: 0x%x\n", va2pa(pdir));
}

void init_page() {
	pte_t *ptable = (pte_t *)va2pa(uptable);
	
	int32_t pframe_addr;

	/*
	for (pframe_addr = 0; pframe_addr < 0x400000; pframe_addr += PGSIZE) {
		*ptable = (pte_t)pframe_addr | PTE_P | PTE_W;
		ptable ++;
	}
	*/

	for (pframe_addr = 0; pframe_addr < MAX_MEM / 2; pframe_addr += PGSIZE) {
		*ptable = (pte_t)pframe_addr | PTE_P | PTE_W | PTE_U;
		ptable ++;
	}
	
	ptable = (pte_t *)va2pa(uptable);
	int i, tot = 0;
	list_init(&free_pg);
	list_init(&used_pg);
	for (i = 0x400000; i < MAX_MEM / 2; i += PTSIZE) {
		page[tot++].addr = (int)&ptable[i / PGSIZE];
		list_add_after(&free_pg, &page[tot-1].list);
	}
}

PgMan *get_free_pg() {
	assert(!list_empty(&free_pg));
	ListHead *new_pg = free_pg.next;
	list_del(new_pg);
	list_add_after(&used_pg, new_pg);
//	return list_entry(new_pg, PgMan, list)->addr;
	list_entry(new_pg, PgMan, list)->ref_count++;
	return list_entry(new_pg, PgMan, list);
}

void remove_pg(PgMan *val) {
	val->ref_count--;
	if(val->ref_count == 0) {
		list_del(&val->list);
		list_add_after(&free_pg, &val->list);
	}
}

void paging_info() {
	uint32_t free_pg_count = 0;
	ListHead *i;
	list_foreach(i, &free_pg) {
		free_pg_count++;
	}
	printk("Free Pages: %d.\n", free_pg_count);
}
