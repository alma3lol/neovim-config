local dap = require('dap')
-- local variables = require('dap.ui.variables')
local lspSaga = require('lspsaga.hover')

function _G.HoverInfo()
	local debugSession = dap.session()
	-- local status = debugSession.status();
	-- print(debugSession)
	-- print(status)
	if debugSession == nil or debugSession.stopped_thread_id == nil then
		lspSaga.render_hover_doc()
	else
		-- variables.hover()
	end
end
