return {
  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },

  ensure_installed = {
    "bicep-lsp",
    -- "csharp-language-server",
    -- "csharpier",
    "css-lsp",
    -- "fantomas",
    -- "fsautocomplete",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "omnisharp",
    "prettier",
    "stylua",
    "xmlformatter",
    "zig",
  },
  max_concurrent_installers = 10,
}
