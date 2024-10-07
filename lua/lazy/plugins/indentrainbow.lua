return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = {
		"TheGLander/indent-rainbowline.nvim",
	},
	config = function()
		opts = {}
		-- Other blankline configuration here
		require("ibl").setup(require("indent-rainbowline").make_opts(opts,{
			-- How transparent should the rainbow colors be. 1 is completely opaque, 0 is invisible. 0.07 by default
			color_transparency = 0.15,
			-- The 24-bit colors to mix with the background. Specified in hex.
			-- { 0xffff40, 0x79ff79, 0xff79ff, 0x4fecec, } by default
			colors = { 0xff0000, 0x00ff00, 0x0000ff, 0xffff40, 0x79ff79, 0xff79ff, 0x4fecec},
		}))

	-- local highlight = {
	-- 	"RainbowRed",
	-- 	"RainbowYellow",
	-- 	"RainbowBlue",
	-- 	"RainbowOrange",
	-- 	"RainbowGreen",
	-- 	"RainbowViolet",
	-- 	"RainbowCyan",
	-- }

	-- local hooks = require "ibl.hooks"
	-- -- create the highlight groups in the highlight setup hook, so they are reset
	-- -- every time the colorscheme changes
	-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	-- 		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	-- 		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	-- 		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	-- 		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	-- 		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	-- 		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	-- 		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	-- end)

	-- require("ibl").setup { indent = { highlight = highlight } }
	end
}

