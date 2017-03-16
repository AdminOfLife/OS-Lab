#include <include/common.h>
#include <include/x86.h>
#include <include/stdio.h>

#define KEYBOARD_IRQ 1
#define SCAN_CODE_COUNT 38

void
add_irq_handle(int irq, void (*func)(void) );

static int letter_code[] = {
    30, 48, 46, 32, 18, 33, 34, 35, 23, 36,
    37, 38, 50, 49, 24, 25, 16, 19, 31, 20,
    22, 47, 17, 45, 21, 44, 0x1c, 0x0e,
    2, 3, 4, 5, 6, 7, 8, 9, 10, 11
};

static char last_scancode = 0;
static bool is_new_key = 0;

bool check_new_key() {
	return is_new_key && last_scancode > 0;
}

char get_key() {
    int i;
  	is_new_key = 0;
    for (i = 0; i < SCAN_CODE_COUNT; i++) {
        if (letter_code[i] == last_scancode) {
            return i;
        }
    }
    return 0xff;
}

char get_scancode() {
	//char c = 0;
	//do {
	//	if (inb(0x60) != c) {
	//		c = inb(0x60);
	//		if (c > 0) return c;
	//	}
	//} while (1);
	last_scancode = inb(0x60);
	is_new_key = 1;
	return last_scancode;
}

void print_scancode() {
	char c = get_scancode();
	printk("Scancode: %d\n", c);
}

void init_keyboard() {
	add_irq_handle(KEYBOARD_IRQ, print_scancode);
}
