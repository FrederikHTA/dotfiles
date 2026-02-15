return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-repeat",
  "RRethy/vim-illuminate",
  "tpope/vim-sleuth",
  "nvim-telescope/telescope-ui-select.nvim",
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... }, -- Gruvbox theme

  -- blink.cmp is a completion plugin with support for LSPs, cmdline, signature help, and snippets.
  -- { -- optional blink completion source for require statements and module annotations
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       -- add lazydev to your completion providers
  --       default = { "lsp", "path", "snippets", "buffer" },
  --     },
  --   },
  -- },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    config = function()
      require("copilot").setup {}
    end,
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
      },
      -- panel = { enabled = false },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  -- File explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  -- Which-key pop-up to help remember neovim keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function() end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup {
        preset = "minimal",
      }
      -- vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },

  -- Lightweight yet powerful formatter plugin for Neovim
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Deep buffer integration for Git
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   event = "User FilePost",
  --   opts = function()
  --     return require "configs.gitsigns"
  --   end,
  -- },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lspconfig").defaults()
    end,
  },

  {
    "kylechui/nvim-surround",
    -- Use for stability; omit to use `main` branch for the latest features
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
      "saadparwaiz1/cmp_luasnip",
      "ray-x/cmp-treesitter",
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    event = "InsertEnter",
    config = function()
      return require "configs.cmp"
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      label = {
        rainbow = {
          enabled = true,
          shade = 5,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      -- {
      --   "r",
      --   mode = "o",
      --   function()
      --     require("flash").remote()
      --   end,
      --   desc = "Remote Flash",
      -- },
      -- {
      --   "R",
      --   mode = { "o", "x" },
      --   function()
      --     require("flash").treesitter_search()
      --   end,
      --   desc = "Treesitter Search",
      -- },
      -- {
      --   "<c-s>",
      --   mode = { "c" },
      --   function()
      --     require("flash").toggle()
      --   end,
      --   desc = "Toggle Flash Search",
      -- },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
