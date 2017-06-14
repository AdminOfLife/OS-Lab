#include "inc.h"
#include <usr_inc/string.h>
#include <usr_inc/stdio.h>
#include <usr_inc/time.h>
#include <usr_inc/timer.h>

char intro[] = "Welcome to Hatsuyuki OS. Hatsuyuki (the author of this OS) is obsessed with riddles and cannot continue working on it. Solve the 5 riddles and she will be back on work. Be quick!\n\nTo answer a riddle, type in the answer and press ENTER. Every answer is either a word (or a single letter) or a number. The riddles will be given one by one. If you really want know the answer, type in \"cheat.\"\n\n";

char remaining_time[] = "Time spent: 00:00\n";

char riddles[][MAX_LEN] = {
"Q: Which is the most curious letter?\n",
"Q: What do you call a bear without an ear?\n",
"Q: What odd number becomes even when beheaded?\n",
"Q: A house has 4 walls all facing south. A bear is outside. What color is it?\n",
"Q: The oddest prime.\n"
};

char answers[][MAX_ANS_LEN] = {
"y",
"b",
"7",
"white",
"2"
};

char answers_print_ver[][MAX_LEN] = {
"Y, (Why).\n",
"B.\n",
"Seven.\n",
"White, because only at the North Pole can a house have 4 walls facing south.\n",
"2, because it is the only even prime.\n"
};

char answer_correct[] = "Correct.\n";
char answer_wrong[] = "Wrong answer. Try again.\n";
char cheat[] = "cheat";
char congrat[] = "Congratulations! Now Hatsuyuki is back on work.\n";

extern char ans[MAX_LEN];

void print_string(int color, char *st);
void wait_input();

long start_time;
char buf[512 + 1];
int allow_cheat;

void game() {
	int fd = fs_open("settings.txt", R_FLAG);
	fs_read(fd, buf, 512);
	if (buf[13] == 't') {
		allow_cheat = 1;
	}

	printk("%s\n", buf);

	start_time = get_time();
	printk("Game Start!\n");
	print_string(BLACK_AND_WHITE, remaining_time);
	print_string(BLACK_AND_WHITE, intro);
	for (int i = 0; i < 5; i++) {
		print_string(BLACK_AND_WHITE, riddles[i]);
		while (1) {
			wait_input();
			if (strcmp(ans, answers[i]) == 0) {
				print_string(BLACK_AND_WHITE, answer_correct);
				break;
			}
			else if (strcmp(ans, cheat) == 0) {
				if (allow_cheat) {
					print_string(BLACK_AND_WHITE, answers_print_ver[i]);
					break;
				}
				else {
					print_string(BLACK_AND_WHITE, "Cheat not allowed.\n");
				}
			}
			else print_string(BLACK_AND_WHITE, answer_wrong);
		}
		print_string(BLACK_AND_WHITE, "\n");
	}
	print_string(BLACK_AND_WHITE, congrat);
	while (1)
		;
}
