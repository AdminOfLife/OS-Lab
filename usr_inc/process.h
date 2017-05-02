#ifndef __PROCESS_H__
#define __PROCESS_H__

#include <usr_inc/types.h>
#include <usr_inc/fork.h>


uint32_t get_pid();
void exit();
void sleep(uint32_t);

#endif
