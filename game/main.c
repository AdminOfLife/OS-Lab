#include <usr_inc/fork.h>
#include <usr_inc/stdio.h>
#include <usr_inc/process.h>
#include "common.h"


void game();
void test_fork();

int main() {
	int rv = fork();
	if (rv == 0) {
#ifdef GAME
		game();
#else
#ifdef TEST_FORK
		test_fork();
#endif // GAME
#endif // TEST_FORK
	}
	else while(1)
		;
	return 0;
}
