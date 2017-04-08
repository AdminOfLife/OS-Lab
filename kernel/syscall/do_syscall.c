#include <include/irq.h>
#include <include/common.h>
#include <include/syscall.h>
#include <include/assert.h>
#include <include/string.h>
#include <include/stdio.h>
#include <include/mmu.h>


void update_cursor(int, int);
int print_char(int, char, int);

enum {GET_KEY, PRINT_CHAR, UPDATE_CURSOR, PRINT_TO_TERMINAL, GET_TIME};

void do_syscall(TrapFrame *tf) {
	int return_val = 0;
	switch(tf->eax) {
		// case GET_KEY: sys_write(tf); break;
		case PRINT_CHAR: return_val = print_char(tf->ecx, tf->edx, tf->ebx); break;
		case PRINT_TO_TERMINAL: printk("%c", tf->ecx); break;
		// case GET_TIME: tf->eax = Get_time(); break;
		default: panic("Unexpected Sys Call ID: %d\n", tf->eax);
	}
	// printk("Return: %d\n", return_val);
	tf->eax = return_val;
}
