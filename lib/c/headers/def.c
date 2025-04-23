#ifndef NX_CPU_CORES
static inline nx_u32_t nx_cpu_cores()
{
	nx_u32_t c;
	nx_size_t s = sizeof(c);
	sysctlbyname("hw.logicalcpu", &c, &s, NX_NULL, 0);
	return c;
}
#define NX_CPU_CORES nx_cpu_cores()
#endif

/* Swap 16-bit endian */
static inline nx_u16_t nx_swap16(nx_u16_t v)
{
	return (v >> 8) | (v << 8);
}

/* Swap 32-bit endian */
static inline nx_u32_t nx_swap32(nx_u32_t v)
{
	return ((v >> 24) & 0x000000FF) |
		((v >> 8)  & 0x0000FF00) |
		((v << 8)  & 0x00FF0000) |
		((v << 24) & 0xFF000000);
}

/* Swap 64-bit endian */
static inline nx_u64_t nx_swap64(nx_u64_t v)
{
	return ((v >> 56) & 0x00000000000000FF) |
		((v >> 40) & 0x000000000000FF00) |
		((v >> 24) & 0x0000000000FF0000) |
		((v >> 8)  & 0x00000000FF000000) |
		((v << 8)  & 0x000000FF00000000) |
		((v << 24) & 0x0000FF0000000000) |
		((v << 40) & 0x00FF000000000000) |
		((v << 56) & 0xFF00000000000000);
}
