#include <include/irq.h>
#include <include/common.h>

void do_syscall(TrapFrame *tf);

void do_syscall(TrapFrame *tf) {
	printk("Doing System Call.\n");
}
