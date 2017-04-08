int
syscall(int id, ...) {
	int ret;
	int *args = &id;
	asm volatile("int $0x80": "=a"(ret) : "a"(args[0]), "c"(args[1]), "d"(args[2]), "b"(args[3]));
	return ret;
}
