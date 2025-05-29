##:(Nexus Modules):###########################################################################

nx_content_root
nx_content_modules
nx_tex_export
nx_editor_export
nx_asm_export
nx_tmux_export
nx_container_export

export G_NEX_WEB_FETCH="$(g_nx_cmd curl wget)"
export LESS='-R'
export COLORFGBG=';0'
export DIALOGRC="$G_NEX_MOD_CNF/.dialogrc"
export PAGER="$(nx_cmd_pager)"
export SHELL="$(nx_cmd_shell)"
export AWK="$(nx_cmd_awk)"
export PKGMGR="$(nx_cmd_pkgmgr)"
export CC="$(nx_cmd_cc)"

##############################################################################################

