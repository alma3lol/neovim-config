vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 2,
      prefix = ' '
    },
    signs = true,
    update_in_insert = true,
  }
)

local nvim_lsp = require "lspconfig"
local lsp_status = require "lsp-status"
local protocol = require "vim.lsp.protocol"
local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
lsp_status.register_progress()
lsp_status.config({
  current_function = false,
  show_filename = false,
  diagnostics = false,
  status_symbol = '✓',
})

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client, bufnr)
  if client.resolved_capabilities.document_symbol then
    vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  end
  require "lsp-format".on_attach(client)
  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end

nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

nvim_lsp.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

local lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/Windows/lua-language-server.exe")
if vim.fn.has('unix') == 1 then
  lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/Linux/lua-language-server")
elseif vim.fn.has('mac') == 1 then
  lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/macOS/lua-language-server")
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
  cmd = { lua_bin, "-E", vim.fn.expand("$CWD/lua-language-server/main.lua") },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = {'vim'}
      },
      workspace = {
        library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true},
        maxPreload = 2000,
        checkThirdParty = false,
      },
      telemetry = {
        enable = false
      }
    }
  }
}

nvim_lsp.jsonls.setup {
  cmd = {"vscode-json-languageserver", "--stdio"},
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {"json", "jsonc"},
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
      {
          fileMatch = {"typescript.json", "typescriptreact.json"},
          url = "https://raw.githubusercontent.com/Yash-Singh1/vscode-snippets-json-schema/main/schema.json"
        },
      {
          fileMatch = {"package.json"},
          url = "https://json.schemastore.org/package.json"
        },
      {
          fileMatch = {"tsconfig*.json"},
          url = "https://json.schemastore.org/tsconfig.json"
        },
      {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json"
          },
          url = "https://json.schemastore.org/prettierrc.json"
        },
      {
          fileMatch = {".eslintrc", ".eslintrc.json"},
          url = "https://json.schemastore.org/eslintrc.json"
        },
      {
          fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
          url = "https://json.schemastore.org/babelrc.json"
        },
      {
          fileMatch = {"lerna.json"},
          url = "https://json.schemastore.org/lerna.json"
        },
      {
          fileMatch = {"now.json", "vercel.json"},
          url = "https://json.schemastore.org/now.json"
        },
      {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json"
          },
          url = "http://json.schemastore.org/stylelintrc.json"
        }
      }
    }
  }
}

nvim_lsp.solidity_ls.setup{
  on_attach = require "lsp-format".on_attach,
}
