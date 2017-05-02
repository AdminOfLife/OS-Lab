#include <usr_inc/fork.h>
#include <usr_inc/stdio.h>
#include <usr_inc/process.h>


int test_fork() {
	int i;
	for (i = 0; i < 2; i++) {
		int rv = fork();
		printk("X. Current PID: %d. Return Value of fork(): %d\n", get_pid(), rv);
	}
	exit();
//	while (1);
	return 0;
}
