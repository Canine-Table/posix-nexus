--[=[
	This function initializes a custom POSIX-based Neovim setup.
]=]

package.path = package.path .. ';' .. os.getenv('NEXUS_LIB') .. '/lua/nvim/?.lua;' .. os.getenv('NEXUS_LIB') .. '/lua/?.lua'
local nex = require('nex-init')

