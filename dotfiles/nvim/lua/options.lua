-- Options
local Type = { GLOBAL_OPTION = "o", WINDOW_OPTION = "wo", BUFFER_OPTION = "bo" }
local add_options = function(option_type, options)
  if type(options) ~= "table" then
    error('options should be a type of "table"')
    return
  end
  local vim_option = vim[option_type]
  for key, value in pairs(options) do
    vim_option[key] = value
  end
end
local Option = {}
Option.g = function(options)
  add_options(Type.GLOBAL_OPTION, options)
end
Option.w = function(options)
  add_options(Type.WINDOW_OPTION, options)
end
Option.b = function(options)
  add_options(Type.BUFFER_OPTION, options)
end

Option.g({
  compatible = false,
  encoding = "utf-8",
  termguicolors = true,
  mouse = "nv",
  shiftwidth = 4,
  tabstop = 4,
  softtabstop = 4, -- Backspace deletes 4 spaces
  expandtab = true,
  shortmess = "filnxtToOF", -- "atIcF",
  updatetime = 500,
  listchars = "tab:→-,trail:▓,eol:↴", -- "  ▓ ∴ ₀ ∙ ▪ ○ ● ← ⁺ ━ ✠☞  ₊  ▲  ♪
  list = true,
  hlsearch = true,
  incsearch = true,
  showmatch = true,
  colorcolumn = "81,96,98,100",
  backspace = "indent,eol,start",
  backup = false,
  swapfile = false,
  switchbuf = "useopen",
  numberwidth = 5, -- number width of line number
  autoindent = true,
  smartindent = true,
  wildmenu = true,
  -- wildchar = "<TAB>",
  -- completeopt = "longest,menuone",
  completeopt = "longest,menuone,menu,noinsert,noselect",
  clipboard = "unnamedplus",
  hidden = true,
  showmode = false,
  timeoutlen = 3e3,
  conceallevel = 0,
  laststatus = 3,
  wrap = true,
  linebreak = true,
  wildmode = "full",
  autoread = true,
  redrawtime = 500,
  fillchars = vim.o.fillchars .. "vert:│",
  undofile = true,
  virtualedit = "onemore",
  guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
  cursorline = true,
  complete = ".,w,b,u,t,k",
  formatoptions = "jtcroql",
  inccommand = "nosplit",
  winblend = 25,
  pumblend = 25,
  isfname = table.concat(
    vim.tbl_filter(function(entry)
      if entry == "=" then
        return false
      else
        return true
      end
    end, vim.split(vim.o.isfname, ",")),
    ","
  ),
  diffopt = "internal,filler,closeoff,algorithm:patience,iwhiteall",
  splitbelow = true,
  emoji = false,
  cmdheight = 0,
})
Option.b({
  swapfile = false,
  shiftwidth = 2,
})
Option.w({
  number = true,
  numberwidth = 1,
  signcolumn = "yes",
  spell = false,
  foldlevel = 99,
  foldmethod = "syntax",
  -- foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldtext = "v:lua.foldText()",
  linebreak = true,
})

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = false,
  }
end

return Option
