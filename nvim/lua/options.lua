local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both" -- to enable cursorline!
-- o.cursorlineopt = "number"

o.foldenable = true
o.foldmethod = "manual"

-- Indenting
o.expandtab = true
-- o.shiftwidth = 2
-- o.tabstop = 2
o.smartindent = true
o.softtabstop = 2

opt.fillchars = { eob = " " }

-- Numbers
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
-- opt.shortmess:append "sI"

o.splitbelow = true
o.splitright = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Make line numbers default
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shiftwidth = 4
opt.tabstop = 4

-- Enable mouse mode
o.mouse = "a"
--  im.opt.guicursor = ""

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
opt.termguicolors = true

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
