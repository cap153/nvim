return {
	'windwp/nvim-autopairs',
	config = function()
		-- 配合cmp,我也不知道有啥效果
		-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		-- local cmp = require('cmp')
		-- cmp.event:on(
		-- 	'confirm_done',
		-- 	cmp_autopairs.on_confirm_done()
		-- )

		require('nvim-autopairs').setup({
			-- 在写markdown时禁用括号补全
			disable_filetype = {"markdown"},
			--  can use treesitter to check for a pair.
			check_ts = true,
		})
	end
}
