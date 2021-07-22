local providers = require('feline.providers')

providers.add_provider('battery', function()
	return vim.fn['battery#component']()
end)
