for i in 0 0.5 -0.5 0.9 -0.9 0.99 -0.99 0.999 -0.999 1 -1; do
    printf '%s:\t%s\n' "$i" "$(nx_bc_geo -s 32 -c 'r_nx_ts_acos('"$i"')')"
done

