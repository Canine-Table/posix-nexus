--[=[
	This function initializes a custom POSIX-based Neovim setup.
]=]

function nx_nvim_init()
	local nx_path = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
	local nx_cont = nx_path:match('.*[/]')
	local nx_leaf = nx_path:match('[^/]+$')
	vim.cmd('source ' .. nx_cont .. '../nex-init.lua')
	nx_init(nx_cont, nx_leaf)
end

nx_nvim_init()

