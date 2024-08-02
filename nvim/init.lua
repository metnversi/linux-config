-- Ensure packer.nvim is installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Use packer.nvim to manage plugins
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  -- use 'nyoom-engineering/oxocarbon.nvim' -- Oxocarbon color scheme
  --use {'shaunsingh/oxocarbon.nvim', run = './install.sh'}
  use {'nyoom-engineering/oxocarbon.nvim'}
end)

-- Set the color scheme
vim.cmd('colorscheme oxocarbon')
