#include <usr_inc/timer.h>


void update_time(long start_time) {
	syscall(UPDATE_TIME, start_time);
}

long get_time() {
	return syscall(GET_TIME);
}
