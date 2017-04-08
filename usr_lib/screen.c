#include <usr_inc/screen.h>
#include <usr_inc/syscall.h>
#include <usr_inc/stdio.h>
#include <usr_inc/syscall.h>


int print_char(int seek, char c, int color) {
	// printk("%d %d %d\n", seek, c, color);
	return syscall(PRINT_CHAR, seek, c, color);
}

void update_cursor(int row, int col) {
	syscall(UPDATE_CURSOR, row, col);
}

int back_space(int seek) {
	return syscall(BACK_SPACE, seek);
}
