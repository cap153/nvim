-- 导入键盘映射的函数
local map = require("core.keymap")
-- 获取当前文件名
local filename = vim.fn.expand("%:t")
-- 删除扩展,并添加连加符号`.`
filename = string.gsub(filename, "%..*", "") .. "."
-- 使用空格+p来粘贴间剪切板的图片,然后输入想保存的图片名称，
-- 图片会自动保存在当前文件的同一目录下并调整为markdown格式
map:cmd('<space>p','PasteImage')

return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	config = function()
		require'img-clip'.setup {
			default = {
				dir_path = filename .. "assets", -- 图片保存路径：./文件名.assets
				insert_mode_after_paste = false, -- 粘贴图片后不进入插入模式
			},
			filetypes = {
				markdown = {
					url_encode_path = true, ---@type boolean
					template = "![$FILE_NAME_NO_EXT]($FILE_PATH)", -- 图片模板，中括号提示包含文件名
					download_images = false, ---@type boolean
				},
			},
		}
	end
}

