local M = {}

M.default_opts = {noremap = true, silent = true}

M.nnoremap = function(key, action, options)
	local opts = M.default_opts
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('n', key, action, opts)
end

M.nmap = function(key, action, options)
	local opts = {noremap = false, silent = true}
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('n', key, action, opts)
end

M.inoremap = function(key, action, options)
	local opts = M.default_opts
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('i', key, action, opts)
end

M.imap = function(key, action, options)
	local opts = {noremap = false, silent = true}
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('i', key, action, opts)
end

M.vnoremap = function(key, action, options)
	local opts = M.default_opts
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('v', key, action, opts)
end

M.vmap = function(key, action, options)
	local opts = {noremap = false, silent = true}
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('v', key, action, opts)
end

M.onoremap = function(key, action, options)
	local opts = M.default_opts
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('o', key, action, opts)
end

M.omap = function(key, action, options)
	local opts = {noremap = false, silent = true}
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('o', key, action, opts)
end

M.xnoremap = function(key, action, options)
	local opts = M.default_opts
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('x', key, action, opts)
end

M.xmap = function(key, action, options)
	local opts = {noremap = false, silent = true}
	if options then
		opts = options
	end
	return vim.api.nvim_set_keymap('x', key, action, opts)
end

M.nnoremap('<leader><leader>uf', '<cmd>%foldo<CR>')
M.nnoremap('<leader><leader>df', '<cmd>%foldc<CR>')
M.nnoremap('<leader>mrr', '<cmd>MruRepo<CR>')
M.nnoremap('<leader>mrf', '<cmd>Mru<CR>')
M.nnoremap('<leader>mff', '<cmd>Mfu<CR>')
M.nnoremap('s', '<cmd>lua require("substitute").operator()<cr>')
M.nnoremap('ss', '<cmd>lua require("substitute").line()<cr>')
M.nnoremap('S', '<cmd>lua require("substitute").eol()<cr>')
M.xnoremap('s', '<cmd>lua require("substitute").visual()<cr>')
M.nnoremap('<leader>s', '<cmd>lua require("substitute.range").operator()<cr>')
M.nnoremap('<leader>ss', '<cmd>lua require("substitute.range").word()<cr>')
M.xnoremap('<leader>s', '<cmd>lua require("substitute.range").visual()<cr>')
M.nnoremap('sx', '<cmd>lua require("substitute.exchange").operator()<cr>')
M.nnoremap('sxx', '<cmd>lua require("substitute.exchange").line()<cr>')
M.nnoremap('sxc', '<cmd>lua require("substitute.exchange").cancel()<cr>')
M.xnoremap('X', '<cmd>lua require("substitute.exchange").visual()<cr>')

return M
