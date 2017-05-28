#include <usr_inc/semaphore.h>

void wakeup_sem();

int sem(sem_t *sem, int val) {
	if (val == 1) {
		sem->__sem_value++;
		wakeup_sem();
		return 1;
	}
	else if (val == -1) {
		if (sem->__sem_value > 0) {
			sem->__sem_value--;
			return 1;
		}
		else {
			return 0;
		}
	}
	else return -1;
}
