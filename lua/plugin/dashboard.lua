return {
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
    {
      section = "terminal",
      cmd = "chafa ~/wall --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
      height = 17,
      padding = 1,
    },
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },
  },
}
