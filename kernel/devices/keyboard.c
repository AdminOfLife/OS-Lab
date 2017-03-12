#include <include/common.h>
#include <include/x86.h>
#include <include/stdio.h>

#define KEYBOARD_IRQ 1

void
add_irq_handle(int irq, void (*func)(void) );

char get_scancode() {
	char c = 0;
	do {
		if (inb(0x60) != c) {
			c = inb(0x60);
			if (c > 0) return c;
		}
	} while (1);
}

void print_scancode() {
	char c = get_scancode();
	printk("Scancode: %d\n", c);
}

void init_keyboard() {
	add_irq_handle(KEYBOARD_IRQ, print_scancode);
}
