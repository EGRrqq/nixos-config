require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	padding = { inner = 1, outer = 1 },

	style_a = {
		bg = "white",
		fg = "black",
		bg_mode = {
			normal = "white",
			select = "brightyellow",
			un_set = "brightred",
		},
	},
	style_b = { bg = "brightblack", fg = "brightwhite" },
	style_c = { bg = "black", fg = "brightwhite" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	files = { icon = "", fg = "blue" },
	filtereds = { icon = "", fg = "magenta" },

	total = { icon = "󰮍", fg = "yellow" },
	success = { icon = "", fg = "green" },
	failed = { icon = "", fg = "red" },

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = { { type = "line", name = "tabs" } },
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = { { type = "string", name = "date", params = { "%A, %d %B %Y" } } },
			section_b = { { type = "string", name = "date", params = { "%X" } } },
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = { { type = "string", name = "tab_mode" } },
			section_b = { { type = "string", name = "hovered_size" } },
			section_c = {
				{ type = "string", name = "hovered_path" },
				{ type = "coloreds", name = "count" },
				{ type = "coloreds", name = "githead" },
			},
		},
		right = {
			section_a = { { type = "string", name = "cursor_position" } },
			section_b = { { type = "string", name = "cursor_percentage" } },
			section_c = {
				{ type = "string", name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})

require("yatline-githead"):setup({
	show_numbers = true,
})

require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
	enter_mode = "first",
})

require("git"):setup({ order = 1500 })

require("smart-enter"):setup({ open_multi = true })

require("bookmarks"):setup({
	persist = "all",
	show_keys = true,
	notify = { enable = true, timeout = 1 },
})

require("full-border"):setup({ type = ui.Border.ROUNDED })

require("duckdb"):setup({ mode = "standard" })

require("sshfs"):setup()

require("gvfs"):setup({
	input_position = { "center", y = 0, w = 60 },
})

require("recycle-bin"):setup()

require("yafg"):setup({ editor = "hx" })