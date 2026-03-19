" =============================================================
" gruber-darker airline theme
" Mirrors gruber-darker-theme.el palette exactly
"
" USAGE:
"   let g:airline_theme = 'gruber_darker'
"
" LOCATION:
"   autoload/airline/themes/gruber_darker.vim
" =============================================================

let g:airline#themes#gruber_darker#palette = {}

" --- Palette ---
let s:fg       = ['#e4e4ef', 253]
let s:white    = ['#ffffff', 231]
let s:bg       = ['#181818', 234]
let s:bg1      = ['#282828', 235]
let s:bg2      = ['#453d41', 238]
let s:yellow   = ['#ffdd33', 220]
let s:green    = ['#73c936',  76]
let s:niagara  = ['#96a6c8', 147]
let s:quartz   = ['#95a99f', 108]
let s:wisteria = ['#9e95c7',  98]
let s:brown    = ['#cc8c3c', 172]
let s:red      = ['#f43841', 196]

" Helper: build an airline cell [guifg, guibg, ctermfg, ctermbg]
function! s:cell(fg, bg)
  return [a:fg[0], a:bg[0], a:fg[1], a:bg[1]]
endfunction

" --- NORMAL (yellow badge) ---
let s:N1 = s:cell(s:bg, s:yellow)
let s:N2 = s:cell(s:quartz, s:bg2)
let s:N3 = s:cell(s:fg, s:bg1)
let g:airline#themes#gruber_darker#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#gruber_darker#palette.normal_modified = {
      \ 'airline_c': s:cell(s:yellow, s:bg1)
      \ }

" --- INSERT (green badge) ---
let s:I1 = s:cell(s:bg, s:green)
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#gruber_darker#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#gruber_darker#palette.insert_modified = g:airline#themes#gruber_darker#palette.normal_modified

" --- VISUAL (niagara badge) ---
let s:V1 = s:cell(s:bg, s:niagara)
let g:airline#themes#gruber_darker#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
let g:airline#themes#gruber_darker#palette.visual_modified = g:airline#themes#gruber_darker#palette.normal_modified

" --- REPLACE (red badge) ---
let s:R1 = s:cell(s:white, s:red)
let g:airline#themes#gruber_darker#palette.replace = airline#themes#generate_color_map(s:R1, s:N2, s:N3)
let g:airline#themes#gruber_darker#palette.replace_modified = g:airline#themes#gruber_darker#palette.normal_modified

" --- INACTIVE ---
let s:IA = s:cell(s:quartz, s:bg1)
let g:airline#themes#gruber_darker#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

" --- WARNING & ERROR ---
let g:airline#themes#gruber_darker#palette.normal.airline_warning = s:cell(s:bg, s:brown)
let g:airline#themes#gruber_darker#palette.normal.airline_error = s:cell(s:white, s:red)