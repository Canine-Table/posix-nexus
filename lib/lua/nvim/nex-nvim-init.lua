--[=[
	This function initializes a custom POSIX-based Neovim setup.
]=]

package.path = package.path .. ';' .. os.getenv('G_NEX_MOD_LIB') .. '/lua/nvim/?.lua;' .. os.getenv('G_NEX_MOD_LIB') .. '/lua/?.lua'
local nex = require('nex-init')

