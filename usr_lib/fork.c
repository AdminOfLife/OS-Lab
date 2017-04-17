#include <usr_inc/fork.h>
#include <usr_inc/syscall.h>


int fork() {
	return syscall(FORK);
}
