#include "nex-define.h"
#include "nex-math.h"
#include "nex-string.h"

nx_dm_str_class_M(bin)
{
	return nx_dm_range_M(s, '0', '1');
}

nx_dm_str_class_M(blank)
{
	return (s == ' ') ? 1 : (s == '\t');
}

nx_dm_str_class_M(space)
{
	return (s == ' ') ? 1 : nx_dm_range_M(s, '\b', '\r');
}

nx_dm_str_class_M(punct)
{
	return nx_dm_range_M(s, '!', '/') || nx_dm_range_M(s, ':', '@') || nx_dm_range_M(s, '[', '`') || nx_dm_range_M(s, '{', '~');
}

nx_dm_str_class_M(oct)
{
	return nx_dm_range_M(s, '0', '7');
}

nx_dm_str_class_M(dec)
{
	return nx_dm_range_M(s, '0', '9');
}

nx_dm_str_class_M(lhex)
{
	return nx_dm_range_M(s, 'a', 'f');
}

nx_dm_str_class_M(uhex)
{
	return nx_dm_range_M(s, 'A', 'F');
}

nx_dm_str_class_M(islhex)
{
	return nx_lhex_isF(s) || nx_dec_isF(s);
}

nx_dm_str_class_M(isuhex)
{
	return nx_uhex_isF(s) || nx_dec_isF(s);
}

nx_dm_str_class_M(hex)
{
	return nx_lhex_isF(s) || nx_uhex_isF(s) || nx_dec_isF(s);
}

nx_dm_str_class_M(lower)
{
	return nx_dm_range_M(s, 'a', 'z');
}

nx_dm_str_class_M(upper)
{
	return nx_dm_range_M(s, 'A', 'Z');
}

nx_dm_str_class_M(alpha)
{
	return nx_lower_isF(s) || nx_upper_isF(s);
}

nx_dm_str_class_M(alnum)
{
	return nx_alpha_isF(s) || nx_dec_isF(s);
}

nx_dm_str_class_M(ctrl)
{
	return (s == 0x7F) ? 1 : nx_dm_range_M(s, '\0', 0x1F);
}

nx_dm_str_class_M(graph)
{
	return nx_alnum_isF(s) || nx_ctrl_isF(s);
}

nx_dm_str_class_M(print)
{
	return (s == ' ') ? 1 : nx_graph_isF(s);
}

nx_dm_str_class_M(word)
{
	return (s == '_') ? 1 : nx_alpha_isF(s);
}

nx_dM_str_case_M(lower, upper, 32)

nx_dM_str_case_M(upper, lower, -32)

