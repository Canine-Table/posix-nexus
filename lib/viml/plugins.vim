function! PlugUpdateUpgrade()
	execute 'PlugUpdate'
	execute 'PlugUpgrade'
endfunction

call plug#begin(g:nx_config_path . 'plugged')

" LSP + Java
Plug 'neovim/nvim-lspconfig'

" Java LSP glue for eclipse.jdt.ls
Plug 'mfussenegger/nvim-jdtls'
Plug 'williamboman/mason.nvim'

" Optional: manage LSPs/debuggers
Plug 'williamboman/mason-lspconfig.nvim'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'honza/vim-snippets'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'pierrelarsson/vim-nftables'
" Syntax/UX
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'

" Debugging (optional but recommended)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'jay-babu/mason-nvim-dap.nvim'

Plug 'lervag/vimtex'
Plug 'Mofiqul/dracula.nvim'
Plug 'ojroques/nvim-osc52'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'godlygeek/tabular'
Plug 'nvim-lua/plenary.nvim'
Plug 'github/copilot.vim'
Plug 'nordtheme/vim'

Plug 'tpope/vim-fugitive'

call plug#end()

