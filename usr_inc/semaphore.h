#ifndef __SEMAPHORE_H__
#define __SEMAPHORE_H__

#include <usr_inc/types.h>

#define SEM_VALUE_MAX 0x7fffffff

typedef struct {
	int __sem_value;
	bool __valid;
} sem_t;

int sem_init(sem_t *sem, int pshared, unsigned int value);
int sem_wait(sem_t *sem);
int sem_post(sem_t *sem);
int sem_destroy(sem_t *sem);

#endif
