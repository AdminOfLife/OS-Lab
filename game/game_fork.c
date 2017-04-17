#include <usr_inc/fork.h>
#include <usr_inc/stdio.h>
#include <usr_inc/process.h>


int test_fork() {
	int i;
	for (i = 0; i < 2; i++) {
		fork();
		printk("x %d\n", get_pid());
	}
	while (1);
	return 0;
}
