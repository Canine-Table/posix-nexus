--[=[
	This function initializes a custom POSIX-based Neovim setup.
function nx_luatex_init()
	dofile(os.getenv('G_NEX_MOD_LIB') .. '/lua/nex-init.lua')
end

function nx_hello_world()
	for i = 1, 10 do
		print(i)
	end
end

nx_luatex_init()

]=]


