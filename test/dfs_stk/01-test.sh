
${AWK:-$(nx_cmd_awk)} "
	$(nx_data_include -i "${NEXUS_LIB}/awk/nex-struct-extras.awk")
"'
	BEGIN {
		nx_dfs_stk(stk, "hello", 9, 0)
		nx_dfs_stk(stk, "world", "", 0)
		nx_dfs_stk(stk, "hello", "", 0)
		nx_dfs_stk(stk, "hello", "", 0)
		nx_dfs_stk(stk, "world", "", 0)

		nx_dfs_stk(stk, "this", "+", 0)
		nx_dfs_stk(stk, "is", "", 0)
		nx_dfs_stk(stk, "depth", "", 0)
		nx_dfs_stk(stk, "1", "", 0)

		nx_dfs_stk(stk, "and", "-", 0)
		nx_dfs_stk(stk, "going", "", 0)
		nx_dfs_stk(stk, "back", "", 0)
		nx_dfs_stk(stk, "down", "", 0)
		nx_dfs_stk(stk, "to", "", 0)
		nx_dfs_stk(stk, "0", "", 0)

		nx_dfs_stk(stk, "moving", "+", 0)
		nx_dfs_stk(stk, "on", "", 0)
		nx_dfs_stk(stk, "to", "", 0)
		nx_dfs_stk(stk, "depth", "", 0)
		nx_dfs_stk(stk, "1", "", 0)


		nx_dfs_stk(stk, "finally", "-", 0)
		nx_dfs_stk(stk, "back", "", 0)
		nx_dfs_stk(stk, "down", "", 0)
		nx_dfs_stk(stk, "the", "", 0)
		nx_dfs_stk(stk, "mountain", "", 0)

		#nx_dfs_stk(stk, "start", "-", 0)
		#nx_dfs_stk(stk, "start", "-", 0)
		nx_dfs_stk_walk(stk, 3, 10)
		#nx_dfs_stk(stk, "start", "", )
		#nx_dfs_stk(stk, "ahhh", "+", 3)
		#nx_dfs_stk(stk, "start", "", 3)
		
		#nx_dfs_stk(stk, "start", "-", 3)
		#nx_dfs_stk(stk, "a", "+", 3)
		#nx_dfs_stk(stk, "b", "+", 3)
		#nx_dfs_stk(stk, "c", "-", 3)
	}
'

