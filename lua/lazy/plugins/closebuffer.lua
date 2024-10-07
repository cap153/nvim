-- ===
-- === 关闭缓冲区的标签
-- ===

local map = require("core.keymap")
-- 关闭当前缓冲区标签
map:cmd('tq', 'BDelete this')
-- 关闭除当前标签外的其他标签
map:cmd('to', 'BDelete other')

return {
	'kazhala/close-buffers.nvim',
	config = function()
		require('close_buffers').setup({
			filetype_ignore = {}, -- Filetype to ignore when running deletions
			file_glob_ignore = {}, -- File name glob pattern to ignore when running deletions (e.g. '*.md')
			file_regex_ignore = {}, -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
			preserve_window_layout = { 'this', 'nameless' }, -- Types of deletion that should preserve the window layout
			next_buffer_cmd = nil, -- Custom function to retrieve the next buffer when preserving window layout
		})
	end
}

