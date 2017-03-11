#include <include/stdio.h>
#include <include/time.h>

extern Time current_time;

void print_runtime() {
	printk("The OS has run %d day(s), %d hour(s), %d minute(s), and %d second(s).\n",
		current_time.day, current_time.hour, current_time.minute, current_time.second);
}
