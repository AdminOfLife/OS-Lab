#ifndef __TIMER_H__
#define __TIMER_H__

#include <usr_inc/syscall.h>
#include <usr_inc/types.h>
#include <usr_inc/time.h>


void update_time(long);
long get_time();

#endif
