require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	padding = { inner = 1, outer = 1 },

	style_a = {
		bg = "#0184bc",
		fg = "#fafafa",
		bg_mode = {
			normal = "#0184bc",
			select = "#e45649",
			un_set = "#c18401",
		},
	},
	style_b = { bg = "#e5e5e6", fg = "#383a42" },
	style_c = { bg = "#fafafa", fg = "#383a42" },

	permissions_t_fg = "#a0a1a7",
	permissions_r_fg = "#50a14f",
	permissions_w_fg = "#e45649",
	permissions_x_fg = "#0997b3",
	permissions_s_fg = "#a0a1a7",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "#c18401" },
	copied = { icon = "", fg = "#50a14f" },
	cut = { icon = "", fg = "#e45649" },

	files = { icon = "", fg = "#0184bc" },
	filtereds = { icon = "", fg = "#a626a4" },

	total = { icon = "󰮍", fg = "#c18401" },
	success = { icon = "", fg = "#50a14f" },
	failed = { icon = "", fg = "#e45649" },

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