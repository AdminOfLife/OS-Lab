#include <usr_inc/process.h>
#include <usr_inc/syscall.h>


uint32_t get_pid() {
	return syscall(GET_PID);
}
