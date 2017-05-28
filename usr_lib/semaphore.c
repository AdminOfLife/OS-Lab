#include <usr_inc/semaphore.h>
#include <usr_inc/syscall.h>
#include <usr_inc/process.h>


int sem_init(sem_t *sem, int pshared, unsigned int value) {
	// inter-process semaphore not implemented
	if (pshared) return -1;
	if (value > SEM_VALUE_MAX) return -1;
	sem->__sem_value = value;
	sem->__valid = 1;
	return 0;
}

int sem_wait(sem_t *sem) {
	if (!sem->__valid) return -1;
	int ret_val = syscall(SEM, sem, -1);
	while (!ret_val) {
		sleep(-1); // thread put to sleep indefinately, thus not busywaiting
		ret_val = syscall(SEM, sem, -1);
	}
	return 0;
}

int sem_post(sem_t *sem) {
	if (!sem->__valid) return -1;
	if (syscall(SEM, sem, 1) == -1) return -1;
	else return 0;
}

int sem_destroy(sem_t *sem) {
	if (!sem->__valid) return -1;
	sem->__valid = 0;
	return 0;
}
