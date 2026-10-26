nx_yt_playbook()
(
	h_nx_cmd yt-dlp ffmpeg || exit 127

	nx_data_longopt -- ',
	l<%language>
	<default en>

	f<%format>
	<default bestvideo+bestaudio/best>
	s<%src source>

	L<list>
	<build yt-dlp --list-formats <nx@s/\\>;>

	J<json>
	<build yt-dlp -j <nx@s/\\>;>

	d<%dst destination>
	<default $NEXUS_ENV/tmp>

	c<chapter>
	<default <nx:false/\\>>

	t<%timeline>
	<regex ^[0-9]+:[0-9]{1,2}(:[0-9]{2})?-([0-9]{1,2}:[0-9]{2})?$>

	help<h>
	<description Show help>
	<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	test "$NEX_Gf_c" = '<nx:false/>' && NEX_Gf_c='*' || NEX_Gf_c=''

	yt-dlp ${NEX_Gk_t:+--download-sections "$NEX_Gf_c$NEX_Gk_t"} \
		-f "$NEX_Gk_f" \
		--write-subs \
		--sub-lang "$NEX_Gk_l" \
		-o "$NEX_Gk_d/%(title)s.%(ext)s" \
		-k \
		"$NEX_Gk_s"
)

