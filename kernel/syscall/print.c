#include <include/stdio.h>
#include <include/time.h>


#define STRING_START (0xF0000000 + 0xB8000)
#define BLACK_AND_WHITE (0x0F)
#define COL (80)
#define ROW (25)


int scroll(int seek) {
	// printk("%d\n", seek);
	seek -= COL * 2;
	for (int i = 1; i < ROW - 1; i++) { // First line reserved
		for (int j = 0; j < COL; j++) {
			*((char *)STRING_START + (i * COL + j) * 2) = *((char *)STRING_START + ((i + 1) * COL + j) * 2);
			*((char *)STRING_START + (i * COL + j) * 2 + 1) = *((char *)STRING_START + ((i + 1) * COL + j) * 2 + 1);
		}
	}
	for (int j = 0; j < COL; j++) {
		*((char *)STRING_START + ((ROW - 1) * COL + j) * 2) = 0;
		*((char *)STRING_START + ((ROW - 1) * COL + j) * 2 + 1) = 0;
	}
	// printk("%d\n", seek);
	return seek;
}

int print_char(int seek, char c, int color) {
	if (c != '\n') {
		*((char *)STRING_START + seek) = c;
		seek++;
		*((char *)STRING_START + seek) = color;
		seek++;
		if (seek >= COL * ROW * 2) seek = scroll(seek);
	}
	else {
		seek = seek / (2 * COL) * (2 * COL) + 2 * COL;
		if (seek >= COL * ROW * 2) seek = scroll(seek);
	}
	// printk("%d %d %d\n", seek, c, color);
	return seek;
}

int back_space(int seek) {
	seek--;
	*((char *)STRING_START + seek) = 0;
	seek--;
	*((char *)STRING_START + seek) = 0;
	return seek;
}

extern Time current_time;

void update_time(long start_time) {
	int interval = current_time.minute * 60 + current_time.second - start_time / HZ;
	*((char *)STRING_START + 24) = '0' + interval / 600;
	interval -= interval / 600 * 600;
	*((char *)STRING_START + 26) = '0' + interval / 60;
	interval -= interval / 60 * 60;
	*((char *)STRING_START + 30) = '0' + interval / 10;
	*((char *)STRING_START + 32) = '0' + interval % 10;
}
