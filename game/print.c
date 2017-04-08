#include <usr_inc/string.h>
#include <usr_inc/stdio.h>
#include <usr_inc/screen.h>
#include <usr_inc/keyboard.h>
#include <usr_inc/timer.h>
#include "inc.h"


static int seek = 0;
char ans[MAX_LEN];
static int len = 0;
extern long start_time;

char look_up[256] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
'\n', BACKSPACE,
'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};


void print_string(int color, char *st) {
	// printk("%s\n", st);
	char c = *st;
	while (c) {
		seek = print_char(seek, c, color);
		st++;
		c = *st;
		// printk("seek = %d\n", seek);
	}
	update_cursor(seek / COL / 2, seek % (COL * 2) / 2);
}

void process_ans() {
	for (int i = 0; i < len; i++) {
		if ('A' <= ans[i] && ans[i] <= 'Z') ans[i] += 'a' - 'A';
	}
	if (strcmp(ans, "two") == 0) {
		ans[0] = '2';
		ans[1] = 0;
	}
	else if (strcmp(ans, "seven") == 0) {
		ans[0] = '7';
		ans[1] = 0;
	}
}

void wait_input() {
	char c;
	len = 0;
	print_string(BLACK_AND_WHITE, "> ");
	// while (1);
	while (1) {
		while (!check_new_key())
			update_time(start_time);
		c = get_key();
		char c_translated = look_up[(int)c];
		if (c_translated == BACKSPACE) {
			if (len) {
				len--;
				seek = back_space(seek);
			}
		}
		else if (len < MAX_LEN - 1) {
			char tmp_string[2] = {c_translated, 0};
			ans[len] = c_translated;
			len++;
			print_string(BLACK_AND_WHITE, tmp_string);
		}
		update_cursor(seek / COL / 2, seek % (COL * 2) / 2);
		if (c_translated == '\n') break;
	}
	// printk("%d\n", len);
	len--;
	ans[len] = 0;
	process_ans();
	printk("The input is \"%s.\"\n", ans);
}
