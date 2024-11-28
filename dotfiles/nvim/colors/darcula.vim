set background=dark
let g:colors_name="darcula"

lua package.loaded['colors.darcula'] = nil

lua require('lush')(require('colors.darcula'))
