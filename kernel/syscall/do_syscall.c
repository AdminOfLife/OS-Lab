#include <include/irq.h>
#include <include/common.h>
#include <include/syscall.h>
#include <include/assert.h>
#include <include/string.h>
#include <include/stdio.h>
#include <include/mmu.h>

void update_cursor(int row, int col);
char get_key();

enum {GET_KEY, PRINT_CHAR, UPDATE_CURSOR, PRINT_TO_TERMINAL, GET_TIME};

void sys_update_cursor(TrapFrame *tf) {
	update_cursor(tf->ecx, tf->edx);
}

void sys_printf(TrapFrame *tf) {
	
}

void do_syscall(TrapFrame *tf) {
	switch(tf->eax) {
		// case GET_KEY: sys_write(tf); break;
		// case PRINT_CHAR: sys_palette(tf); break;
		case PRINT_TO_TERMINAL: printk("%c", tf->ebx); break;
		// case GET_TIME: tf->eax = Get_time(); break;
		default: panic("Unexpected Sys Call ID: %d\n", tf->eax);
	}
}
