
###:( get ):##################################################################################

get_cmd()
{
        while [ ${#@} -gt 0 ]; do
                command -v "$1" && return
                shift
        done
        return 1
}

get_cmd_pager()
{
        get_cmd less more tee
}

get_cmd_awk()
{
        get_cmd mawk nawk awk gawk
}

get_cmd_shell()
{
        get_cmd dash sh ash mksh posh yash ksh loksh pdksh bash zsh fish
}

get_cmd_editor()
{
	get_cmd nvim vim gvim emacs subl vi
}

get_cmd_pdf_viewer()
{
	get_cmd zathura evince okular mupdf
}

get_cmd_tex_compiler()
{
	get_cmd pdflatex lualatex 
}

###:( set ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################
###:( del ):##################################################################################
###:( is ):###################################################################################
##############################################################################################

