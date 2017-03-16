#include "inc.h"
#include <include/string.h>
#include <include/stdio.h>
#include <include/time.h>

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

void print_time();
void print_string(int color, char *st);
void wait_input();

extern Time current_time;
Time start_time;
static bool game_completed = 0;

void update_ingame_time() {
	if (game_completed) return;
	int interval = current_time.minute * 60 + current_time.second - start_time.minute * 60 - start_time.second;
	*((char *)STRING_START + 24) = '0' + interval / 600;
	interval -= interval / 600 * 600;
	*((char *)STRING_START + 26) = '0' + interval / 60;
	interval -= interval / 60 * 60;
	*((char *)STRING_START + 30) = '0' + interval / 10;
	*((char *)STRING_START + 32) = '0' + interval % 10;
}

void game() {
	start_time = current_time;
	update_ingame_time();
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
				print_string(BLACK_AND_WHITE, answers_print_ver[i]);
				break;
			}
			else print_string(BLACK_AND_WHITE, answer_wrong);
		}
		print_string(BLACK_AND_WHITE, "\n");
	}
	game_completed = 1;
	print_string(BLACK_AND_WHITE, congrat);
	//wait_input();
}
