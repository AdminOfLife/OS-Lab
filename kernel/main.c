#include <include/common.h>
#include <include/x86.h>
#include <include/string.h>
#include <include/stdio.h>

void init_serial();
void init_i8259();
void init_idt();
void init_timer();
//void init_vmem();

void printk_test();
void print_runtime();

void init_all(){
	init_serial();
	init_i8259();
	init_idt();
	init_timer();
//	init_vmem();
}

int main(void) {
	init_all();

	printk("Here is main()\n");

	printk_test();
	print_runtime();

	sti();

	assert(0); // should not get here
	return 0;
}
