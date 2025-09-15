
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
