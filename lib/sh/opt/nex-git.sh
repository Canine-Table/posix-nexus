
nx_git_amend()
{
	git commit --amend --no-edit -S
}

nx_git_commit()
{
	git commit -S -m "$*"
}

nx_git_push()
{
	git push upstream "$*"
}

