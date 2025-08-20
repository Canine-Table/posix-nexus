#ifndef nx_Dm_string_H
#define nx_Dm_string_H

#define nx_dm_str_class_M(D) nx_d_isT nx_##D##_isF(nx_d_cT s)
#define nx_dm_str_case_M(D) nx_d_pcT nx_to##D##_pcF(nx_d_pcT c)
#define nx_dM_str_case_M(D1, D2, D3) nx_dm_str_case_M(D1) \
{ \
	nx_d_isT l = -1; \
	while (c[++l] != '\0') { \
		if (nx_##D2##_isF(c[l])) \
			c[l] = c[l] + D3; \
	} \
	return c; \
}

nx_dm_str_class_M(bin);
nx_dm_str_class_M(blank);
nx_dm_str_class_M(space);
nx_dm_str_class_M(punct);
nx_dm_str_class_M(oct);
nx_dm_str_class_M(dec);
nx_dm_str_class_M(lhex);
nx_dm_str_class_M(uhex);
nx_dm_str_class_M(islhex);
nx_dm_str_class_M(isuhex);
nx_dm_str_class_M(hex);
nx_dm_str_class_M(lower);
nx_dm_str_class_M(upper);
nx_dm_str_class_M(alpha);
nx_dm_str_class_M(alnum);
nx_dm_str_class_M(ctrl);
nx_dm_str_class_M(graph);
nx_dm_str_class_M(print);
nx_dm_str_class_M(word);

nx_dm_str_case_M(lower);
nx_dm_str_case_M(upper);

#endif
