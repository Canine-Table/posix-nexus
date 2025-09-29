
nx_pod_id()
{
	test -n "$G_NEX_CONTAINER" -a -n "$1" && "$G_NEX_CONTAINER" inspect --format '{{.Id}}' "$1"
}

nx_pod_root()
{
	"$G_NEX_CONTAINER" info --format '{{.Store.GraphRoot}}'
}

nx_pod_sdir()
{
	nx_data_jdump "$("$G_NEX_CONTAINER" inspect "$1")" | ${AWK:-$(nx_cmd_awk)} -F '= ' '/nx\[1\]\.StaticDir/{print $2}'
}

nx_pod_pid()
{
	"$G_NEX_CONTAINER" inspect -f '{{.State.Pid}}' "$1"
}

nx_pod_exec()
{
	"$G_NEX_CONTAINER" exec -it "$(nx_pod_id "$1")" sh
}

nx_pod_new()
(
	eval "$(nx_str_optarg ':c:d:' "$@")"
	test -z "$d" && d="$HOME"
	test -z "$c" && c="alpine"
	tmpa="$(nx_io_noclobber -p "$d/$c")"
	mkdir -p "$tmpa"
	"$G_NEX_CONTAINER" export "$("$G_NEX_CONTAINER" create "$c")" | tar -x -C "$tmpa"
)

