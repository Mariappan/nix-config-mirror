--
--     dMMMMMMMMb  .aMMMb  .aMMMb  dMMMMb  dMP
--     dMP"dMP"dMP dMP"dMP dMP"dMP dMP.dMP amr
--     dMP dMP dMP dMMMMMP dMMMMMP dMMMMK" dMP
--     dMP dMP dMP dMP dMP dMP dMP dMP"AMF dMP
--     dMP dMP dMP dMP dMP dMP dMP dMP dMP dMP
--
-- Author: Mariappan Ramasamy
-- repo  : https://gitlab.com/mariappan/dotfiles

vim.cmd("filetype plugin indent on")

require("pluginmanager")

require("options")
require("mappings")
require("commands")

require("gui")

require("autocmds")
