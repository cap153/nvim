-- ==============================================================
-- 插件花名册
-- ==============================================================
local specs = {
	-- 公共依赖
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/williamboman/mason.nvim',
	'https://github.com/mason-org/mason-registry',
	'https://github.com/nvim-tree/nvim-web-devicons',
	-- blinkcmp.lua 自动补全、代码片段
	{ src = 'https://github.com/saghen/blink.cmp', version = "v1" },
	'https://github.com/rafamadriz/friendly-snippets',
	-- lspconfig.lua
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/williamboman/mason-lspconfig.nvim',
	'https://github.com/MysticalDevil/inlay-hints.nvim',
	-- conform.lua 格式化工具formatter
	"https://github.com/stevearc/conform.nvim",
	-- treesitter.lua 需要安装tree-sitter-cli工具包
	'https://github.com/nvim-treesitter/nvim-treesitter',
	-- indentblankline.lua 彩虹缩进
	'https://github.com/lukas-reineke/indent-blankline.nvim',
	-- rainbowdelimiters.lua 彩虹括号
	'https://github.com/HiPhish/rainbow-delimiters.nvim',
	-- illuminate.lua 高亮所有引用
	'https://github.com/RRethy/vim-illuminate',
	-- gitsigns.lua 突出增、删、改过的行
	'https://github.com/lewis6991/gitsigns.nvim',
	-- ufo.lua 折叠插件
	'https://github.com/kevinhwang91/nvim-ufo',
	'https://github.com/kevinhwang91/promise-async',
	-- undotree.lua
	'https://github.com/jiaoshijie/undotree',
	-- stickscroll.lua 代码函数名称浏览时固定
	'https://github.com/nvim-treesitter/nvim-treesitter-context',
	-- bufferline.lua 顶部状态栏
	'https://github.com/akinsho/bufferline.nvim',
	-- lualine.lua 底部状态栏
	'https://github.com/nvim-lualine/lualine.nvim',
	-- outline.lua 大纲、函数变量结构
	'https://github.com/hedyhli/outline.nvim',
	-- noice.lua 取代消息、命令行和弹出菜单的 UI
	'https://github.com/folke/noice.nvim',
	'https://github.com/MunifTanjim/nui.nvim',
	-- snacks.lua 图片预览、lazygit、lsp_references模糊查找
	'https://github.com/folke/snacks.nvim',
	-- mini.lua 各种对字符的surround包裹{} [] ''
	'https://github.com/echasnovski/mini.nvim',
	-- autopairs.lua 对字符自动补全另一半
	'https://github.com/windwp/nvim-autopairs',
	-- tv.lua 模糊查找television
	'https://github.com/alexpasmantier/tv.nvim',
	-- coderunner.lua 运行代码
	'https://github.com/CRAG666/code_runner.nvim',
	-- peek.lua 预览markdown
	'https://github.com/cap153/peek.nvim',
	-- yazi.lua 文件管理器
	'https://github.com/mikavilpas/yazi.nvim',
	-- translate.lua 快捷键翻译
	'https://github.com/uga-rosa/translate.nvim',
	-- sudo权限保存文件
	'https://github.com/lambdalisue/vim-suda',
	-- 查看可用键位
	'https://github.com/folke/which-key.nvim',
}
-- 禁用插件：不会加载，不会下载(如果是新添加的)，已在硬盘上不会被删除
local disabled = {
	-- { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' }, -- 指定版本，暂时不想用，但想留着源码
}

-- ==============================================================
-- 快捷管理命令
-- ==============================================================

-- 获取所有已安装插件的名称列表（用于 Tab 补全）
local function get_plugin_names(arg_lead)
	local installed = vim.pack.get(nil, { info = false })
	local names = {}
	for _, p in ipairs(installed) do
		local name = p.spec.name
		-- 只添加匹配开头字符串的插件
		if name:lower():find(arg_lead:lower(), 1, true) == 1 then
			table.insert(names, name)
		end
	end
	-- 排序让补全列表更整洁
	table.sort(names)
	return names
end

-- :PackUpdate 命令更新插件，不带参数更新全部，默认显示审查界面（需按 :w 确认）；可以加 ! 强制直接更新
vim.api.nvim_create_user_command("PackUpdate", function(opts)
	local targets = #opts.fargs > 0 and opts.fargs or nil
	local force = opts.bang -- 如果输入了 PackUpdate! 则 opts.bang 为 true
	if targets then
		vim.notify("Checking updates for: " .. table.concat(targets, ", "), vim.log.levels.INFO)
	else
		vim.notify("Checking updates for all plugins...", vim.log.levels.INFO)
	end
	vim.pack.update(targets, { force = force })
end, {
	nargs = "*",
	bang = true, -- 声明支持 ! 符号
	complete = get_plugin_names,
	desc = "Update plugins (use ! to skip confirmation)",
})

-- :PackStatus 命令查看插件当前状态和版本
vim.api.nvim_create_user_command("PackStatus", function(opts)
	local targets = #opts.fargs > 0 and opts.fargs or nil
	vim.pack.update(targets, { offline = true })
end, {
	nargs = "*",
	complete = get_plugin_names,
	desc = "Check plugin status without downloading",
})

-- ==============================================================
-- 插件管理引擎 (PackUtils) (暴露给全局，供 configs/*.lua 调用)
-- ==============================================================
_G.PackUtils = {
	is_building = {},     -- 记录各插件的构建状态，防止重复构建
	is_initialized = {},  -- 记录具体的配置代码块是否已执行
	plugin_loaded = {},   -- 记录插件是否已挂载 (避免重复 packadd)
	disabled_plugins = {}, -- 专门记录被禁用的插件，供 load 拦截使用
}

-- [解析插件名]
function PackUtils.get_name(spec)
	local url = type(spec) == "table" and spec.src or spec
	return type(spec) == "table" and spec.name or url:match("([^/]+)$"):gsub("%.git$", "")
end

-- [同步清理] 自动删除孤儿，并注册禁用名单
function PackUtils.sync(active_specs, disabled_specs)
	disabled_specs = disabled_specs or {}
	local protected_names = {}

	-- 将插件加入受保护名单
	for _, spec in ipairs(active_specs) do
		protected_names[PackUtils.get_name(spec)] = true
	end
	for _, spec in ipairs(disabled_specs) do
		local name = PackUtils.get_name(spec)
		protected_names[name] = true
		PackUtils.disabled_plugins[name] = true -- 写入字典，供 load 拦截
	end

	-- 扫描磁盘
	local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
	local installed_plugins = {}
	local packages = vim.fn.expand(pack_dir .. "/*", false, true)
	for _, pkg in ipairs(packages) do
		for _, type_dir in ipairs({ "start", "opt" }) do
			local path = pkg .. "/" .. type_dir
			if vim.fn.isdirectory(path) == 1 then
				local dirs = vim.fn.expand(path .. "/*", false, true)
				for _, dir in ipairs(dirs) do
					local name = dir:match("([^/]+)$")
					if name ~= "README.md" and name ~= "doc" then
						table.insert(installed_plugins, name)
					end
				end
			end
		end
	end
	-- 找出既不在 active 也不在 disabled 里的孤儿
	local to_delete = {}
	for _, installed in ipairs(installed_plugins) do
		if not protected_names[installed] then
			table.insert(to_delete, installed)
		end
	end

	if #to_delete > 0 then
		vim.schedule(function()
			vim.notify("🧹 Clean Up Orphaned Plugins: " .. table.concat(to_delete, ", "), vim.log.levels.INFO)
			vim.pack.del(to_delete)
		end)
	end
end

-- [动态路径] 获取插件根目录
function PackUtils.get_root(name)
	name = PackUtils.get_name(name)
	local paths = vim.api.nvim_get_runtime_file("pack/*/*/" .. name, true)
	if #paths > 0 then return paths[1] end
	local glob = vim.fn.globpath(vim.o.packpath, "pack/*/*/" .. name, 0, 1)
	return glob[1] or nil
end

-- [构建执行] 执行编译任务
function PackUtils.run_build(name, build_cmd)
	name = PackUtils.get_name(name)
	if PackUtils.disabled_plugins[name] then return end
	if not build_cmd or PackUtils.is_building[name] then return end
	local path = PackUtils.get_root(name)
	if not path then return end
	local stamp = path .. "/.build_done"
	PackUtils.is_building[name] = true

	-- 判断是否为 Neovim 内部命令 (以 : 开头)
	local is_vim_cmd = false
	local vim_cmd_str = ""

	if type(build_cmd) == "string" and build_cmd:sub(1, 1) == ":" then
		is_vim_cmd = true
		vim_cmd_str = build_cmd:sub(2)
	elseif type(build_cmd) == "table" and type(build_cmd[1]) == "string" and build_cmd[1]:sub(1, 1) == ":" then
		is_vim_cmd = true
		vim_cmd_str = table.concat(build_cmd, " "):sub(2)
	end

	if is_vim_cmd then
		-- 在当前实例的空闲时执行 vim.cmd
		vim.schedule(function()
			vim.notify("⚙️ Running " .. name .. " setup command...", vim.log.levels.INFO)
			-- 确保插件在当前实例已经被加载
			pcall(vim.cmd.packadd, name)
			-- 保护执行，防止命令错误导致编辑器崩溃
			local ok, err = pcall(vim.cmd, vim_cmd_str)
			PackUtils.is_building[name] = false
			if ok then
				local f = io.open(stamp, "w")
				if f then f:close() end
				vim.notify("✅ " .. name .. " setup success.", vim.log.levels.INFO)
			else
				vim.notify("❌ " .. name .. " setup failed: " .. tostring(err), vim.log.levels.ERROR)
			end
		end)
	else
		local final_cmd = {}
		if type(build_cmd) == "string" then
			for word in build_cmd:gmatch("%S+") do
				table.insert(final_cmd, word)
			end
		else
			final_cmd = build_cmd
		end
		vim.schedule(function() vim.notify("⚙️ Building " .. name .. " (Background)...", vim.log.levels.INFO) end)
		vim.system(final_cmd, { cwd = path }, function(out)
			PackUtils.is_building[name] = false
			if out.code == 0 then
				local f = io.open(stamp, "w")
				if f then f:close() end
				vim.schedule(function() vim.notify("✅ " .. name .. " build success.", vim.log.levels.INFO) end)
			else
				vim.schedule(function()
					vim.notify("❌ " .. name .. " build failed: " .. (out.stderr or "Unknown Error"), vim.log.levels.ERROR)
				end)
			end
		end)
	end
end

-- [监听器] 注册安装/更新监听
function PackUtils.setup_listener(name, build_cmd)
	name = PackUtils.get_name(name)
	if PackUtils.disabled_plugins[name] then return end
	if not build_cmd then return end
	vim.api.nvim_create_autocmd('PackChanged', {
		pattern = '*',
		callback = function(ev)
			if ev.data.spec.name == name and (ev.data.kind == "update" or ev.data.kind == "install") then
				local stamp = ev.data.path .. "/.build_done"
				os.remove(stamp) -- 自动删除.build_done文件触发构建
				PackUtils.run_build(name, build_cmd)
			end
		end
	})
end

-- [健康检查] 如果没标记且有构建命令，则触发构建
function PackUtils.check_health(name, build_cmd)
	name = PackUtils.get_name(name)
	if PackUtils.disabled_plugins[name] then return end
	if not build_cmd then return end
	local path = PackUtils.get_root(name)
	if path then
		local stamp = path .. "/.build_done"
		if vim.fn.filereadable(stamp) == 0 then
			PackUtils.run_build(name, build_cmd)
		end
	end
end

-- 全方位防崩加载引擎
function PackUtils.load(P, config_fn)
	-- 生成如 "lua/pack/configs/mini.lua:24" 这样绝对唯一的 call_id
	local info = debug.getinfo(2, "Sl")
	local call_id = (info.short_src or "unknown") .. ":" .. (info.currentline or 0)

	-- 精准拦截：如果【这一行代码】已经成功执行过，直接跳过
	if PackUtils.is_initialized[call_id] then return end

	P.name = PackUtils.get_name(P.name)
	if P.deps then
		for i, dep in ipairs(P.deps) do
			P.deps[i] = PackUtils.get_name(dep)
		end
	end

	if PackUtils.disabled_plugins[P.name] then return end
	-- 磁盘中找不到，说明它正在异步克隆下载，直接静默退出
	if not PackUtils.get_root(P.name) then return end

	-- 插件级操作：整个生命周期只需做一次的动作 (检查编译和挂载)
	if not PackUtils.plugin_loaded[P.name] then
		PackUtils.check_health(P.name, P.build_cmd)
		pcall(vim.cmd.packadd, P.name)

		if P.deps then
			for _, dep in ipairs(P.deps) do
				local dep_ok = pcall(vim.cmd.packadd, dep)
				if not dep_ok then
					vim.notify("Warning: " .. P.name .. " dependency[" .. dep .. "] missing", vim.log.levels.WARN)
				end
			end
		end
		-- 标记该仓库已挂载
		PackUtils.plugin_loaded[P.name] = true
	end

	-- 保护 Setup 执行：自由地 require，如有拼写错误，这里的 pcall 会完美捕获并报错
	if config_fn then
		local setup_ok, err = pcall(config_fn)
		if not setup_ok then
			vim.notify("Error: " .. P.name .. " setup failed: \n" .. tostring(err), vim.log.levels.ERROR)
			return
		end
	end

	-- 标记【具体的代码块】已执行完毕
	PackUtils.is_initialized[call_id] = true
end

-- ==============================================================
-- 执行启动流程
-- ==============================================================

-- 同步清理孤儿插件并注册禁用名单
PackUtils.sync(specs, disabled)

-- 正式下载/更新插件
vim.pack.add(specs)

-- 加载 configs/ 注册所有监听器
local config_path = vim.fn.stdpath("config") .. "/lua/pack/configs"
if vim.fn.isdirectory(config_path) == 1 then
	for name, type in vim.fs.dir(config_path) do
		if type == "file" and name:match("%.lua$") then
			pcall(require, "pack.configs." .. name:gsub("%.lua$", ""))
		end
	end
end
