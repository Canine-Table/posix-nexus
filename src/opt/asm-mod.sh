#!/bin/sh

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

nx_elf64_asm()
{
	if [ "$1" = '-c' ]; then
		(
			for f in "$(pwd)/"*; do
				case "$f" in
					*.s|*.asm|*.c|*.h|*.cpp|*.hpp);;
					*) rm "$f";;
				esac
			done
		)
	elif [ -n "$1" ]; then
		h_nx_cmd nasm && nasm -f elf64 "${1}.asm" -o "${1}.o"
		h_nx_cmd arm-openwrt-linux-muslgnueabi-gcc && as -o "${1}.o" "${1}.s"
		[ -e "${1}.o" ] && {
			ld "${1}.o" -o "$1"
			./"${1}"
			return
		}
		return 1
	fi
}

