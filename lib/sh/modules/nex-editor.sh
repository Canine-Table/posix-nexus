nx_editor_export()
{
	export EDITOR="$(nx_cmd_editor)"
	export VISUAL="$EDITOR"
	case "$EDITOR" in
		*vim)
			{
				export VIMINIT="source ${NEXUS_LIB}/viml/nex-init.vim"
			};;
	esac
}

export E_NEX_EDITOR=true

