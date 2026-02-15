local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  -- map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gd", require("telescope.builtin").lsp_definitions, opts "Find definitions")
  -- map("n", "gt", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "gt", require("telescope.builtin").lsp_type_definitions, opts "Find type definitions")
  -- map("n", "gi", vim.lsp.buf.implementation, opts "Go go type implementation")
  map("n", "gi", require("telescope.builtin").lsp_implementations, opts "Find definitions")
  map("n", "gu", require("telescope.builtin").lsp_references, opts "Find usages")
  map("n", "K", vim.lsp.buf.hover, opts "Hover Documentation")
  map("i", "<C-s>", vim.lsp.buf.signature_help, opts "Show function signature")
  map("n", "<C-s>", vim.lsp.buf.signature_help, opts "Show function signature")
  map("n", "<leader>rr", vim.lsp.buf.rename, opts "Rename variable")
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Code Action")

  -- TODO: Not sure what these do lol
  -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  -- map("n", "<leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, opts "List workspace folders")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  }

  -- Support 0.10 temporarily
  local lspconfig = require "lspconfig"

  local servers = {
    "cssls",
    "html",
    -- "zls",
    "lua_ls",
  }

  vim.lsp.enable(servers)

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_init = M.on_init,
    on_attach = on_attach,
    settings = lua_lsp_settings,
  }

  lspconfig.zls.setup {
    on_attach = on_attach,
    on_init = M.on_init,
    capabilities = capabilities,
    cmd = { "zls" },
  }
end

return M
