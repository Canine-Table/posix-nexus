#nx_include nex-str.sh

nx_asm_export()
{
	case "$(nx_str_case -l "$(uname -m)")" in
		*'x86_64'*)
			{
				export G_NEX_ASM_ARCH='amd64'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'i686')
			{
				export G_NEX_ASM_ARCH='x86'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='32'
			};;
		'armv7l')
			{
				export G_NEX_ASM_ARCH='arm'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='32'
			};;
		'aarch64')
			{
				export G_NEX_ASM_ARCH='arm64'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'armv8l')
			{
				export G_NEX_ASM_ARCH='arm84'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		'mips')
			{
				export G_NEX_ASM_ARCH='mips'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='32'
			};;
		'mips64')
			{
				export G_NEX_ASM_ARCH='mips64'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='64'
			};;
		'ppc')
			{
				export G_NEX_ASM_ARCH='powerpc'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='32'
			};;
		'ppc64')
			{
				export G_NEX_ASM_ARCH='powerpc64'
				export G_NEX_ASM_ENDIAN='1'
				export G_NEX_ASM_BIT='64'
			};;
		'riscv64')
			{
				export G_NEX_ASM_ARCH='riscv'
				export G_NEX_ASM_ENDIAN='0'
				export G_NEX_ASM_BIT='64'
			};;
		*)
			{
				nx_tty_print -e "Unknown architecture: $(uname -m)"
				return 1
			};;
	esac
}

