-- ===
-- === map function
-- ===

local function mapkey(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, nowait = true }, opts or {}))
end

local function mapcmd(key, cmd)
	vim.keymap.set("n", key, "<Cmd>" .. cmd .. "<CR>", { silent = true })
end

local function maplua(modes, key, action, desc)
	vim.keymap.set(modes, key, action, { silent = true, noremap = true, desc = desc })
end

-- ===
-- === Basic Mappings
-- ===

-- leader键设置为空格,; as :
vim.g.mapleader = " "
mapkey({ "n", "x", "o" }, ";", ":")

-- 上/下一个搜索结果以及取消搜索结果高亮
mapkey({ "n", "x", "o" }, "=", "nzz")
mapkey({ "n", "x", "o" }, "-", "Nzz")
mapcmd("<leader><cr>", "nohlsearch")

-- 保存和退出
mapkey({ "n", "x", "o" }, "S", ":wall<cr>")
mapkey({ "n", "x", "o" }, "Q", ":qall<cr>")

-- 撤销与反撤销
mapkey({ "n", "x", "o" }, "l", "u")
mapkey({ "n", "x", "o" }, "L", "<c-r>")

-- 插入
mapkey({ "n", "x", "o" }, "k", "i")
mapkey({ "n", "x", "o" }, "K", "I")

mapkey('n', '<C-n>', '<C-o>')

-- 折叠
mapkey({ "n", "x", "o" }, "<leader>o", "za")
mapkey("x", "<leader>o", "zf") -- 可视模式创造折叠
-- 读取保存的折叠
-- mapkey({ "n", "x", "o" }, "<leader>a", ":loadview<cr>")


-- 以下两个映射默认了
-- make Y to copy till the end of the line
-- mapkey('','Y','y$')

-- make D to delete till the end of the line
-- mapkey('','D','d$')

-- 打开lazygit,已用fm-nvim插件
-- mapcmd('<c-g>',':tabe<CR>:-tabmove<CR>:term lazygit')

-- ===
-- === treesitter
-- ===

-- 删除i键映射
vim.api.nvim_create_autocmd("VimEnter", { -- 所有启动脚本、默认脚本都加载完毕后的最后一个事件
	callback = function()
		-- 使用 pcall 忽略如果键位不存在时的报错
		pcall(vim.keymap.del, { "x", "o" }, "in")
	end,
})

local function smart_select(ts_method, lsp_dir)
	return function()
		-- 如果当前不是普通文件（比如 Quickfix、帮助文档、终端等）那么我们直接发送一个原生的 <CR> 按键并退出，恢复回车原本的功能
		if lsp_dir == 1 and vim.bo.buftype ~= "" then
			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", false)
			return
		end
		if vim.treesitter.get_parser(nil, nil, { error = false }) then
			require("vim.treesitter._select")[ts_method](vim.v.count1)
		else
			vim.lsp.buf.selection_range(lsp_dir * vim.v.count1)
		end
	end
end
-- 扩大范围 (回车键)：不断向上寻找父节点 (等价于官方的 an)
maplua({ "x", "o", "n" }, "<CR>", smart_select("select_parent", 1), "扩大 Treesitter/LSP 范围")
-- 缩小范围 (退格键)：不断向下寻找子节点
maplua({ "x", "o" }, "<BS>", smart_select("select_child", -1), "缩小 Treesitter/LSP 范围")



-- ===
-- === Cursor Movement
-- ===
-- New cursor movement (the default arrow keys are used for resizing windows)

--     ^
--     u
-- < n   i >
--     e
--     v
mapkey({ "n", "x", "o" }, "n", "h")
mapkey({ "n", "x", "o" }, "u", "k")
mapkey({ "n", "x", "o" }, "e", "j")
mapkey({ "n", "x", "o" }, "i", "l")

-- 更快的导航
mapkey({ "n", "x", "o" }, "U", "5k")
mapkey({ "n", "x", "o" }, "E", "5j")
mapkey({ "n", "x", "o" }, "N", "0")
mapkey({ "n", "x", "o" }, "I", "$")
-- 向下滚动半页，<C-u>默认向上滚动半页
mapkey({ "n", "x", "o" }, "<C-e>", "<C-d>")

