#!/bin/sh

nx_struct_ref()
{
	[ -n "$1" ] && eval "echo \$$1"
}

nx_struct_ref_append()
{
	(
		v=$(nx_struct_ref "$1")
		[ -n "$v" -a -n "$2" ] && v="${v}${3:-,}"
		echo "$v$2"
	)
}

