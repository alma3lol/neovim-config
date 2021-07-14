local dap = require('dap')
local variables = require('dap.ui.variables')

function _G.HoverInfo()
	local debugSession = dap.session()
	if debugSession == nil then
		vim.lsp.buf.hover()
	else
		variables.hover()
	end
end
