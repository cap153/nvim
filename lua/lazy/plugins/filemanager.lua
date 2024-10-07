-- ===
-- === explorer tree 文件列表 fm-nvim启动joshuto ranger Lazygit
-- ===

return {
	"DreamMaoMao/yazi.nvim", -- 使用yazi替代joshuto和ranger,仍然使用fm-nvim来启动lazygit
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		'is0n/fm-nvim',commit = 'ad7b80dc99cb8b14977f7ea233a9a299dc8879c0', -- 这个提交解决了joshuto无法启动的问题
	},
	keys = {
		{ "tt", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
		{ "<c-g>", "<cmd>Lazygit<CR>", desc = "Toggle Lazygit" },
	},
	config = function()
		require('fm-nvim').setup{
			-- UI Options
			ui = {
				float = {
					-- Floating window border (see ':h nvim_open_win')
					border    = "single",
					-- Num from 0 - 1 for measurements
					height    = 0.9,
					width     = 0.8,
				},
			},
		}
	end
}


-- local map = require("core.keymap")
-- -- 打开文件树
-- -- map:cmd('tt', "Ranger")
-- map:cmd('tt', "Joshuto")
-- -- 使用lazygit
-- map:cmd('<c-g>', "Lazygit")

-- return {
-- 	'is0n/fm-nvim',
-- 	commit = 'ad7b80dc99cb8b14977f7ea233a9a299dc8879c0', -- 这个提交解决了joshuto无法启动的问题
-- 	config = function()
-- 		require('fm-nvim').setup{
-- 			-- UI Options
-- 			ui = {
-- 				float = {
-- 					-- Floating window border (see ':h nvim_open_win')
-- 					border    = "single",
-- 					-- Num from 0 - 1 for measurements
-- 					height    = 0.9,
-- 					width     = 0.8,
-- 				},
-- 			},
-- 			-- Terminal commands used w/ file manager (have to be in your $PATH)
-- 			cmds = {
-- 				joshuto_cmd = "",
-- 			},
-- 		}
-- 	end
-- }

