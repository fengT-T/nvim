local dashboard = {
  preset = {
    header = [[
███╗   ██╗██╗   ██╗ █████╗       ██╗   ██╗██╗███╗   ███╗
████╗  ██║╚██╗ ██╔╝██╔══██╗      ██║   ██║██║████╗ ████║
██╔██╗ ██║ ╚████╔╝ ███████║█████╗██║   ██║██║██╔████╔██║
██║╚██╗██║  ╚██╔╝  ██╔══██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║   ██║   ██║  ██║       ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
  },
  sections = {
    { section = "header" },
    -- {
    --   section = "terminal",
    --   cmd = "chafa ~/.wall --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
    --   height = 17,
    --   padding = 1,
    -- },
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bufdelete    = { enabled = true },
    input        = { enabled = true },
    bigfile      = { enabled = true },
    dashboard    = dashboard,
    lazygit      = { enabled = true },
    indent       = { enabled = true },
    quickfile    = { enabled = true },
    scope        = { enabled = true },
    statuscolumn = { enabled = true },
    toggle       = { enabled = true },
    notifier     = { enabled = true },
    notify       = { enabled = true },
    terminal     = { enabled = true },
    picker       = { enabled = false },
    explorer     = { enabled = false },
    words        = { enabled = true }
  }
}
