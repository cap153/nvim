-- ===
-- === git status/git状态
-- ===

return {
	'lewis6991/gitsigns.nvim',
	build = ':TSUpdate',
	config = function()
		require('gitsigns').setup()
	end
}
