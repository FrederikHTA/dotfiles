local lualine = require "lualine"

lualine.setup {
  options = {
    theme = "gruvbox",
    -- section_separators = {"", ""},
    -- component_separators = {"", ""},
    section_separators = "",
    component_separators = "",
  },
  sections = { lualine_c = { { "filename", file_status = true, path = 1 } } },
}

require "illuminate"
require "copilot"
-- require "vim-easymotion"
--require "whichkey"
require("lualine").setup()
-- require "blink.cmp"
-- require "ibl"
--
require "gruvbox"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd "colorscheme gruvbox"
