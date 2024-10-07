return {
	"3rd/image.nvim",
	dependencies = {
		"vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
        rocks = { "magick" },
    },
	},
	config = function()
		-- default config
		require("image").setup({
			backend = "kitty",
			-- backend = "ueberzug",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false, -- 插入模式的时候隐藏
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = true,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "norg" },
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = true, -- 当打开重叠的浮动窗口时隐藏图片
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
			tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
		})
	end
}

