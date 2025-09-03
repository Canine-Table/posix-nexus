local java_root = (os.getenv("NEXUS_LIB") or "") .. "/java/"
if java_root == "/java" then
	vim.notify("NEXUS_LIB not set", vim.log.levels.ERROR)
	return
end

local workspace = os.getenv("G_NEX_JAVA_PROJECT") or ""

local java_project = java_root .. workspace
if java_root == java_project then
	vim.notify("G_NEX_JAVA_PROJECT not set", vim.log.levels.WARN)
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "jdtls" } -- auto-install Java LSP
})

local jdtls = require("jdtls")
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspaces/' .. vim.fn.fnamemodify(workspace, ':p:h:t')
local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

local bundles = {}

-- LSP config
local config = {
	cmd = {
		jdtls_bin,
		"-data",
		workspace_dir
	},
	root_dir = java_project,
	init_options = {
		bundles = bundles
	},
	settings = {
		java = {
			configuration = { updateBuildConfiguration = "interactive" },
			format = { enabled = true }
		}
	}
}

jdtls.start_or_attach(config)