-- 更快的行导航
mapkey({ "n", "x", "o" }, "W", "5W")
mapkey({ "n", "x", "o" }, "B", "5B")

-- ===
-- === Window management
-- ===

-- 使用<space> + 新方向键 在分屏之间移动
mapkey({ "n", "x", "o" }, "<LEADER>w", "<C-w>w")
mapkey({ "n", "x", "o" }, "<LEADER>u", "<C-w>k")
mapkey({ "n", "x", "o" }, "<LEADER>e", "<C-w>j")
mapkey({ "n", "x", "o" }, "<LEADER>n", "<C-w>h")
mapkey({ "n", "x", "o" }, "<LEADER>i", "<C-w>l")

-- 使用s + 新方向键 进行分屏
mapcmd("su", "leftabove split")   -- 在上方分屏
mapcmd("se", "rightbelow split")  -- 在下方分屏
mapcmd("sn", "leftabove vsplit")  -- 在左侧分屏
mapcmd("si", "rightbelow vsplit") -- 在右侧分屏

-- 使用方向键来调整窗口大小
mapcmd("<up>", "res +5")
mapcmd("<down>", "res -5")
mapcmd("<left>", "vertical resize-5")
mapcmd("<right>", "vertical resize+5")

-- 使分屏窗口上下分布
mapkey({ "n", "x", "o" }, "sh", "<C-w>t<C-w>K")
-- 使分屏窗口左右分布
mapkey({ "n", "x", "o" }, "sv", "<C-w>t<C-w>H")

-- 按 <SPACE> + q 关闭当前窗口下方的窗口
mapkey({ "n", "x", "o" }, "<LEADER>q", "<C-w>j:q<CR>")

-- ===
-- === Tab management
-- ===

-- tu创建新标签,已用bufferline.nvim替代
-- mapcmd("tu", "tabe")
-- 在标签之间移动
-- mapcmd('tn','-tabnext')
-- mapcmd('ti','+tabnext')

-- 移动标签的位置
-- mapcmd('tmn','-tabmove')
-- mapcmd('tmi','+tabmove')

-- 关闭当前标签,已用close-buffers替代
-- mapcmd('tq','tabc')

-- ===
-- === 批量缩进方法
-- ===
-- 操作为，esc从编辑模式退到命令模式，将光标移到需要缩进的行的行首，然后按shift+v，可以看到该行已被选中，且左下角提示为“可视”
-- 按键盘上的上下方向键，如这里按向下的箭头，选中所有需要批量缩进的行
-- 按shift+>,是向前缩进一个tab值，按shift+<，则是缩回一个tab值

mapkey("x", "<", "<gv")
mapkey("x", ">", ">gv")
mapkey("x", "<s-tab>", "<gv")
mapkey("x", "<tab>", ">gv")

-- ===
-- === 批量替换 (修复 Shell 逃逸与正则符冲突版)
-- ===

-- 替换当前目录及子目录下所有文件内容
local function search_and_replace()
	return function()
		local search_text = vim.fn.input("Search for: ")
		if search_text == "" then return end
		local replace_text = vim.fn.input("Replace with: ")

		-- 为 sed 转义分隔符 '/'，防止 s/a/b/g 出现语法错误
		local sed_search = vim.fn.escape(search_text, '/')
		local sed_replace = vim.fn.escape(replace_text, '/')

		-- 利用内核自动转义并生成安全的单引号包裹
		local grep_arg = vim.fn.shellescape(search_text)
		local sed_arg = vim.fn.shellescape('s/' .. sed_search .. '/' .. sed_replace .. '/g')

		-- 执行拼接：grep 增加 -F 参数表示“固定字符串”，彻底无视正则符号(如括号、星号)
		local cmd = '!grep -rlF ' .. grep_arg .. ' ./ | xargs sed -i ' .. sed_arg
		vim.cmd(cmd)
		-- 强制 Neovim 检查文件在外部的改动并立即刷新 UI
		vim.cmd("checktime")
		print("\n✅ Replaced occurrences of '" .. search_text .. "' in workspace.")
	end
