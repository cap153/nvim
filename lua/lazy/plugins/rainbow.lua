-- ===
-- === rainbow，彩虹括号，必须要保证安装了treesitter,我分开是为了方便通过文件查找配置
-- ===

return {
	'p00f/nvim-ts-rainbow',
	config = function()
		require("nvim-treesitter.configs").setup {
			rainbow = {
				-- `false` will disable the whole extension
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			}
		}
	end
}

