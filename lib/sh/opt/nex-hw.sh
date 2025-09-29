
nx_hw_search()
(
	tmpa=$(find "$(nx_info_canonize "$1")/" -type f 2>/dev/null) || {
		tmpa="$(printf '%s' "$1" | ${AWK:-$(nx_cmd_awk)} '{sub(/[^/]+$/, "", $0); print}')"
		nx_io_printf -E "'$1' yields no glyphs. The kernel's altar is silent—no files found beneath '$tmpa'. Verify your offering and invoke again." 1>&2
			test "$2" != '<nx:pad/>' -a -d "$tmpa" && {
				printf '\n%s\n' "$(nx_tty_div -s)"
				for tmpa in $(ls -A "$tmpa"); do
					nx_io_printf -I "$tmpa" | tr '\n' ' '
				done
				printf '\n%s\n' "$(nx_tty_div -d)"
			}
		exit 1
	}
	shift 2 2>/dev/null || {
		nx_io_printf -E 'Invoke again, but this time—bring a real device. Or confess your path was false.' 1>&2
		exit 2
	}
	nx_info_list $(printf '%s' "$tmpa" | (test "$#" -gt 0 && {
		${AWK:-$(nx_cmd_awk)} -v fltr="$(nx_str_chain "$@")" "
			$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
		"'
			BEGIN {
				if (bas = split(fltr, fls, "<nx:null/>")) {
					do {
						nx_bijective(fls, bas, 0, fls[bas])
					} while (--bas > 0)
				}
			} {
				bas = $0
				sub(/^.*\//, "", bas)
				if (bas in fls)
					printf("%s ", $0)
			} END {
				delete fls
			}
		'
	} || tee | tr '\n' ' '))
)

nx_hw_block()
{
	nx_hw_search "/sys/block/$1" $@
}

nx_hw_firm()
{
	nx_hw_search "/sys/firmware/$1" $@
}

nx_hw_bus()
{
	nx_hw_search "/sys/bus/$1" $@
}

nx_hw_mod()
{
	nx_hw_search "/sys/module/$1" $@
}

nx_hw_usb()
{
	nx_hw_search "/sys/bus/usb/devices/$1" $@
}

nx_hw_kern()
{
	nx_hw_search "/proc/sys/kernel" '<nx:pad/>' $@
}

nx_hw_dmi()
{
	nx_hw_search '/sys/devices/virtual/dmi/id' '<nx:pad/>' $@
}

__nx_hw_dmi()
(
	for tmpa in $(ls -d "/sys/firmware/dmi/entries/$1-"*); do
		nx_hw_search "$tmpa" $@
	done
)

nx_hw_dmi_bios()    { __nx_hw_dmi '0' $@; }   # BIOS Information
nx_hw_dmi_sys()     { __nx_hw_dmi '1' $@; }   # System Information
nx_hw_dmi_board()   { __nx_hw_dmi '2' $@; }   # Base Board Information
nx_hw_dmi_chassis() { __nx_hw_dmi '3' $@; }   # Chassis Information
nx_hw_dmi_proc()    { __nx_hw_dmi '4' $@; }   # Processor Information
nx_hw_dmi_cache()   { __nx_hw_dmi '7' $@; }   # Cache Information
nx_hw_dmi_ports()   { __nx_hw_dmi '8' $@; }   # Port Connector Information
nx_hw_dmi_slots()   { __nx_hw_dmi '9' $@; }   # System Slot Information
nx_hw_dmi_onboard() { __nx_hw_dmi '10' $@; }  # On Board Device Information
nx_hw_dmi_oemstr()  { __nx_hw_dmi '11' $@; }  # OEM Strings
nx_hw_dmi_config()  { __nx_hw_dmi '12' $@; }  # System Configuration Options
nx_hw_dmi_lang()    { __nx_hw_dmi '13' $@; }  # BIOS Language Information
nx_hw_dmi_groups()  { __nx_hw_dmi '14' $@; }  # Group Associations
nx_hw_dmi_memarray(){ __nx_hw_dmi '16' $@; }  # Physical Memory Array
nx_hw_dmi_memdev()  { __nx_hw_dmi '17' $@; }  # Memory Device
nx_hw_dmi_memmap()  { __nx_hw_dmi '19' $@; }  # Memory Array Mapped Address
nx_hw_dmi_memaddr() { __nx_hw_dmi '20' $@; }  # Memory Device Mapped Address
nx_hw_dmi_tpm()     { __nx_hw_dmi '43' $@; }  # TPM Device (OEM)
nx_hw_dmi_fwinv()   { __nx_hw_dmi '45' $@; }  # Firmware Inventory Information
nx_hw_dmi_boot()    { __nx_hw_dmi '32' $@; }  # System Boot Information
nx_hw_dmi_mgmtdev() { __nx_hw_dmi '34' $@; }  # Management Device
nx_hw_dmi_mgmtcomp(){ __nx_hw_dmi '35' $@; }  # Management Device Component
nx_hw_dmi_mgmtth()  { __nx_hw_dmi '36' $@; }  # Management Device Threshold Data
nx_hw_dmi_voltage() { __nx_hw_dmi '26' $@; }  # Voltage Probe
nx_hw_dmi_temp()    { __nx_hw_dmi '28' $@; }  # Temperature Probe
nx_hw_dmi_current() { __nx_hw_dmi '29' $@; }  # Electrical Current Probe
nx_hw_dmi_cooling() { __nx_hw_dmi '27' $@; }  # Cooling Device
nx_hw_dmi_psu()     { __nx_hw_dmi '39' $@; }  # System Power Supply
nx_hw_dmi_oem219()  { __nx_hw_dmi '219' $@; } # Intel MEI and platform firmware overlays
nx_hw_dmi_oem221()  { __nx_hw_dmi '221' $@; } # BIOS Guard, RST, Thunderbolt, debug flags
nx_hw_dmi_oem130()  { __nx_hw_dmi '130' $@; } # ASUS OEM extension
nx_hw_dmi_oem131()  { __nx_hw_dmi '131' $@; } # ASUS OEM extension
nx_hw_dmi_oem136()  { __nx_hw_dmi '136' $@; } # ASUS OEM extension
nx_hw_dmi_end()     { __nx_hw_dmi '127' $@; } # End of Table

nx_hw_fbuf()
{
	nx_hw_search "/sys/class/graphics/$1" $@
}

nx_hw_iface()
{
	nx_hw_search "/sys/class/net/$1" $@
}

nx_hw_cam()
{
	nx_hw_search "/sys/class/video4linux/$1" $@
}

nx_hw_drm()
{
	nx_hw_search "/sys/class/drm/$1" "$@"
}


nx_hw_backlight()
(
	eval "$(nx_str_optarg ':d:' "$@")"
	tmpa=$(find "$(nx_info_canonize "/sys/class/backlight/$d")/" -type f 2>/dev/null) || {
		nx_io_printf -E "Backlight device '$d' yields no glyphs. The kernel's altar is silent—no files found beneath /sys/class/backlight. Verify your offering and invoke again." 1>&2
		nx_io_printf -I "$(ls /sys/class/backlight -A)"
		exit 1
	}
	while test "$#" -gt 0; do
		case "$1" in
			-b)
				{
					test "$2" -ge 0 -a "$2" -le 100 && {
						printf '%d' "$2" > "/sys/class/backlight/$d/brightness"
						shift
					}
				};;
		esac
		shift
	done
)

