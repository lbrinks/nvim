return{
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("nvim-tree").setup({
        view={
          number=true,
          relativenumber=true },
          modified={enable=true, },
        })
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end
    },
  }
