return {
	"folke/flash.nvim",
  event = "VeryLazy",
	config = function()
		require('flash').setup {
			labels = "arstdhneioqwfpgjluyzxcvbkm",
			modes = {
				-- options used when flash is activated through
				-- a regular search with `/` or `?`
				search = {
					-- when `true`, flash will be activated during regular search by default.
					-- You can always toggle when searching with `require("flash").toggle()`
					enabled = true,
				},
			}
		}
	end
}

