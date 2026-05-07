-- === 折叠插件 ===
if vim.g.vscode then return end

-- ufo关于折叠的设置
vim.o.foldcolumn = "0" -- '0' is not bad,其他的会有奇怪的数字
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local P = {
	name = "nvim-ufo", -- 仓库名
	deps = { "promise-async" },
}

-- 懒加载触发器
vim.api.nvim_create_autocmd({
	"UIEnter", -- vim.schedule(function()
}, {
	once = true,
	callback = function()
		vim.schedule(function()
			PackUtils.load(P, function()
				-- Option 2: nvim lsp as LSP client
				local orig_make_client_capabilities = vim.lsp.protocol.make_client_capabilities
				vim.lsp.protocol.make_client_capabilities = function()
					local caps = orig_make_client_capabilities()
					caps.textDocument.foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true
					}
					return caps
				end
				require("ufo").setup({})
				-- Option 3: treesitter as a main provider instead
				-- require("ufo").setup({
				-- 	provider_selector = function()
				-- 		return { "treesitter", "indent" }
				-- 	end
				-- })
				-- 键盘映射,这里的按键会打开或折叠全部的可折叠位置
				vim.keymap.set("n", "zr", require("ufo").openAllFolds)
				vim.keymap.set("n", "zm", require("ufo").closeAllFolds)
			end)
		end)
	end
})
