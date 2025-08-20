nx_editor_export()
{
	export EDITOR="$(nx_cmd_editor)"
	case "$EDITOR" in
		*vim)
			{
				export VIMINIT="source $G_NEX_ROOT/lib/viml/init.vim"
			};;
	esac
}

nx_editor_export

