if vim.g.vscode then return end

local P = {
	name = "peek.nvim",
	-- 编译命令：需要环境中安装了 deno
	build_cmd = { "deno", "task", "--quiet", "build:fast" },
}

PackUtils.setup_listener(P.name, P.build_cmd)

-- 在插件未加载时，这些命令就存在了。一旦被调用，它们会先加载插件，再执行真正的功能。
vim.api.nvim_create_user_command("PeekToggle", function()
	local peek = require("peek")
	if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown' then
		PackUtils.load(P, function()
			local app = { "chromium", "--app=http://localhost:9000/?theme=dark", "--incognito" }
			if IS_ARM then
				app = { "chromium", "--no-sandbox", "--app=http://localhost:9000/?theme=dark", "--incognito", "--test-type",
					"--force-device-scale-factor=1.75" }
			end
			require("peek").setup({
				port = 9000,
				-- app = { "zen", "-private-window" },
				-- app = { "firefox-esr", "-private-window" },
				app = app
			})
		end)
		peek.open()
	else -- 只有加载了插件的情况下执行关闭，这样可以跳过非markdown文件
		if PackUtils.plugin_loaded[P.name] then
			peek.close()
		end
	end
end, { desc = "Lazy load and open Peek" })
