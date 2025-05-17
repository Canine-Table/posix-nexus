#!/bin/sh

nx_asm_export()
{
	case "$(nx_str_case -l "$(uname -m)")" in
		'x86_64')
			{
				export G_NX_ASM_ARCH='amd64'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='64'
			};;
		'i686')
			{
				export G_NX_ASM_ARCH='x86'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='32'
			};;
		'armv7l')
			{
				export G_NX_ASM_ARCH='arm'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='32'
			};;
		'aarch64')
			{
				export G_NX_ASM_ARCH='arm64'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='64'
			};;
		'armv8l')
			{
				export G_NX_ASM_ARCH='arm84'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='64'
			};;
		'mips')
			{
				export G_NX_ASM_ARCH='mips'
				export G_NX_ASM_ENDIAN='1'
				export G_NX_ASM_BIT='32'
			};;
		'mips64')
			{
				export G_NX_ASM_ARCH='mips64'
				export G_NX_ASM_ENDIAN='1'
				export G_NX_ASM_BIT='64'
			};;
		'ppc')
			{
				export G_NX_ASM_ARCH='powerpc'
				export G_NX_ASM_ENDIAN='1'
				export G_NX_ASM_BIT='32'
			};;
		'ppc64')
			{
				export G_NX_ASM_ARCH='powerpc64'
				export G_NX_ASM_ENDIAN='1'
				export G_NX_ASM_BIT='64'
			};;
		'riscv64')
			{
				export G_NX_ASM_ARCH='riscv'
				export G_NX_ASM_ENDIAN='0'
				export G_NX_ASM_BIT='64'
			};;
		*)
			{
				echo "Unknown architecture: $(uname -m)"
				return 1
			};;
	esac
}

nx_8bit_asm()
{
	[ -n "$1" ] && h_nx_cmd zasm && {
		zasm --reqcolon --asm8080 "${1}.asm" -o "${1}.bin"
		zasm --reqcolon --asm8080 "${1}.asm" -x -o "${1}.hex"
	}
}

nx_8bit_al8800bt_rom()
{
	#https://www.planetemu.net/rom/mame-roms/al8800bt
	[ -n "$1" ] && h_nx_cmd mame unzip && {
		! [ "$G_NEX_MOD_ENV/rom/al8800bt/88dskrom.bin" -a "$G_NEX_MOD_ENV/rom/al8800bt/turnmon.bin" ] && {
			unzip "$G_NEX_MOD_CNF/al8800bt.zip" -d "$G_NEX_MOD_ENV/rom/al8800bt/"
		}
		mame al8800bt -window -nowindow -rompath "$G_NEX_MOD_ENV/rom/" -flop "$1"
	}
}

nx_elf_asm()
{
	if [ "$1" = '-c' ]; then
		(
			for f in "$(pwd)/."* "$(pwd)/"*; do
				case "$(nx_str_case -l "$f")" in
					*.s|*.asm|*.c|*.h|*.cpp|*.hpp|*.rs|Makefile);;
					*) rm "$f" 2>/dev/null;;
				esac
			done
		)
	elif [ -n "$1" ]; then
		h_nx_cmd nasm && {
			nx_bundle_include -s '@' -i "${1}.asm" -o ".${1}.S" -f -d 'nx_include'
			nasm -f elf64 -o ".${1}.o" ".${1}.S"
		}
		h_nx_cmd arm-openwrt-linux-muslgnueabi-gcc && {
			nx_bundle_include -s '@' -i "${1}.s" -o ".${1}.S" -f -d 'nx_include'
			as -o ".${1}.o" ".${1}.S"
		}
		[ -e ".${1}.o" ] && (
			ld ".${1}.o" -o "$1"
			h_nx_cmd tty stty && d="$(nx_str_div)"
			echo -n $d
			h_nx_cmd objdump && {
				objdump -d "$1" 
				echo -n $d
			}
			./"${1}"
			echo -e "\n$d"
			return
		)
		return 1
	fi
}

