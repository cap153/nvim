-- ufo关于折叠的设置
vim.o.foldcolumn = '0' -- '0' is not bad,其他的会有奇怪的数字
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- 设置可折叠处的样式
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

return {
	'kevinhwang91/nvim-ufo',
	dependencies = 'kevinhwang91/promise-async',
	config = function()
		-- Option 3: treesitter as a main provider instead
		-- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
		-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
		require('ufo').setup({
				provider_selector = function(bufnr, filetype, buftype)
						return {'treesitter', 'indent'}
				end
		})
		-- 键盘映射,这里的按键会打开或折叠全部的可折叠位置
		vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
		vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
		vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
	end
}

