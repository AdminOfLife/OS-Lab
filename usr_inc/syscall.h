#ifndef __SYSCALL_H__
#define __SYSCALL_H__


enum {CHECK_KEY, GET_KEY, BACK_SPACE, PRINT_CHAR, UPDATE_CURSOR, PRINT_TO_TERMINAL, UPDATE_TIME, GET_TIME};

int syscall(int id, ...);

#endif
