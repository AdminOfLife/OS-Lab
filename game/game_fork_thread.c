#include <usr_inc/fork.h>
#include <usr_inc/stdio.h>
#include <usr_inc/process.h>
#include <usr_inc/semaphore.h>

sem_t x;

int test_fork_thread() {
	sem_init(&x, 0, 0);
	int rv = fork_thread();
	printk("X. Current PID: %d. Return Value of fork(): %d\n", get_pid(), rv);
	if (rv == 0) {
		sleep(10);
		sem_post(&x);
	}
	else {
		// sleep(10);
		sem_wait(&x);
		printk("passed\n");
	}
	while (1)
		;
	return 0;
}
