
nx_java_export()
{
	unset E_NEX_JAVA
	for tmpa in \
		"/usr/lib/jvm/default" \
		"/usr/lib/jvm/default-runtime"
	do
		test -d "$tmpa" -a -r "$tmpa" && {
			export G_NEX_JAVA_DEV="$(printf "%s\n" "$(nx_info_path -b "$tmpa")" | cut -d '-' -f 2)"
			export JAVA_HOME="$tmpa"
			export G_NEX_JAVA_BIN="$tmpa/bin/java"
			break
		}
	done
	test -z "$JAVA_HOME" && return
	test "$G_NEX_JAVA_DEV" = 'runtime' && nx_io_printf -W "JAVA_HOME points to a JRE, not a JDK"
	tmpa="$(${AWK:-$(nx_cmd_awk)} -v json="${NEXUS_CNF}/nx.json" "
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-json.awk")
	"'
		BEGIN {
			if (! (err = nx_json(json, arr, 2))) {
				if (err = arr[".nx.java.project"])
					print err
				else
					err = 1
			}
			delete arr
			exit err
		}
	')" || {
		nx_io_printf -E "G_NEX_JAVA_PROJECT is not configured in nx.json"
		return 2
	}

	tmpb="$NEXUS_LIB/java/$tmpa"
	test "$tmpb" != "$tmpa" -a -d "$tmpb" -a -r "$tmpb" || {
		mv "$tmpb" "$tmpb-$(date +%s)" 2> /dev/null
		mkdir -p "$tmpb" || {
			nx_io_printf -E "$tmpb could not be created"
			return 3
		}
	}
	export G_NEX_JAVA_PROJECT="$tmpa"
}


nx_java_run()
{

}

export E_NEX_JAVA=true