nx_hw_edid()
{
	h_nx_cmd edid-decode || {
		nx_io_printf -E "Cannot decode EDID: edid-decode not available or failed. Ensure it's installed and in PATH." 2>&1
		return 1
	}
	cat /sys/class/drm/card*/edid | edid-decode
}

nx_hw_i2c_detect()
{

	h_nx_cmd i2cdetect && {
		tmpa="$(ls -1 /dev/i2c-* | wc -l)"
		tmpb=0
		while test "$tmpb" -lt "$tmpa"; do
			nx_io_printf  -i "/dev/i2c-$tmpb"
			i2cdetect -y "$tmpb"
			tmpb="$((tmpb + 1))"
		done
	}
}

__nx_hw_cpu_emitter()
{
	tmpb=0
	tmpc=""
	while test "$tmpb" -lt "$tmpa"; do
		tmpc="$tmpc $1 $tmpb"
		tmpb="$((tmpb + 1))"
	done
	__nx_hw_cpu $tmpc
}

__nx_hw_cpu()
{
	while test "$#" -gt 0; do
		case "$1" in
			-t) printf '%s\n' "$tmpa";;
			-1) cat /sys/devices/system/cpu/offline;;
			-0) cat /sys/devices/system/cpu/online;;
			-c) {
				test "$2" -ge 0 -a "$2" -lt "$tmpa" 2> /dev/null && {
					nx_io_printf -f '<A>D_b%_n>I%>S%>I%>S%' \
						"\ncpu$2" \
						"\ncore_id: " "$(cat /sys/devices/system/cpu/cpu$2/topology/core_id)" \
						"\nphysical_package_id: " "$(cat /sys/devices/system/cpu/cpu$2/topology/physical_package_id)\n"
					shift
				} || __nx_hw_cpu_emitter '-c'
			};;
			-s) {
				test "$2" -ge 0 -a "$2" -lt "$tmpa"  2> /dev/null && {
					freq_path="/sys/devices/system/cpu/cpu$2/cpufreq"
					if test -d "$freq_path"; then
						nx_io_printf -f '<A>D_b%_n>I%>S%>I%>S%>I%>S%>I%>S%' \
						"\ncpu$2" \
						"\ncurrent_freq: " "$(cat $freq_path/scaling_cur_freq)" \
						"\nmax_freq: " "$(cat $freq_path/cpuinfo_max_freq)" \
						"\nmin_freq: " "$(cat $freq_path/cpuinfo_min_freq)" \
						"\nscaling_governor: " "$(cat "$freq_path/scaling_governor")\n"
					else
						nx_io_printf -a "cpu$2 has no cpufreq interface" 1>&2
					fi
					shift
				} || __nx_hw_cpu_emitter '-s'
			};;
		esac
		shift
	done
}

nx_hw_cpu()
(
	tmpa=$(ls -1 /sys/class/cpuid | wc -l)
	__nx_hw_cpu "$@"
)

nx_hw_mem()
{
	${AWK:-$(nx_cmd_awk)} "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-shell.awk")
	"'
		{
			s = nx_bit_size($2, __nx_else($3, "B"))
			l = __nx_if(length($1) > 7, __nx_if(length($1) > 15, "\t", "\t\t"), "\t\t\t")
			sub(" ", "<nx:null/> ", s)
			print nx_printf("_b>I%>S%>A%_n", $1 l "<nx:null/>" s)
		}
	' /proc/meminfo
}

