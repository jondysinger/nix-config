local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true

opt.termguicolors = true
opt.showmode = false

opt.hidden = true
opt.autoread = true
opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.winborder = "rounded"
opt.updatetime = 200
opt.timeoutlen = 300

opt.clipboard = "unnamedplus"

-- Force pbcopy/pbpaste on macOS to avoid terminal OSC 52 clipboard limits
if vim.fn.has("mac") == 1 then
  vim.g.clipboard = {
    name = "pbcopy",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
end
