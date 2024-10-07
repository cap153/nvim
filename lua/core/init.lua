-- ===
-- === Editor behavior
-- ===

-- 开启左侧数字
vim.o.number = true
-- 始终隐藏字符（不依赖语法高亮）,在 Markdown 文件中，粗体、斜体等标记字符可能会被隐藏
vim.opt.conceallevel = 2
-- 使用相对数
vim.o.relativenumber = true
-- 高亮当前行
vim.o.cursorline = true
-- 一行不能完全显示时自动换行
vim.o.wrap = true
-- 在最后一行显示一些内容
vim.o.showcmd = true
-- 命令模式显示补全菜单
vim.o.wildmenu = true
-- /搜索时忽略大小写
vim.o.ignorecase = true
-- /搜索时智能大小写
vim.o.smartcase = true
-- 共享系统剪切
vim.o.clipboard = 'unnamedplus'
-- 设置<tab>键
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
-- 随文件自动更改当前路径
vim.o.autochdir = true
-- 在光标上方和下方保留的最小屏幕行数
vim.o.scrolloff = 4
-- 自动缩进
vim.o.smartindent = true
-- 100毫秒没有输入文件将会自动保存交换文件
vim.o.updatetime = 100
-- 开启鼠标
vim.o.mouse = 'a'
-- 开启颜色
vim.o.termguicolors = true

-- 设置编码格式
vim.o.fileencodings = 'utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1'
vim.o.enc = 'utf8'

-- 保存修改历史
vim.o.swapfile = true
vim.o.undofile = true

-- 保存折叠记录，在某些独立的窗口会报错
-- vim.cmd 'au BufWinLeave * silent mkview'
-- vim.cmd 'au BufWinEnter * silent loadview'

-- 打开文件时进入上次编辑的位置
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- fcitx5在normal模式时自动切换为英文输入法,摘自fcitx5的archwiki
vim.cmd([[
autocmd InsertLeave * :silent !fcitx5-remote -c
autocmd BufCreate *  :silent !fcitx5-remote -c 
autocmd BufEnter *  :silent !fcitx5-remote -c 
autocmd BufLeave *  :silent !fcitx5-remote -c
]])
-- 意为:
-- 当 进入插入模式 时 触发shell命令 fcitx-remote -c 关闭输入法，改为英文输入
-- 当 创建Buf 时 触发shell命令 fcitx-remote -c 关闭输入法，改为英文输入
-- 当 进入Buf 时 触发shell命令 fcitx-remote -c 关闭输入法, 改为英文输入
-- 当 离开Buf 时 触发shell命令 fcitx-remote -c 关闭输入法, 改为英文输入

-- 开启高亮复制
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])










