
__nx_ffmpeg()
{
	h_nx_cmd ffmpeg || {
		nx_io_printf -W "ffmpeg not found! The forge of media transmutation lies cold—no frames shall be split, no streams shall be summoned." 1>&2
		return 1
	}
}

__nx_ffmpeg_out()
{
	nx_io_type -f "$i" rf || {
		nx_io_printf -E "'$i' is no readable scroll. The glyph cannot be parsed—no file, no ritual, no invocation." 1>&2
		exit 1
	}
	o="$(nx_io_backup "${o:-$i}" ${e:+"$e"})" || exit 2
}

__nx_ffmpeg_px()
{

	${AWK:-$(nx_cmd_awk)} \
		-v fm="$f" \
		-v to="$t" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct.awk")
	"'
		BEGIN {
			nx_trim_split(fm, fa, ",")
			nx_trim_split(fo, ta, ",")
			split("rgb", rgb, "")
		
			for (i = 1; i <= 3; ++i)
				s = s ":" rgb[i] "=\x27if(" __nx_else(int(fa[i]) % 256, "0") "," __nx_else(int(ta[i]) % 256, "0") ",val)\x27"
			
			delete rgb
			delete fa
			delete ta
			print substr(s, 2)
		}
	'
}

nx_ffmpeg_chng()
(
	__nx_ffmpeg || exit
	eval "$(nx_str_optarg ':e:i:o:f:t:' "$@")"
	__nx_ffmpeg_out
	__nx_ffmpeg_px
	ffmpeg -i "$i" -vf "lut=$(__nx_ffmpeg_px)" ${e:+-c:v $e} "$o"
)

nx_ffmpeg_ccmx()
(
	__nx_ffmpeg || exit
	eval "$(nx_str_optarg ':e:i:o:f:t:' "$@")"
	__nx_ffmpeg_out
	__nx_ffmpeg_px
	ffmpeg -i "$i" -vf "lut=$(__nx_ffmpeg_px),format=argb,colorchannelmixer=.3:.3:.3:0:0:0:0:1" "$o"
)

nx_ffmpeg_wtrm()
(
	__nx_ffmpeg || exit
	eval "$(nx_str_optarg ':e:i:o:c:t:b:' "$@")"
	__nx_ffmpeg_out
	ffmpeg -i "$i" -vf "colorkey=0x${c:-FFFFFF}:${t:-0.01}:${b:-0.0}" ${e:+-c:v $e} "$o"
	#ffmpeg -i "$i" -vf "curves=red='0/0 0.5/0.5 1/1':green='0/0 0.5/0.5 1/1':blue='0/0 0.5/0.5 1/1', format=rgba, colorchannelmixer=.3:.3:.3:0:0:0:0:1" "$o"
)


