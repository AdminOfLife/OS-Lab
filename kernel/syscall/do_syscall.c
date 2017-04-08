#include <include/irq.h>
#include <include/common.h>
#include <include/syscall.h>
#include <include/assert.h>
#include <include/string.h>
#include <include/stdio.h>
#include <include/mmu.h>


bool check_new_key();
char get_key();
int back_space(int);
void update_cursor(int, int);
int print_char(int, char, int);
void update_time(long start_time);
long get_jiffy();

enum {CHECK_KEY, GET_KEY, BACK_SPACE, PRINT_CHAR, UPDATE_CURSOR, PRINT_TO_TERMINAL, UPDATE_TIME, GET_TIME};

void do_syscall(TrapFrame *tf) {
	int return_val = 0;
	switch(tf->eax) {
		case CHECK_KEY: return_val = check_new_key(); break;
		case GET_KEY: return_val = get_key(); break;
		case BACK_SPACE: return_val = back_space(tf->ecx); break;
		case PRINT_CHAR: return_val = print_char(tf->ecx, tf->edx, tf->ebx); break;
		case UPDATE_CURSOR: update_cursor(tf->ecx, tf->edx); break;
		case PRINT_TO_TERMINAL: printk("%c", tf->ecx); break;
		case UPDATE_TIME: update_time(tf->ecx); break;
		case GET_TIME: return_val = get_jiffy(); break;
		default: panic("Unexpected Sys Call ID: %d\n", tf->eax);
	}
	// printk("Return: %d\n", return_val);
	tf->eax = return_val;
}
