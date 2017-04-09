#include "../common.h"
#include <include/mmu.h>
#include <include/x86.h>
#include <include/string.h>


void set_tss(SegDesc *ptr);

SegDesc gdt[NR_SEGMENTS];

void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type, uint32_t base, uint32_t limit) {
	ptr->limit_15_0  		= limit & 0xFFFF;
	ptr->base_15_0   		= base & 0xFFFF;
	ptr->base_23_16  		= (base >> 16) & 0xFF;
	ptr->type 				= type;
	ptr->segment_type 		= 1;
	ptr->privilege_level	= pl;
	ptr->present 			= 1;
	ptr->limit_19_16 		= (limit >> 16) & 0xF;
	ptr->soft_use 			= 0;
	ptr->operation_size 	= 0;
	ptr->pad0 				= 1;
	ptr->granularity 		= 1;
	ptr->base_31_24  		= (base >> 24) & 0xFF;
}

void
set_kern_segment(void) {
	memset(gdt, 0, sizeof(gdt));
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE, 0, 0xFFFFF);
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE, 0, 0xFFFFF);
	write_gdtr(gdt, sizeof(gdt));
	set_tss(&gdt[SEG_TSS]);
	ltr(SELECTOR_USER(SEG_TSS));
}
