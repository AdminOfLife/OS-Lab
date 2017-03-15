#include <include/string.h>
#include "inc.h"

char get_key();
void update_cursor(int row, int col);
bool check_new_key();

static int seek = COL * 2;

char look_up(char c) {
	return 'a' + c;
}

void scroll() {
	seek -= COL * 2;
	for (int i = 1; i < ROW - 1; i--) { // First line reserved
		for (int j = 0; j < COL; j++) {
			*((char *)STRING_START + i * COL * 2 + j) = *((char *)STRING_START + (i + 1) * COL * 2 + j);
			*((char *)STRING_START + i * COL * 2 + j + 1) = *((char *)STRING_START + (i + 1) * COL * 2 + j + 1);
		}
	}
	for (int j = 0; j < COL; j++) {
		*((char *)STRING_START + (ROW - 1) * COL * 2 + j) = 0;
		*((char *)STRING_START + (ROW - 1) * COL * 2 + j + 1) = 0;
	}
}

void print_char(int color, char c) {
	if (seek >= COL * ROW * 2) scroll();
	if (c != '\n') {
		*((char *)STRING_START + seek) = c;
		seek++;
		*((char *)STRING_START + seek) = color;
		seek++;
	}
	else {
		seek = seek / (2 * COL) * (2 * COL) + 2 * COL;
		if (seek >= COL * ROW * 2) scroll();
	}
}

void print_string(int color, char *st) {
	printk("%s\n", st);
	char c = *st;
	while (c) {
		print_char(color, c);
		st++;
		c = *st;
	}
	update_cursor(seek / COL / 2, seek % (COL * 2) / 2);
}

void wait_input() {
	print_char(BLACK_AND_WHITE, '>');
	char c;
	while (1) {
		while (!check_new_key())
			;
		c = get_key();
		print_char(BLACK_AND_WHITE, look_up(c));
		update_cursor(seek / COL / 2, seek % (COL * 2) / 2);
		if (c == 26) break;
	}
}

void put_key() {
	char c = get_key();
	c++;
}
