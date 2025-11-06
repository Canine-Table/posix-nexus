#nx_include "nex-misc.awk"
#nx_include "nex-str.awk"
function nx_source(D1, D2,	trk, mp)
{
	if (nx_is_file(D1)) {
		mp[0] = 0
		trk["rt"] = "."
		trk["sig"] = __nx_else(D2, "#nx_include")
		do {
			while ((getline D2 < D1) > 0) {
				if (D2 ~ "([ \t]+|^)" trk["sig"] && match(D2, trk["sig"] "[ \t]+")) {
					# from the start up to before the sigil
					trk["cr"] = substr(D2, 1, RSTART - 1)

					# after the directive
					D2 = substr(D2, RSTART + RLENGTH)

					# if the directive isnt NF
					if(match(D2, /([ \t]+|$)/)) {
						# store the line without directive or filename
						# replace the to with <nx:placeholder/>
						trk[trk["rt"] ++trk[trk["rt"] "0"]] = trk["cr"] "<nx:placeholder/>" substr(D2, RSTART)

	# map[0] = root; mp[root] = file; map[file] = placeholder
	#	   __nx_include_map(mp, trk["rt"] trk[trk["rt"] "0"], substr(D2, 1, RSTART - 1))

					}
				}
			}
			close(D)
			trk["rt"] = mp[mp[0]--]
		} while (mp[0] > 0)
	}
}


# function nx_include(D1, D2, D3, trk, mp)
#{
#  D3 = "#"
#  mp[0] = 0
#  for (trk["rt"] = "."; mp[0] > 0; trk["rt"] = mp[mp[0]--]) {
#    while ((getline D2 < D1) > 0) {
#      if (D2 ~ "([ \t]+|^)" D3 "nx_include" && match(D2, D3 "nx_include[ \t]+")) {
#	 # from the start up to before the sigil 
#	 trk["cr"] = substr(D2, 1, RSTART - 1)
#
#	 # after the directive
#	 D2 = substr(D2, RSTART + RLENGTH)
#
#	 # if the directive isnt NF
#	 if(match(D2, /([ \t]+|$)/)) {
	  # "." ++".0" 
	  # "." "1" "."
	  
	  # store the line without directive or filename
	  # replace the to with <nx:placeholder/>
#	   trk[trk["rt"] ++trk[trk["rt"] "0"]] = trk["cr"] "<nx:placeholder/>" substr(D2, RSTART)

	  # map[0] = root; mp[root] = file; map[file] = placeholder
#	   __nx_include_map(mp, trk["rt"] trk[trk["rt"] "0"], substr(D2, 1, RSTART - 1))
#	 } else if (trk["cr"] != "") {
#	   trk[++trk[trk["rt"]]] = trke["cr"]
#	 }
#      } else {
#	 trk[++trk[trk["rt"]]] = D2
#      }
#    }
#    close(D1)
    #sub("<nx:placeholder/>", 
#    D1 = mp[mp[mp[0]]]
#  }
#}

