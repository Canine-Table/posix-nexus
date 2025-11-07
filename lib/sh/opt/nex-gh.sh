nx_gh_create()
{
	curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE
	gh repo create "$1" --private --source=. --remote=upstream
	git add LICENSE
	git commit -m "Add GPLv3 license"
	git push
}
