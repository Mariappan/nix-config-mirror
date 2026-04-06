-- Enable lua byte compilation cache
vim.loader.enable()

-- Loads the actual config from separate repo
vim.pack.add({ 'https://github.com/nappairam/nvim12-config' })

-- Loads config from above fake plugin
require('nvim12')
