#!/bin/sh

nx_test_box()
{
	${AWK:-$(get_cmd_awk)} "
		$(nx_init_include -i "$G_NEX_MOD_LIB/awk/nex-struct.awk")
	"'
		function nx_print_box(a, b, c, d) {
			if  (--d <= 0)
				return
			printf("typedef const *%s nx_%s_P%st;\n", a, b, c);
			nx_print_box(a " const *", b, "P" c, d);
			printf("typedef const *%s nx_%s_P%st;\n", a, b, c);

			printf("typedef %s *const nx_%s_p%sT;\n", a, b, c);
			printf("typedef const %s *const nx_%s_P%sT;\n", a, b, c);
		}
		BEGIN {
			nx_print_box("int", "dd", "u", 3)
		}
	'
}

