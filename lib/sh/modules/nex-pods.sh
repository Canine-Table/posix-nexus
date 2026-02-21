
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

