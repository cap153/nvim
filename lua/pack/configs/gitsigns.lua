-- === git signs ===
if vim.g.vscode then return end

local P = {
	name = "gitsigns.nvim",
	build_cmd = ":TSUpdate",
}

-- 注册构建监听器
PackUtils.setup_listener(P.name, P.build_cmd)

-- 懒加载触发器
vim.api.nvim_create_autocmd({
	"UIEnter", -- vim.schedule(function()
}, {
	once = true,
	callback = function()
		vim.schedule(function()
			PackUtils.load(P, function()
				require('gitsigns').setup {
					on_attach = function()
						local gitsigns = require('gitsigns')
						local map = require("core.keymap")
						-- Navigation
						map:lua('t=', function()
							gitsigns.nav_hunk('next')
						end)
						map:lua('t-', function()
							gitsigns.nav_hunk('prev')
						end)
						-- show diff
						map:lua('<leader>hd', gitsigns.diffthis)
					end
				}
			end)
		end)
	end
})
