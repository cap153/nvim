-- ===
-- === flutter-tools
-- ===

return {
	'akinsho/flutter-tools.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'dart-lang/dart-vim-plugin',
	},
	ft= {"dart"},
	lazy = true,
	config = function()
		require("flutter-tools").setup {} -- use defaults
	end
}

