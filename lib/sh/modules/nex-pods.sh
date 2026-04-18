
nx_pod_id()
{
	$G_NEX_CONTAINER inspect --filter='{{.ID}}' "$1"
}

nx_pod_isUp()
{
	test "$($G_NEX_CONTAINER  inspect --format='{{.State.Running}}' "$1")" = 'true'
}

nx_pod_run()
{
	if nx_pod_isUp "$1"; then
		$G_NEX_CONTAINER restart "$1"
	else
		$G_NEX_CONTAINER start "$1"
	fi
}

nx_pod_status()
{
    $G_NEX_CONTAINER inspect --format='{{.State.Status}}' "$1"
}

nx_pod_exists()
{
    $G_NEX_CONTAINER inspect "$1" >/dev/null 2>&1
}


nx_pod_info()
{
    nx_data_jtree -j "$($G_NEX_CONTAINER inspect "$1")"
}

nx_pod_rm()
{
    nx_pod_exists "$1" && $G_NEX_CONTAINER rm "$1"
}

nx_pod_shell()
{
    $G_NEX_CONTAINER exec -it "$1" sh
}

nx_pod_logs()
{
    $G_NEX_CONTAINER logs "$1"
}

nx_pod_stop()
{
    $G_NEX_CONTAINER stop "$1"
}