end

-- 替换当前文件内容
local function search_and_replace_current_file()
	return function()
		local search_text = vim.fn.input("Search for in current file: ")
		if search_text == "" then return end
		local replace_text = vim.fn.input("Replace with: ")

		local sed_search = vim.fn.escape(search_text, '/')
		local sed_replace = vim.fn.escape(replace_text, '/')
		local sed_arg = vim.fn.shellescape('s/' .. sed_search .. '/' .. sed_replace .. '/g')

		-- % 代表当前文件
		local cmd = '!sed -i ' .. sed_arg .. ' %'
		vim.cmd(cmd)

		vim.cmd("checktime")
		print("\n✅ Replaced occurrences in current file.")
	end
end

maplua("n", "<leader>sa", search_and_replace(), "替换当前目录及子目录下所有文件内容")
maplua("n", "<leader>sr", search_and_replace_current_file(), "替换当前文件内容")

-- ===
-- === 临时“存档”文件当前的版本，并与后续的修改进行 diff 对比
-- ===

-- 创建 :DiffOrig 自定义命令，这个命令会打开一个垂直分屏，加载当前文件存盘时的版本，并启动 diff 模式
vim.api.nvim_create_user_command(
	'DiffOrig',
	function()
		-- 在创建新窗口前，先保存当前文件的 filetype
		local original_filetype = vim.bo.filetype
		-- 打开一个垂直分屏，并准备好临时缓冲区
		vim.cmd('vert new | set buftype=nofile')
		-- 在新的临时缓冲区里，设置我们刚才保存的 filetype，这是确保语法高亮的关键！
		vim.bo.filetype = original_filetype
		-- 读取原始文件的磁盘内容，并启动 diff
		vim.cmd('read ++edit # | 0d_ | diffthis | wincmd p | diffthis')
	end,
	{ force = true }
)
-- <leader>dd 将会执行 :DiffOrig 命令
mapcmd('<leader>dd', 'DiffOrig')

-- ===
-- === Other useful stuff
-- ===

-- 打开一个终端窗口
mapcmd("<LEADER>/", "set splitbelow<CR>:split<CR>:res +10<CR>:term")

-- 按两下空格跳转到占位符<++>,并进入插入模式
mapkey({ "n", "x", "o" }, "<LEADER><LEADER>", "<Esc>/<++><CR>:nohlsearch<CR>c4l")

-- 拼写检查
mapcmd("<LEADER>sc", "set spell!")

-- 注释快捷键
mapkey("n", "<leader>cn", "gcc", { remap = true })
mapkey("x", "<leader>cn", "gc", { remap = true })
mapkey("n", "<leader>cu", "gcc", { remap = true })
mapkey("x", "<leader>cu", "gc", { remap = true })
mapkey("n", "<c-_>", "gcc", { remap = true })
mapkey("x", "<c-_>", "gc", { remap = true })
mapkey("n", "<c-/>", "gcc", { remap = true })
mapkey("x", "<c-/>", "gc", { remap = true })

-- ===
-- ===  运行代码(该功能已经迁移到plugins/coderunner.lua)
-- ===

-- vim.cmd([[
--  au filetype dart noremap r :wall<cr>:Telescope flutter commands<cr>
--  au filetype python noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term uv run %<cr>
--  au filetype go noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term go run %<cr>
--  au filetype markdown noremap r :PeekClose<cr>:PeekOpen<cr>
--  au filetype rust noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term cargo run<cr>
-- ]])


-- ===
-- === map function external environment
-- ===

-- 下面的函数给外部文件调用的
-- 使用示例如下
-- local map = require("core.keymap")
-- map:cmd('<space>p','PasteImg')
local map = {}
function map:key(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

function map:cmd(key, cmd)
	vim.keymap.set("n", key, "<Cmd>" .. cmd .. "<CR>", { silent = true })
end

function map:lua(key, txt_or_func)
	if type(txt_or_func) == "string" then
		vim.keymap.set("n", key, "<cmd>lua " .. txt_or_func .. "<cr>", { silent = true })
	else
		vim.keymap.set("n", key, txt_or_func, { silent = true })
	end
end

return map
