
x
/2/{
	x
	/[\]$/!{
		x
		s/2//
		x
	}
	s/.*//
	b next
}
/1/{
	x
	s/.*\([^\]\|^\)[*]\//\1/
	t end
	s/.*//
	b next
}
x

/[ \t\r\f\v\n\0]*\/\//{
	/\\$/{
		x
		s/^/2/
		x
	}
	s/.*//
	b next
}

s/\([^\]\|^\)\/[*].*/\1/
t start
b next

:start
x
s/$/1/
x
b next

:end
x
s/1//
x

:next
/^$/d

