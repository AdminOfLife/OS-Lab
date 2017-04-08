#include <usr_inc/keyboard.h>


bool check_new_key() {
	return syscall(CHECK_KEY);
}

char get_key() {
	return syscall(GET_KEY);
}
