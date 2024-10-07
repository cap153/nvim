-- ===
-- === 注释插件
-- ===

-- 注释快捷键
local map = require("core.keymap")
map:key("n", "<space>cn", "<Plug>kommentary_line_increase")
map:key("x", "<space>cn", "<Plug>kommentary_visual_increase<esc>") -- 选择模式下注释/反注释后退出该模式
map:key("n", "<space>cu", "<Plug>kommentary_line_decrease")
map:key("x", "<space>cu", "<plug>kommentary_visual_decrease<esc>")

return {
	'b3nj5m1n/kommentary',
	config = function()
		-- 默认只使用单行注释
		require('kommentary.config').configure_language("default", {
			prefer_single_line_comments = true,
		})
	end
}

