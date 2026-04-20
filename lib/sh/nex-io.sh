nx_io_prompt()
{
	nx_tty_print -F '_b>L%_ui>A%>L_nb%>S%' '┌──[' "${*:-Nexus Shell}" ']\n│\n└' '$ '
}

nx_io_yn()
(
	nx_io_prompt "$*${*:+ }(y/n)"
	nx_tty_hault
	test "$tmpa" = 'y' -o "$tmpa" = 1
)

