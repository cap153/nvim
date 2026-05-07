-- === mini ===
local P = {
	name = "mini.nvim", -- 仓库名
}

-- 懒加载触发器
vim.api.nvim_create_autocmd({
	"UIEnter", -- vim.schedule(function()
}, {
	once = true,
	callback = function()
		vim.schedule(function()
			PackUtils.load(P, function()
				require('mini.surround').setup {
					mappings = {
						add = 's',       -- Add surrounding
						delete = 'sd',   -- Delete surrounding
						find = 'sf',     -- Find surrounding (to the right)
						find_left = 'sF', -- Find surrounding (to the left)
						highlight = 'sh', -- Highlight surrounding
						replace = 'cs',  -- Replace surrounding/change sround
						update_n_lines = 'sn', -- Update `n_lines`
					},
					custom_surroundings = {
						b = {
							input = { '%*%*().-()%*%*' },
							output = { left = '**', right = '**' }
						},
						i = {
							input = { '%*().-()%*' },
							output = { left = '*', right = '*' }
						},
						d = {
							input = { '`().-()`' },
							output = { left = '`', right = '`' }
						}
					}
				}
			end)
		end)
	end
})

-- 不同的模块支持不同的懒加载策略
-- vim.api.nvim_create_autocmd({
-- 	"InsertEnter"
-- }, {
-- 	callback = function()
-- 		PackUtils.load(P, function()
-- 				require('mini.pairs').setup {}
-- 		end)
-- 	end
-- })
