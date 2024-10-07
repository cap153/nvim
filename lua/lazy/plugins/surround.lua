-- ===
-- === mini.nvim surround,各种对字符的包裹{} [] ''
-- ===

return {
	'echasnovski/mini.nvim',
	branch = 'stable',
	config = function()
		require('mini.surround').setup {
			mappings = {
				add = 's',         -- Add surrounding
				delete = 'sd',     -- Delete surrounding
				find = 'sf',       -- Find surrounding (to the right)
				find_left = 'sF',  -- Find surrounding (to the left)
				highlight = 'sh',  -- Highlight surrounding
				replace = 'cs',    -- Replace surrounding/change sround
				update_n_lines = 'sn', -- Update `n_lines`
			},
		}
	end
}
