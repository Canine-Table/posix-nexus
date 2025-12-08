function! PlugUpdateUpgrade()
	execute 'PlugUpdate'
	execute 'PlugUpgrade'
endfunction

call plug#begin(g:nex_vim_config . 'plugged')
	if g:nex_vim ==# "nvim"
		" Neovim-only plugins
		echo "loading neovim extentions and lua modules"
		call NxCallFile('nex-init.lua')
		Plug 'neovim/nvim-lspconfig'
		Plug 'mfussenegger/nvim-jdtls'
		Plug 'williamboman/mason.nvim'
		Plug 'williamboman/mason-lspconfig.nvim'
		Plug 'hrsh7th/nvim-cmp'
		Plug 'hrsh7th/cmp-nvim-lsp'
		Plug 'hrsh7th/cmp-buffer'
		Plug 'hrsh7th/cmp-path'
		Plug 'hrsh7th/cmp-cmdline'
		Plug 'L3MON4D3/LuaSnip'
		Plug 'saadparwaiz1/cmp_luasnip'
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
		Plug 'nvim-telescope/telescope.nvim'
		Plug 'mfussenegger/nvim-dap'
		Plug 'rcarriga/nvim-dap-ui'
		Plug 'theHamsta/nvim-dap-virtual-text'
		Plug 'jay-babu/mason-nvim-dap.nvim'
		Plug 'Mofiqul/dracula.nvim'
		Plug 'ojroques/nvim-osc52'
		Plug 'lukas-reineke/indent-blankline.nvim'
		Plug 'nvim-lua/plenary.nvim'
	else
		if g:nex_vim ==# "vim9"
			echo "loading vim9+ extentions"
		else
			echo "loading legacy vim extentions"
		endif
	endif

	" Plugins safe for both
	Plug 'honza/vim-snippets'
	Plug 'pierrelarsson/vim-nftables'
	Plug 'lervag/vimtex'
	Plug 'plasticboy/vim-markdown'
	Plug 'preservim/vim-markdown'
	Plug 'iamcco/markdown-preview.nvim'
	Plug 'godlygeek/tabular'
	Plug 'github/copilot.vim'
	Plug 'nordtheme/vim'
	Plug 'tpope/vim-fugitive'

call plug#end()

