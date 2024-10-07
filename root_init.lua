--[[
用以下命令创建root账户neovim配置软链接
sudo mkdir -p /root/.config/nvim/lua/
sudo ln -s ~/.config/nvim/lua/core /root/.config/nvim/lua/core
sudo ln -s ~/.config/nvim/root_init.lua /root/.config/nvim/init.lua
]]--

-- 基本配置
require("core.init")

-- 基本键盘映射
require("core.keymap")

-- vim综合症
require("core.cursor")

-- markdown snippets
require("core.md-snippets")
