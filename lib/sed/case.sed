:nx_start

/^ *<nx:toupper\/>/{
	s/^ *<nx:toupper\/>//1
	y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/
	b nx_start
}

/^ *<nx:tolower\/>/{
	s/^ *<nx:tolower\/>//1;
	y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/
	b nx_start
}

