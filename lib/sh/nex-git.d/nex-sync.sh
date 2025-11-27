#nx_include NEX_L:/sh/nex-git.sh

__nx_git_sync()
{
    while test "$#" -gt 0; do
        case "$1" in
            t) {
                git fetch "$origin" "$branch" &&
                git merge -s recursive -X theirs "$origin/$branch" &&
                git push "$origin" "$branch"
            };;
            r) {
                git fetch "$origin" "$branch" &&
                git rebase "$origin/$branch" --strategy=recursive -X theirs &&
                git push "$origin" "$branch"
            };;
            *) {
                return 0
            };;
        esac
        shifts=$((shifts + 1))
        shift
    done
}


