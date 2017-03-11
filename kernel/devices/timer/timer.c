#include <include/common.h>
#include <include/x86.h>
#include <include/time.h>
#include <include/string.h>

#define PORT_CH_0 0x40
#define PORT_CMD 0x43
#define PIT_FREQUENCE 1193182
#define TIME_IRQ 0

union CmdByte {
	struct {
		uint8_t present_mode : 1;
		uint8_t operate_mode : 3;
		uint8_t access_mode  : 2;
		uint8_t channel      : 2;
	};
	uint8_t val;
};

union CmdByte mode = {
	.present_mode = 0,  // 16-bit binary
	.operate_mode = 2,  // rate generator, for more accuracy
	.access_mode  = 3,  // low byte / high byte, see below
	.channel      = 0,  // use channel 0
};

Time current_time;
long jiffy = 0;

void
add_irq_handle(int irq, void (*func)(void) );
void
update_jiffy();

void
init_timer() {
	int counter = PIT_FREQUENCE / HZ;
	outb(PORT_CMD, mode.val);
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
	memset(&current_time, 0, sizeof(Time));
	add_irq_handle(TIME_IRQ, update_jiffy);
}

inline long
get_jiffy() {
	return jiffy;
}

void 
get_time(Time *tm) {
	memcpy(tm, &current_time, sizeof(Time));
}

void
update_jiffy() {
	jiffy ++;
	if (jiffy % HZ == 0) {
		current_time.second++;
		if (current_time.second == 60) {
			current_time.second = 0;
			current_time.minute ++;
			if (current_time.minute == 60) {
				current_time.minute = 0;
				current_time.hour++;
				if (current_time.hour == 24) {
					current_time.hour = 0;
					current_time.day++;
				}
			}
		}
	}
}
