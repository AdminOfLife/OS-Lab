#include <usr_inc/fork.h>
#include <usr_inc/syscall.h>


int fork() {
	return syscall(FORK);
}

int fork_thread() {
	return syscall(FORK_T);
}
