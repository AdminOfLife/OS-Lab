#include "../common.h"
#include <include/mmu.h>
#include <include/x86.h>
#include <include/string.h>


/* One TSS is enough for all processes in ring 3. */

static Tss tss;

void
set_tss(SegDesc *ptr) {
	tss.ts_ss0 				= SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
	tss.ts_cr3 				= 0x120000;
	uint32_t base 			= (uint32_t)&tss;
	uint32_t limit 			= sizeof(TSS) - 1;
	ptr->limit_15_0  		= limit & 0xffff;
	ptr->base_15_0   		= base & 0xffff;
	ptr->base_23_16  		= (base >> 16) & 0xff;
	ptr->type 				= STS_T32A;
	ptr->segment_type 		= 0;
	ptr->privilege_level 	= DPL_USER;
	ptr->present 			= 1;
	ptr->limit_19_16 		= limit >> 16;
	ptr->soft_use 			= 0;
	ptr->operation_size 	= 0;
	ptr->pad0 				= 1;
	ptr->granularity 		= 0;
	ptr->base_31_24  		= base >> 24;
}

void
set_tss_esp0(int esp) {
	tss.ts_esp0 			= esp;
}
