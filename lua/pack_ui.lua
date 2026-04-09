local M = {}

local uv = vim.uv

local function scan_files(dir)
  local files = {}
  local function scan(path)
    local fd = uv.fs_scandir(path)
    if not fd then
      return
    end
    while true do
      local name, type = uv.fs_scandir_next(fd)
      if not name then
        break
      end
      local full_path = path .. "/" .. name
      if type == "file" and name:match("%.lua$") then
        table.insert(files, full_path)
      elseif type == "directory" then
        scan(full_path)
      end
    end
  end
  scan(dir)
  return files
end

local function strip_comments(content)
  local result = {}
  for line in content:gmatch("[^\n]*\n?") do
    local cleaned = line:gsub("%-%-.*", "")
    table.insert(result, cleaned)
  end
  return table.concat(result)
end

local function normalize_name(plugin)
  if not plugin or plugin == "" then
    return nil
  end
  plugin = plugin:gsub("^%s+", ""):gsub("%s+$", "")
  plugin = plugin:gsub("/+$", "")
  plugin = plugin:gsub("%.git$", "")
  return plugin:match("([^/]+)$") or plugin
end

local function extract_names_from_content(content)
  local names = {}
  local seen = {}
  content = strip_comments(content)

  local function add_name(raw)
    local name = normalize_name(raw)
    if name and not seen[name] then
      table.insert(names, name)
      seen[name] = true
    end
  end

  content = content:gsub("[%w_%.]*add%s*%(%s*{(.-)}%s*%)", function(block)
    local name = block:match('name%s*=%s*"([^"]+)"')
    if name then
      add_name(name)
    else
      local src = block:match('src%s*=%s*"([^"]+)"')
      if src then
        add_name(src)
      else
        local first = block:match('"([^"]+)"')
        if first then
          add_name(first)
        end
      end
    end
    return ""
  end)

  for plugin in content:gmatch('[%w_%.]*add%s*%(%s*"([^"]+)"%s*%)') do
    add_name(plugin)
  end

  return names
end

local function get_plugin_names()
  local plugin_dir = vim.fn.stdpath("config") .. "/plugin"
  local after_plugin_dir = vim.fn.stdpath("config") .. "/after/plugin"
  local init_file = vim.fn.stdpath("config") .. "/init.lua"
  local lua_dir = vim.fn.stdpath("config") .. "/lua"

  local files = {}
  vim.list_extend(files, scan_files(plugin_dir))
  vim.list_extend(files, scan_files(after_plugin_dir))
  vim.list_extend(files, scan_files(lua_dir))
  table.insert(files, init_file)

  local result = {}
  for _, file in ipairs(files) do
    local f = io.open(file, "r")
    if f then
      local content = f:read("*a")
      f:close()
      for _, name in ipairs(extract_names_from_content(content)) do
        table.insert(result, name)
      end
    end
  end
  return result
end

