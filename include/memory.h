#ifndef KERN_INC_MEM
#define KERN_INC_MEM

#include <include/list.h>

#define MAX_MEM 0x20000000
#define USER_STACK_TOP 0x8000000
#define USER_STACK_SIZE 0x400000

typedef struct {
	uint32_t base, limit, cs, ds;
	ListHead list;
} SegMan;

typedef struct {
	uint32_t addr;
	ListHead list;
} PgMan;

#endif
