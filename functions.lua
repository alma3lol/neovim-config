local M = {}

function M.HoverInfo()
	local debugSession = require'dap'.session()
	print(vim.inspect(debugSession))
	if debugSession == nil then
		vim.lsp.buf.hover()
	else
		require'dap.ui.variables'.hover()
	end
end

return M
