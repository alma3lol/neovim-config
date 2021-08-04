vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
)

local nvim_lsp = require "lspconfig"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.tsserver.setup {
    capabilities = capabilities,
    on_attach = function()
        vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
        vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
        vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    end
}

nvim_lsp.pyright.setup {}

local lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/Windows/lua-language-server.exe")
if vim.fn.has('unix') == 1 then
    lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/Linux/lua-language-server")
elseif vim.fn.has('mac') == 1 then
    lua_bin = vim.fn.expand("$CWD/lua-language-server/bin/macOS/lua-language-server")
end

nvim_lsp.sumneko_lua.setup {
    cmd = { lua_bin, "-E", vim.fn.expand("$CWD/lua-language-server/main.lua") },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                globals = {'vim'}
            },
            workspace = {
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true},
                maxPreload = 2000,
                checkThirdParty = false,
            }
        }
    }
}
