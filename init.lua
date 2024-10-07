
-- 基本配置
require("core.init")

-- 基本键盘映射
require("core.keymap")

-- vim综合症
require("core.cursor")

-- markdown snippets
require("core.md-snippets")

-- markdown table fromat
require("core.markdown_table_format")

-- 安装的插件
require("lazy.index")

-- 本地备份配置方式如下
-- # required
-- mv ~/.config/nvim{,.bak}
-- # optional but recommended
-- mv ~/.local/share/nvim{,.bak}
-- mv ~/.local/state/nvim{,.bak}
-- mv ~/.cache/nvim{,.bak}
