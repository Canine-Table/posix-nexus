##############################################################################################

[ "$(nx_content_leaf "$G_NEX_TMUX_MULTI")" = 'tmux' ] && {
	alias tmux='tmux -f "$G_NEX_MOD_CNF/.tmux.conf"'
}

alias nex='. "$G_NEX_MOD_SRC/init-mod.sh"'
alias nx=nex
alias vi='$EDITOR'
alias pgr='$PAGER'
alias pkgmgr='nx_pkgmgr'

alias ipa='ip --color=auto address show'
alias ipn='ip --color=auto neighbor show'
alias ipr='ip --color=auto route show'
alias ipl='ip --color=auto link show'
alias iph='ip --help'
alias ipmrl='ip --color=auto mrule show'
alias ipmrt='ip --color=auto mroute show'

alias l='ls --color=auto -F' 
alias la='ls --color=auto -ashiFSl'
alias l1='ls --color=auto -a1'
alias ll='ls --color=auto -alF'
alias lA='ls --color=auto -AlF'
alias l.='ls -d .* --color=auto'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias cls=clear

alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias epoch='date +"%s"'

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

##############################################################################################
