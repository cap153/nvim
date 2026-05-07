if vim.g.vscode then return end

local P = {
	name = "peek.nvim",
	-- 编译命令：需要环境中安装了 deno
	build_cmd = { "deno", "task", "--quiet", "build:fast" },
}

PackUtils.setup_listener(P.name, P.build_cmd)

-- app = { "zen", "-private-window" },
-- app = { "firefox-esr", "-private-window" },

-- 在插件未加载时，这些命令就存在了。一旦被调用，它们会先加载插件，再执行真正的功能。
vim.api.nvim_create_user_command("PeekToggle", function()
	local is_markdown = vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown'
	if not PackUtils.plugin_loaded[P.name] then
		if is_markdown then
			PackUtils.load(P, function()
				-- 动态决定浏览器配置
				local app = { "chromium", "--app=http://localhost:9000/?theme=dark", "--incognito" }
				if IS_ARM then
					app = { "chromium", "--no-sandbox", "--app=http://localhost:9000/?theme=dark", "--incognito", "--test-type",
						"--force-device-scale-factor=1.75" }
				elseif vim.fn.has("wsl") == 1 then
					app = { "/mnt/d/my_program/chrome-win/chrome.exe", "--no-sandbox", "--app=http://localhost:9000/?theme=dark",
						"--incognito", "--test-type" }
				end
				local peek = require("peek")
				peek.setup({
					port = 9000,
					app = app
				})
				peek.open()
			end)
		end
	else
		local peek = require("peek")
		if peek.is_open() then
			peek.close()
		elseif is_markdown then
			peek.open()
		end
	end
end, { desc = "Lazy load and open Peek" })
