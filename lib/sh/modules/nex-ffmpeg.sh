#nx_include nex-cmd.sh
#nx_include nex-str.sh
#nx_include nex-data.sh

__h_nx_ffmpeg()
{
	h_nx_cmd ffmpeg || {
		nx_tty_print -e 'ffmpeg not found'
		exit 127
	}
}

__h_nx_ffprobe()
{
	h_nx_cmd ffprobe || {
		nx_tty_print -e 'ffprobe not found'
		exit 127
	}
}

__nx_ffprobe_entries()
{
	__h_nx_ffprobe || exit 127
	ffprobe -v error -select_streams $3:${2:-0} \
		-show_entries \
		stream=codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels,duration:format=duration,size,bit_rate \
		-of default=noprint_wrappers=1 "$1" | ${AWK:-$(nx_cmd_awk)} -v stream="$3" -F '=' '{
		printf("L_NEX_FFPROBE_%s=\x27%s\x27 ", toupper(stream "_" $1), $2)
	}'
}

__nx_ffprobe_video()
{

	__nx_ffprobe_entries "$1" "$2" '-v'
}

__nx_ffprobe_audio()
{

	__nx_ffprobe_entries "$1" "$2" '-a'
}


nx_ffmpeg_crop()
(
	__h_nx_ffmpeg
	nx_data_longopt -- ',
		f<%from>
		<regex ^(([0-9]+:)?[0-9]{1,2}:)?[0-9]{1,2}$>

		t<%to>
		<regex ^(([0-9]+:)?[0-9]{1,2}:)?[0-9]{1,2}$>

		i<%input>

		o<%output>

		h<help>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test -f "${NEX_Gk_i:=$NEX_ARGV_S}" || exit 227

	ffmpeg \
		-ss "$NEX_Gk_f" \
		-i "$NEX_Gk_i" \
		-to "$NEX_Gk_t" \
		-c copy \
		"${NEX_Gk_o:-"$(nx_fs_noclobber --verbose "$NEX_Gk_i")"}"
)

nx_ffmpeg_webm_img2vid()
(
	__h_nx_ffmpeg
	nx_data_longopt -- ',
		l<%loop>
		<default 1>

		d<%duration>
		<default 3>

		i<%input>

		o<%output>

		q<%quality>
		<type int>
		<min 0>
		<max 63>
		<default 30>

		r<%reference>

		h<help>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test -f "${NEX_Gk_i:=$NEX_ARGV_S}" || exit 227

	if test -n "$NEX_Gk_r"; then
		__nx_ffmpeg_entries "$NEX_Gk_r"
	else
		L_NEX_FFPROBE_V_WIDTH=640
		L_NEX_FFPROBE_V_HEIGHT=360
		L_NEX_FFPROBE_V_R_FRAME_RATE=30
	fi

	ffmpeg \
		-loop "$NEX_Gk_l" \
		-t "$NEX_Gk_d" \
		-i "$NEX_Gk_i" \
		-vf "scale=$L_NEX_FFPROBE_WIDTH:$L_NEX_FFPROBE_HEIGHT:force_original_aspect_ratio=increase,crop=$L_NEX_FFPROBE_V_WIDTH:$L_NEX_FFPROBE_V_HEIGHT,setsar=1,fps=$L_NEX_FFPROBE_V_R_FRAME_RATE" \
		-c:v libvpx-vp9 \
		-crf "$NEX_Gk_q" \
		-b:v 0 \
		-an "${NEX_Gk_o:-"$(nx_fs_noclobber --verbose "$NEX_Gk_i.webm")"}"
)

nx_ffmpeg_silent_audio()
(
	__h_nx_ffmpeg
	nx_data_longopt -- ',
		i<%input>

		o<%output>

		r<%reference>

		h<help>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test -f "${NEX_Gk_i:=$NEX_ARGV_S}" || exit 227

	if test -n "$NEX_Gk_r"; then
		__nx_ffmpeg_audio "$NEX_Gk_r"
	else
		L_NEX_FFPROBE_CHANNEL_LAYOUT="stereo"
		L_NEX_FFPROBE_SAMPLE_RATE="48000"
	fi

	ffmpeg  \
		-i "$NEX_Gk_i" \
		-f lavfi \
		-i "anullsrc=sample_rate=$L_NEX_FFPROBE_A_CHANNEL_LAYOUT:channel_layout=$L_NEX_FFPROBE_A_SAMPLE_RATE" \
		-map 0:v:0 \
		-map 1:a:0 \
		-shortest \
		-c:v copy \
		-c:a libopus \
		-b:a 128k \
		-an "${NEX_Gk_o:-"$(nx_fs_noclobber --verbose "$NEX_Gk_i")"}"
)

nx_ffmpeg_concat()
(
	__h_nx_ffmpeg
	nx_data_longopt --concat '\n' --Directive-Suffix-Trim -- ',
		i<%input>
		<prepend printf "%s\n" "file $(nx_fs_path --file >
		<append )">

		o<%output>

		r<%reference>

		f<%format>
		<default mp4>
	' "$@"

	__nx_fs_pipe --force  --value "$(eval "$NEX_Gk_i")" 2>&1 1>/dev/null
	L_NEX_FIFO="$NEX_Gk_p"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"

	ffmpeg \
		-f concat -safe 0 -i "$NEX_Gk_p" \
		-c copy "${NEX_Gk_o:-"$(nx_fs_noclobber --verbose "concat.$NEX_Gk_f")"}"

	__nx_fs_pipe --remove "$NEX_Gk_FIFO"
)