function M.clean()
  local all_plugins = vim.pack.get(nil, { info = false })
  local conf_plugins = get_plugin_names()
  local conf_lookup = {}
  for _, name in ipairs(conf_plugins) do
    conf_lookup[name] = true
  end

  local to_clean = {}
  for _, p in ipairs(all_plugins) do
    local name = p.spec.name
    if not p.active and not conf_lookup[name] then
      table.insert(to_clean, name)
    end
  end

  if #to_clean == 0 then
    vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
    return
  end

  local msg = string.format("Remove %d non-active plugin(s) not in config?\n\n%s", #to_clean,
    table.concat(to_clean, "\n"))
  local choice = vim.fn.confirm(msg, "&Yes\n&No", 2, "Question")
  if choice == 1 then
    local ok, err = pcall(vim.pack.del, to_clean)
    if ok then
      vim.notify(string.format("vim.pack: removed %d plugin(s)", #to_clean), vim.log.levels.INFO)
    else
      vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

vim.api.nvim_create_user_command("PackClean", M.clean, { desc = "Clean unused plugins" })

local api = vim.api
local ns = api.nvim_create_namespace("pack_list")

local state = {
	bufnr = nil,
	winid = nil,
	expanded = {},
}

local function get_installed_tag(path)
	if not path then
		return nil
	end
	local result = vim.fn.system("git -C " .. vim.fn.shellescape(path) .. " describe --tags --exact-match HEAD 2>/dev/null")
	if vim.v.shell_error == 0 then
		return vim.trim(result)
	end
	return nil
end

local function setup_highlights()
	local links = {
		PackListHeader = "Title",
		PackListLoaded = "String",
		PackListNotLoaded = "Text",
		PackListCleanup = "Comment",
		PackListVersion = "Number",
		PackListSectionHeader = "Label",
		PackListDetail = "Comment",
		PackListButton = "Function",
	}
	for group, target in pairs(links) do
		api.nvim_set_hl(0, group, { link = target, default = true })
	end
end

local function get_version_str(p)
	local v = p.spec.version
	if v == nil then
		return ""
	end
	if type(v) == "string" then
		return v
	end
	return tostring(v)
end

local function build_content()
	local plugins = vim.pack.get(nil, { info = false })
	local conf_plugins = get_plugin_names()
	local conf_lookup = {}
	for _, name in ipairs(conf_plugins) do
		conf_lookup[name] = true
	end

	local loaded = {}
	local not_loaded = {}
	local to_cleanup = {}

	for _, p in ipairs(plugins) do
		local name = p.spec.name
		if p.active then
			table.insert(loaded, p)
		elseif conf_lookup[name] then
			table.insert(not_loaded, p)
		else
			table.insert(to_cleanup, p)
		end
	end

	table.sort(loaded, function(a, b)
		return a.spec.name < b.spec.name
	end)
	table.sort(not_loaded, function(a, b)
		return a.spec.name < b.spec.name
	end)
	table.sort(to_cleanup, function(a, b)
		return a.spec.name < b.spec.name
	end)

	local lines = {}
	local hls = {}

	local function add(text, hl)
		local lnum = #lines
		lines[#lines + 1] = text
		if hl then
			table.insert(hls, { lnum, 0, #text, hl })
		end
	end

	local function add_hl(lnum, col_start, col_end, hl)
		table.insert(hls, { lnum, col_start, col_end, hl })
	end

	local header = string.format(" vim.pack -- %d plugins | %d loaded", #plugins, #loaded)
	add(header, "PackListHeader")

	local win_width = state.winid and api.nvim_win_get_width(state.winid) or 80
	add(" " .. string.rep("─", win_width - 1), "FloatBorder")

	local bar = " [X] Clean  [u] Update  [D]elete  [<CR>] Details  [q] Close"
	add(bar)
	local lnum = #lines - 1
	for s, e in bar:gmatch("()%[.-%]()") do
		add_hl(lnum, s - 1, e - 1, "PackListButton")
	end

	local max_name = 0
	for _, p in ipairs(plugins) do
		max_name = math.max(max_name, #p.spec.name)
	end

	local line_to_plugin = {}
	local function render_plugin(p, icon, hl_group)
		local name = p.spec.name
		local pad = string.rep(" ", max_name - #name + 2)
		local version = get_version_str(p)
		local tag = p.spec.version and get_installed_tag(p.path) or nil
		local rev_short = p.rev and p.rev:sub(1, 7) or ""
		local ver_display = tag or (rev_short ~= "" and rev_short or version)
		local line = string.format("   %s %s%s%s", icon, name, pad, ver_display)
		local lnum_cur = #lines
		add(line)

		local icon_bytes = #icon
		add_hl(lnum_cur, 3, 3 + icon_bytes, hl_group)
		add_hl(lnum_cur, 3 + icon_bytes + 1, 3 + icon_bytes + 1 + #name, hl_group)
		if #ver_display > 0 then
			local ver_start = 3 + icon_bytes + 1 + #name + #pad
			add_hl(lnum_cur, ver_start, ver_start + #ver_display, "PackListVersion")
		end

		line_to_plugin[lnum_cur + 1] = name

		if state.expanded[name] then
			add(string.format("     Path:   %s", p.path), "PackListDetail")
			add(string.format("     Source: %s", p.spec.src), "PackListDetail")
			if p.rev then
				add(string.format("     Rev:    %s", p.rev), "PackListDetail")
			end
		end
	end

	add("")
	add(string.format(" Loaded (%d)", #loaded), "PackListSectionHeader")
	for _, p in ipairs(loaded) do
		render_plugin(p, "●", "PackListLoaded")
	end

	if #not_loaded > 0 then
		add("")
		add(string.format(" Not Loaded (%d)", #not_loaded), "PackListSectionHeader")
		for _, p in ipairs(not_loaded) do
			render_plugin(p, "○", "PackListNotLoaded")
		end
	end

	if #to_cleanup > 0 then
		add("")
		add(string.format(" To Cleanup (%d)", #to_cleanup), "PackListSectionHeader")
		for _, p in ipairs(to_cleanup) do
			render_plugin(p, "✗", "PackListCleanup")
		end
	end

	state.line_to_plugin = line_to_plugin
	return lines, hls
end

local function render()
	if not state.bufnr or not api.nvim_buf_is_valid(state.bufnr) then
		return
	end
	local lines, hls = build_content()
	vim.bo[state.bufnr].modifiable = true
	api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
	vim.bo[state.bufnr].modifiable = false
	vim.bo[state.bufnr].modified = false

	api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
	for _, hl in ipairs(hls) do
		api.nvim_buf_set_extmark(state.bufnr, ns, hl[1], hl[2], {
			end_col = hl[3],
			hl_group = hl[4],
		})
	end
end

local function plugin_at_cursor()
	if not state.winid or not api.nvim_win_is_valid(state.winid) then
		return nil
	end
	local row = api.nvim_win_get_cursor(state.winid)[1]
	return state.line_to_plugin[row]
end

local function close()
	if state.winid and api.nvim_win_is_valid(state.winid) then
		api.nvim_win_close(state.winid, true)
	end
	state.winid = nil
	state.bufnr = nil
	state.expanded = {}
end

local function setup_keymaps()
	local buf = state.bufnr
	local opts = { buffer = buf, silent = true, nowait = true }

	vim.keymap.set("n", "q", close, opts)
	vim.keymap.set("n", "<Esc>", close, opts)

	vim.keymap.set("n", "<CR>", function()
		local name = plugin_at_cursor()
		if name then
			state.expanded[name] = not state.expanded[name]
			render()
		end
	end, opts)

	vim.keymap.set("n", "X", function()
		close()
		M.clean()
	end, opts)

	vim.keymap.set("n", "u", function()
		local name = plugin_at_cursor()
		if name then
			close()
			vim.pack.update({ name })
		end
	end, opts)

	vim.keymap.set("n", "D", function()
		local name = plugin_at_cursor()
		if not name then
			return
		end
		local ok, pdata = pcall(vim.pack.get, { name }, { info = false })
		if not ok or #pdata == 0 then
			vim.notify(string.format("vim.pack: %s is not installed", name), vim.log.levels.WARN)
			return
		end
		if pdata[1].active then
			vim.notify(string.format("vim.pack: %s is active, remove from config first", name), vim.log.levels.WARN)
			return
		end
		local choice = vim.fn.confirm(string.format("Delete plugin %s?", name), "&Yes\n&No", 2, "Question")
		if choice == 1 then
			close()
			local del_ok, err = pcall(vim.pack.del, { name })
			if del_ok then
				vim.notify(string.format("vim.pack: removed %s", name), vim.log.levels.INFO)
			else
				vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end, opts)
end

function M.list()
	if state.winid and api.nvim_win_is_valid(state.winid) then
		api.nvim_set_current_win(state.winid)
		return
	end

	setup_highlights()

	state.bufnr = api.nvim_create_buf(false, true)
	vim.bo[state.bufnr].buftype = "nofile"
	vim.bo[state.bufnr].bufhidden = "wipe"
	vim.bo[state.bufnr].swapfile = false
	vim.bo[state.bufnr].filetype = "nvim-pack"

	local cols = vim.o.columns
	local lines_count = vim.o.lines
	local width = math.min(cols - 4, math.max(math.floor(cols * 0.8), 60))
	local height = math.min(lines_count - 4, math.max(math.floor(lines_count * 0.7), 20))
	local row = math.floor((lines_count - height) / 2)
	local col = math.floor((cols - width) / 2)

	state.winid = api.nvim_open_win(state.bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " vim.pack ",
		title_pos = "center",
	})

	vim.wo[state.winid].cursorline = true
	vim.wo[state.winid].wrap = false

	render()
	setup_keymaps()
end

vim.api.nvim_create_user_command("PackList", M.list, { desc = "List installed plugins" })

return M
