
-- ===
-- === map function
-- ===

local function mapkey(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

local function mapcmd(key, cmd)
	vim.api.nvim_set_keymap("n", key, ":" .. cmd .. "<cr>", { noremap = true })
end

local function maplua(key, txt)
	vim.api.nvim_set_keymap("n", key, ":lua " .. txt .. "<cr>", { noremap = true })
end

-- ===
-- === Basic Mappings
-- ===

-- leader键设置为空格,; as :
vim.g.mapleader = " "
mapkey("", ";", ":")

-- 上/下一个搜索结果以及取消搜索结果高亮
mapkey("", "=", "nzz")
mapkey("", "-", "Nzz")
mapcmd("<leader><cr>", "nohlsearch")

-- 保存和退出
mapkey("", "S", ":wall<cr>")
mapkey("", "Q", ":q<cr>")

-- 撤销与反撤销
mapkey("", "l", "u")
mapkey("", "L", "<c-r>")

-- 插入
mapkey("", "k", "i")
mapkey("", "K", "I")

-- 以下两个映射默认了
-- make Y to copy till the end of the line
-- mapkey('','Y','y$')

-- make D to delete till the end of the line
-- mapkey('','D','d$')

-- 折叠
mapkey("", "<leader>o", "za")
mapkey("x", "<leader>o", "zf")
-- 读取保存的折叠
-- mapkey("", "<leader>a", ":loadview<cr>")

-- 打开lazygit,已用fm-nvim插件
-- mapcmd('<c-g>',':tabe<CR>:-tabmove<CR>:term lazygit')

-- ===
-- === Cursor Movement
-- ===
-- New cursor movement (the default arrow keys are used for resizing windows)

--     ^
--     u
-- < n   i >
--     e
--     v

mapkey("", "n", "h")
mapkey("", "u", "k")
mapkey("", "e", "j")
mapkey("", "i", "l")

-- faster navigation
mapkey("", "U", "5k")
mapkey("", "E", "5j")
mapkey("", "N", "0")
mapkey("", "I", "$")

-- 更快的行导航
mapkey("", "W", "5W")
mapkey("", "B", "5B")

-- ===
-- === Window management
-- ===

-- Disable the default s key
mapkey("", "s", "<nop>")

-- 使用<space> + 新方向键 在分屏之间移动
mapkey("", "<LEADER>w", "<C-w>w")
mapkey("", "<LEADER>u", "<C-w>k")
mapkey("", "<LEADER>e", "<C-w>j")
mapkey("", "<LEADER>n", "<C-w>h")
mapkey("", "<LEADER>i", "<C-w>l")

-- 使用s + 新方向键 进行分屏
mapcmd("su", "set nosplitbelow<CR>:split<CR>:set splitbelow")
mapcmd("se", "set splitbelow<CR>:split")
mapcmd("sn", "set nosplitright<CR>:vsplit<CR>:set splitright")
mapcmd("si", "set splitright<CR>:vsplit")

-- 使用方向键来调整窗口大小
mapcmd("<up>", "res +5")
mapcmd("<down>", "res -5")
mapcmd("<left>", "vertical resize-5")
mapcmd("<right>", "vertical resize+5")

-- 使分屏窗口上下分布
mapkey("", "sh", "<C-w>t<C-w>K")
-- 使分屏窗口左右分布
mapkey("", "sv", "<C-w>t<C-w>H")

-- 按 <SPACE> + q 关闭当前窗口下方的窗口
mapkey("", "<LEADER>q", "<C-w>j:q<CR>")

-- ===
-- === Tab management
-- ===

-- tu创建新标签
mapcmd("tu", "tabe")
-- 在标签之间移动,已用bufferline.nvim替代
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
-- === Other useful stuff
-- ===

-- 打开一个终端窗口
mapcmd("<LEADER>/", "set splitbelow<CR>:split<CR>:res +10<CR>:term")

-- 按两下空格跳转到占位符<++>,并进入插入模式
mapkey("", "<LEADER><LEADER>", "<Esc>/<++><CR>:nohlsearch<CR>c4l")

-- 拼写检查
mapcmd("<LEADER>sc", "set spell!")

-- 运行代码

vim.cmd([[
 au filetype dart noremap r :wall<cr>:term tmux a <cr>
 au filetype python noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term python %<cr>
 au filetype go noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term go run %<cr>
 au filetype markdown noremap r :MarkdownPreview<cr>
 au filetype rust noremap r :wall<cr>:set splitbelow<cr>:sp<cr>:term cargo run<cr>
]])


-- ===
-- === map function external environment
-- ===

-- 下面的函数给外部文件调用的
-- 使用示例如下
-- local map = require("core.keymap")
-- map:cmd('<space>p','PasteImg')
local map = {}
function map:key(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end
function map:cmd(key, cmd)
	vim.api.nvim_set_keymap('n', key, ':' .. cmd .. '<cr>', { noremap = true })
end
function map:lua(key, txt)
	vim.api.nvim_set_keymap('n', key, ':lua ' .. txt .. '<cr>', { noremap = true })
end

return map
