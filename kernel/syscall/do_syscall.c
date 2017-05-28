#include <include/irq.h>
#include <include/common.h>
#include <include/syscall.h>
#include <include/assert.h>
#include <include/string.h>
#include <include/stdio.h>
#include <include/mmu.h>
#include <include/x86.h>
#include <include/syscallid.h>
#include <usr_inc/semaphore.h>


bool check_new_key();
char get_key();
int back_space(int);
void update_cursor(int, int);
int print_char(int, char, int);
void update_time(long start_time);
long get_jiffy();
int fork();
int fork_thread();
uint32_t get_pid();
void exit();
void sleep(int, TrapFrame*);
int sem(sem_t *sem, int val);

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
		case FORK:
			return_val = fork();
			break;
		case FORK_T:
			return_val = fork_thread();
			break;
		case GET_PID: return_val = get_pid(); break;
		case EXIT_PROC: exit(); break;
		case PROC_SLEEP: sleep(tf->ecx, tf); break;
		case SEM: return_val = sem((sem_t *)(tf->ecx), tf->edx); break;
		default: panic("Unexpected Sys Call ID: %d\n", tf->eax);
	}
//	printk("Return: %d\n", return_val);
	tf->eax = return_val;
}
