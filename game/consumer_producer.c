#include <usr_inc/fork.h>
#include <usr_inc/stdio.h>
#include <usr_inc/process.h>
#include <usr_inc/semaphore.h>

#define N 5
#define MAX_ITEM 100

sem_t mutex, empty, full;
int item[N], cnt = 0;

void loop() {
	int tmp = 0x160710;
	while (tmp--)
		;
}

void producer() {
	for (int i = 0; i < MAX_ITEM; i++) {
		loop();
		sem_wait(&empty);
		sem_wait(&mutex);

		item[cnt] = i;
		printk("Produced: %d\n", item[cnt]);
		cnt++;

		sem_post(&mutex);
		sem_post(&full);
	}
}

void consumer() {
	for (int i = 0; i < MAX_ITEM; i++) {
		loop();
		sem_wait(&full);
		sem_wait(&mutex);

		cnt--;
		printk("Consumed: %d\n", item[cnt]);

		sem_post(&mutex);
		sem_post(&empty);
	}
}

int consumer_producer() {
	sem_init(&mutex, 0, 1);
	sem_init(&full, 0, 0);
	sem_init(&empty, 0, N);
	int rv = fork_thread();

	if (rv == 0) {
		producer();
	}
	else {
		consumer();
		sem_destroy(&mutex);
		sem_destroy(&full);
		sem_destroy(&empty);
	}
	while (1)
		;
	return 0;
}
