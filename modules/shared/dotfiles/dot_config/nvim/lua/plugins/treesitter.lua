return {
  "nvim-treesitter/nvim-treesitter",
  commit = "90cd6580e720caedacb91fdd587b747a6e77d61f",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash",
        "lua",
        "nix",
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
