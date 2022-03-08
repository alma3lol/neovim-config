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

function _G.lsp_client_names()
    local clients = {}

    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
        clients[#clients + 1] = client.name
    end

    return table.concat(clients, ' '), ' '
end

function _G.battery_status()
    local backend = vim.fn['battery#backend']()
    local value = backend.value
    local is_charging = backend.is_charging
    local icon = '?? '
    if (value >= 0) then
        icon = ' '
    end
    if (value >= 10) then
        icon = ' '
    end
    if (value >= 20) then
        icon = ' '
    end
    if (value >= 30) then
        icon = ' '
    end
    if (value >= 40) then
        icon = ' '
    end
    if (value >= 50) then
        icon = ' '
    end
    if (value >= 60) then
        icon = ' '
    end
    if (value >= 70) then
        icon = ' '
    end
    if (value >= 80) then
        icon = ' '
    end
    if (value >= 90) then
        icon = ' '
    end
    if (value == 100) then
        icon = ' '
    end
    if (is_charging == 1) then
        icon = ' '
    end
    return icon .. tostring(value) .. '%%'
end
