#include "inc.h"

char intro[] = "Welcome to Hatsuyuki OS. Hatsuyuki (the author of this OS) is obsessed with riddles and cannot continue working on it. Solve the 5 riddles and she will be back on work. You have 5 minutes.\n\nTo answer a riddle, type in the answer and press ENTER. Every answer is either a word (or a single letter) or a number. The riddles will be given one by one. If you really want know the answer, type in \"cheat.\"\n\n";

char remaining_time[] = "Time remaining:   :  \n";

char riddles[][MAX_LEN] = {
"Which is the most curious letter?",
"What do you call a bear without an ear?",
"What odd number becomes even when beheaded?",
"A house has 4 walls which all face south. A bear is outside. What color is it?",
"The oddest prime."
};

char answers[][MAX_ANS_LEN] = {
"y",
"b",
"7",
"white",
"2"
};

char answers_print_ver[][MAX_LEN] = {
"Y, (Why).",
"B.",
"Seven.",
"White, because only at the North Pole can a house have 4 walls facing south.",
"2, because it is the only even prime."
};

void print_string(int color, char *st);
void wait_input();

void game() {
	print_string(BLACK_AND_WHITE, intro);
	wait_input();
}
