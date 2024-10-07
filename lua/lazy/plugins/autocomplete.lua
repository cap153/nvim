local M = {}

M.config = {
	-- 使用nvim-cmp
	'hrsh7th/nvim-cmp',
	after = "SirVer/ultisnips",
	dependencies = {
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ 'hrsh7th/cmp-buffer' }, -- 缓冲区字符
		{ 'hrsh7th/cmp-path' }, -- 补全路径
		{ 'hrsh7th/cmp-cmdline' },
		{
			"onsails/lspkind.nvim", -- 补全的图标
			lazy = false,
			config = function()
				require("lspkind").init()
			end
		},
		-- 代码片段来源
		{ 'SirVer/ultisnips',                   dependencies = { "honza/vim-snippets" }, },
		{ 'quangnguyen30192/cmp-nvim-ultisnips' },
	},

	-- 使用coq_nvim补全
	-- 自动启动默认情况下无法运行，索性懒加载，或者见lazy.nvim中的init
	-- { 'ms-jpq/coq_nvim', build = 'python3 -m coq deps', lazy = true },
	-- { 'ms-jpq/coq.artifacts' },
	-- { 'ms-jpq/coq.thirdparty' },

	config = function()
		-- Set up nvim-cmp.
		local cmp = require 'cmp'
		local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				-- 目录nvim/snippets/*: snippets using snipMate format
				-- 目录nvim/UltiSnips/*: snippets using UltiSnips format
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			-- 和cw补全同一种风格样式
			window = {
				completion = {
					-- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					col_offset = -3,
					side_padding = 0,
				},
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- 召唤代码补全
				['<c-o>'] = cmp.mapping.complete(),
				['<c-space>'] = cmp.mapping.complete(),
				-- 代码片段下一处位置
				["<c-e>"] = cmp.mapping(
					function()
						cmp_ultisnips_mappings.compose { "expand", "jump_forwards" } (function() end)
					end,
					{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				),
				-- 代码片段上一处位置
				["<c-n>"] = cmp.mapping(
					function(fallback)
						cmp_ultisnips_mappings.jump_backwards(fallback)
					end,
					{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				),
				-- 关闭代码补全，和telescope冲突
				['<c-f>'] = cmp.mapping({
					i = function(fallback)
						cmp.close()
						fallback()
					end
				}),
				['<c-y>'] = cmp.mapping({ i = function(fallback) fallback() end }),
				-- cw的回车配置不会默认补全第一个，在:输入命令的时候比较合适
				-- ['<CR>'] = cmp.mapping({
				-- 	i = function(fallback)
				-- 		if cmp.visible() and cmp.get_active_entry() then
				-- 			cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
				-- 		else
				-- 			fallback()
				-- 		end
				-- 	end
				-- }),
				 ['<CR>'] = cmp.mapping({
					i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					c = function(fallback)
						if cmp.visible() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
						else
							fallback()
						end
					end
				}),
				["<Tab>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						elseif has_words_before() then
							cmp.complete()
						else
							cmp_ultisnips_mappings.compose { "jump_forwards" } (function() end) -- 添加跳转代码片段下一处的功能
							fallback()
						end
					end,
				}),
				["<S-Tab>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
						else
							fallback()
						end
					end,
				}),
			}),
			sources = cmp.config.sources({
				{ name = 'path' },  -- 本地路径补全
				{ name = 'nvim_lsp' },
				{ name = 'ultisnips' }, -- For ultisnips users.
			}, {
				{ name = 'buffer' },
			})
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
			}, {
				{ name = 'buffer' },
			})
		})

		-- 实现查找单词时根据上下文的补全，要输入多次回车，不太实用
		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		-- cmp.setup.cmdline({ '/', '?' }, {
		-- 	mapping = cmp.mapping.preset.cmdline(),
		-- 	sources = {
		-- 		{ name = 'buffer' }
		-- 	}
		-- })

		-- cmdline模式下的补全，可以自动纠正大小写
		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			})
		})


		-- ===
		-- === 自动补全coq,更改跳转代码片段快捷键，和idea一样，可以使用ctrl+space召唤补全窗口
		-- ===
		-- 代码补全自定义片段放在~/.config/nvim/coq-user-snippets目录下面,格式和snipMate一致除了后缀名是snip结尾
		-- local lspconfig = require('lspconfig')
		-- vim.g.coq_settings = {
		-- 	auto_start = 'shut-up',
		-- 	keymap = {
		-- 		jump_to_mark = '<c-e>', -- 跳转至代码片段的下一个占位
		-- 		pre_select = true -- 当有补全时预先选择第一个
		-- 	}
		-- }
		-- -- Enable some language servers with the additional completion capabilities offered by coq_nvim
		-- -- 具体查看https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		-- local servers = {
		-- 	-- 'lua_ls',
		-- 	-- 'marksman',
		-- 	'dartls',
		-- 	'pyright',
		-- 	'clangd',
		-- 	'gopls',
		-- }
		-- for _, lsp in ipairs(servers) do
		-- 	lspconfig[lsp].setup(require('coq').lsp_ensure_capabilities({
		-- 		-- on_attach = my_custom_on_attach,
		-- 	}))
		-- end
	end
}

return M
