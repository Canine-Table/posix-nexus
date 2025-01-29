function! PlugUpdateUpgrade()
	PlugUpdate
	PlugUpgrade
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'lervag/vimtex'
Plug 'Mofiqul/dracula.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

call plug#end()

