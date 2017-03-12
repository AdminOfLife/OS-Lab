#include <include/common.h>
#include <include/x86.h>
#include <include/string.h>
#include <include/stdio.h>

void init_serial();
void init_i8259();
void init_idt();
void init_timer();
void init_keyboard();
//void init_vmem();

void printk_test();
void print_runtime();

void write_black_and_white(const char *string);
void update_cursor(int row, int col);

void init_all(){
	init_serial();
	init_i8259();
	init_idt();
	init_timer();
	init_keyboard();
//	init_vmem();
}

int main(void) {
	init_all();

	sti();

	printk_test();
	
	print_runtime();

	write_black_and_white("2333");
	update_cursor(0, 10);
	
	while (1);
	assert(0); // should not get here
	return 0;
}
