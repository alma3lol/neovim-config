local providers = require('feline.providers')

providers['battery'] = function()
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
	return icon .. tostring(value)
end

providers['os_type'] = function ()
	local os = vim.bo.fileformat:upper()
    local icon
    if os == 'UNIX' then
        icon = '  '
    elseif os == 'MAC' then
        icon = '  '
    else
        icon = '   '
    end
    return icon
end
