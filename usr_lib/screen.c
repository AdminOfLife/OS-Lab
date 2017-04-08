#include <usr_inc/screen.h>
#include <usr_inc/syscall.h>
#include <usr_inc/stdio.h>


#define PRINT_CHAR 1

int print_char(int seek, char c, int color) {
	printk("%d %d %d\n", seek, c, color);
	int tmp = syscall(PRINT_CHAR, seek, c, color);
	printk("%d\n", tmp);
	return tmp;
}
