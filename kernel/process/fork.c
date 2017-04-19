#include "../common.h"
#include <include/irq.h>
#include <include/memory.h>
#include <include/x86.h>
#include <include/string.h>
#include <include/process.h>

void set_user_page(PCB *);
PgMan* get_free_pg();

extern PCB *running;
extern PCB *empty;

int fork() {
	PCB *newp = new_process();
	uint32_t i, va, nva;

	newp->tf = (TrapFrame *)((int)(newp->kstack) + (int)(running->tf) - (int)(running->kstack));
	memcpy(newp->kstack, running->kstack, sizeof newp->kstack);
//	set_user_page(newp);

//	printk("Begin to Copy\n");

//	int backup_cr3 = rcr3();
//	printk("Fork CR3: %x\n", backup_cr3);

	uint32_t tmp;

	for (i = 0; i < NPDENTRIES; i++) {
		if (!(running->pdir[i] & PTE_P)){
			tmp = i;
			break;
		}
	}
	uint32_t tmp_page_dir = running->pdir[tmp];

	for (i = 0; i < NPDENTRIES; i++) {
		if((running->pdir[i] & PTE_P) && !(newp->pdir[i] & PTE_P)) {
//			printk("%x %x %x\n", tmp, running->pdir[i], newp->pdir[i]);
//			printk("Copying the %d-th Page Dir.\n", i);

			// newp->pdir[i] = get_free_pg() | PTE_P | PTE_W | PTE_U;

			PgMan *current_page = get_free_pg();
			newp->page_man[newp->num_page_man++] = current_page;
			newp->pdir[i] = current_page->addr | PTE_P | PTE_W | PTE_U;

			running->pdir[tmp] = newp->pdir[i];

			va = i << 22;
			nva = tmp << 22;
			
			int j;
			for (j = 0; j < PTSIZE; j++) {
				*(char *)nva = *(char *)va;
				nva++;
				va++;
//				printk("%x %x\n", (uint32_t)running, (uint32_t)newp);
			}

			// memcpy((void *)nva, (void *)va, PTSIZE);
		}
	}

	running->pdir[tmp] = tmp_page_dir;

//	printk("Fork Return.\n");

//	lcr3(backup_cr3);

//	printk("Run EIP: %x\n", running->tf->eip);
//	printk("New EIP: %x\n", newp->tf->eip);

//	lcr3(va2pa(newp->pdir));

	return newp->pid;
}
