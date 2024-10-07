return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
	dependencies = {
		{ 'neovim/nvim-lspconfig' },
		{'williamboman/mason.nvim'},
		{'williamboman/mason-lspconfig.nvim'},
		{
			"MysticalDevil/inlay-hints.nvim",
			event = "LspAttach",
			config = function()
				require("inlay-hints").setup()
			end
		}
	},
	config = function()
		-- 打算启用的语言服务列表
		local servers = {
			'marksman', -- 任意标题<space>aw打开code action可以开头生成目录；超链接可以链接到同一个git项目的其他markdown文件#指定标题<space>h可以预览
			'lua_ls',
			'pyright',
			'gopls',
			'rust_analyzer',
		}
		-- lsp_zero的相关配置
		local lsp_zero = require('lsp-zero')
		lsp_zero.on_attach(function(client, bufnr)
			lsp_zero.default_keymaps({ buffer = bufnr })
			local opts = { buffer = bufnr }
			vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts) -- <space>h显示提示文档
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- gd跳转到定义的位置
			vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts) -- go跳转到变量类型定义的位置
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- gr跳转到引用了对应变量或函数的位置
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- <space>rn变量重命名
			vim.keymap.set({ 'n', 'x' }, '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts) -- <space>f进行代码格式化
			vim.keymap.set('n', '<leader>aw', vim.lsp.buf.code_action, opts) -- <space>aw可以在出现警告或错误的地方打开建议的修复方法
			vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- <space>d浮动窗口显示所在行警告或错误信息
			vim.keymap.set('n', '<leader>-', vim.diagnostic.goto_prev, opts) -- <space>-跳转到上一处警告或错误的地方
			vim.keymap.set('n', '<leader>=', vim.diagnostic.goto_next, opts) -- <space>+跳转到下一处警告或错误的地方
		end)
		-- “符号栏”是行号旁边的装订线中的一个空格。当一行中出现警告或错误时，Neovim 会向您显示一个字母
		lsp_zero.set_sign_icons({
			error = '✘',
			warn = '▲',
			hint = '⚑',
			info = '»'
		})
		-- 通过mason来自动安装语言服务器，可以在对应的代码运行LspIstall来安装可用的语言服务器
		require('mason').setup({})
		require('mason-lspconfig').setup({
			ensure_installed = servers -- 直接把前面的servers列表传递过来
		})
		-- cmp相关配置，通过for读取servers列表循环批量激活语言服务
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require('lspconfig')
		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup {
				-- on_attach = my_custom_on_attach,
				capabilities = capabilities,
				settings = {
					gopls = {
						hints = { -- gopls开启hints
							rangeVariableTypes = true,
							parameterNames = true,
							constantValues = true,
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							functionTypeParameters = true,
						}
					},
					Lua = {
						hint = {  -- Lua开启hints
							enable = true, -- necessary
						},
						diagnostics = {
							-- 忽略掉vim配置时一些全局变量语言服务器找不到的警告
							globals = {
								'vim',
								'require',
								'opts',
							},
						},
					},
				},
			}
		end
	end
}
