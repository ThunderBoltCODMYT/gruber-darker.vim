" =============================================================
" gruber-darker lightline colorscheme
" Mirrors gruber-darker-theme.el palette exactly
" Place at: autoload/lightline/colorscheme/gruber_darker.vim
" Usage:    let g:lightline = { 'colorscheme': 'gruber_darker' }
"
" Lightline palette format per cell:
"   [ guifg, guibg, ctermfg, ctermbg ]
" Optionally a 5th element: 'bold', 'italic', etc.
" =============================================================

" --- Palette ---
let s:fg       = ['#e4e4ef', 253]
let s:fg1      = ['#f4f4ff', 255]
let s:white    = ['#ffffff', 231]
let s:bg       = ['#181818', 234]
let s:bg1      = ['#282828', 235]
let s:bg2      = ['#453d41', 238]
let s:bg3      = ['#484848', 239]
let s:bg4      = ['#52494e', 240]
let s:yellow   = ['#ffdd33', 220]
let s:green    = ['#73c936',  76]
let s:niagara  = ['#96a6c8', 147]
let s:quartz   = ['#95a99f', 108]
let s:wisteria = ['#9e95c7',  98]
let s:brown    = ['#cc8c3c', 172]
let s:red      = ['#f43841', 196]
let s:red1     = ['#ff4f58', 203]

" Helper: build a lightline cell [guifg, guibg, ctermfg, ctermbg, ?attr]
function! s:cell(fg, bg, ...)
  let l:c = [a:fg[0], a:bg[0], a:fg[1], a:bg[1]]
  if a:0 > 0 | call add(l:c, a:1) | endif
  return l:c
endfunction

" =============================================================
" PALETTE TABLE
" Keys: normal / insert / visual / replace / command / inactive
" Sections per mode: left / right / middle / tabline / error / warning
"
" left  [0] = a  (mode badge)
" left  [1] = b  (branch / filename)
" right [0] = z  (line/col)
" right [1] = y  (filetype / encoding)
" right [2] = x  (misc right)
" middle[0] = c  (center — used only if configured)
" =============================================================

let s:p = { 'normal':{}, 'insert':{}, 'visual':{}, 'replace':{},
          \ 'command':{}, 'terminal':{}, 'inactive':{}, 'tabline':{} }

" --- NORMAL (yellow badge) ---
let s:p.normal.left   = [ s:cell(s:bg,     s:yellow,  'bold'),
                        \  s:cell(s:quartz, s:bg2           ) ]
let s:p.normal.right  = [ s:cell(s:bg,     s:yellow,  'bold'),
                        \  s:cell(s:quartz, s:bg2           ),
                        \  s:cell(s:fg,     s:bg1           ) ]
let s:p.normal.middle = [ s:cell(s:fg,     s:bg1           ) ]
let s:p.normal.error  = [ s:cell(s:white,  s:red,     'bold') ]
let s:p.normal.warning= [ s:cell(s:bg,     s:brown,   'bold') ]

" --- INSERT (green badge) ---
let s:p.insert.left   = [ s:cell(s:bg,     s:green,   'bold'),
                        \  s:cell(s:quartz, s:bg2           ) ]
let s:p.insert.right  = [ s:cell(s:bg,     s:green,   'bold'),
                        \  s:cell(s:quartz, s:bg2           ),
                        \  s:cell(s:fg,     s:bg1           ) ]
let s:p.insert.middle = [ s:cell(s:fg,     s:bg1           ) ]
let s:p.insert.error  = s:p.normal.error
let s:p.insert.warning= s:p.normal.warning

" --- VISUAL (niagara badge) ---
let s:p.visual.left   = [ s:cell(s:bg,     s:niagara, 'bold'),
                        \  s:cell(s:quartz, s:bg2           ) ]
let s:p.visual.right  = [ s:cell(s:bg,     s:niagara, 'bold'),
                        \  s:cell(s:quartz, s:bg2           ),
                        \  s:cell(s:fg,     s:bg1           ) ]
let s:p.visual.middle = [ s:cell(s:fg,     s:bg1           ) ]
let s:p.visual.error  = s:p.normal.error
let s:p.visual.warning= s:p.normal.warning

" --- REPLACE (red badge) ---
let s:p.replace.left  = [ s:cell(s:white,  s:red,     'bold'),
                        \  s:cell(s:quartz, s:bg2           ) ]
let s:p.replace.right = [ s:cell(s:white,  s:red,     'bold'),
                        \  s:cell(s:quartz, s:bg2           ),
                        \  s:cell(s:fg,     s:bg1           ) ]
let s:p.replace.middle= [ s:cell(s:fg,     s:bg1           ) ]
let s:p.replace.error  = s:p.normal.error
let s:p.replace.warning= s:p.normal.warning

" --- COMMAND (brown badge) ---
let s:p.command.left  = [ s:cell(s:bg,     s:brown,   'bold'),
                        \  s:cell(s:quartz, s:bg2           ) ]
let s:p.command.right = [ s:cell(s:bg,     s:brown,   'bold'),
                        \  s:cell(s:quartz, s:bg2           ),
                        \  s:cell(s:fg,     s:bg1           ) ]
let s:p.command.middle= [ s:cell(s:fg,     s:bg1           ) ]
let s:p.command.error  = s:p.normal.error
let s:p.command.warning= s:p.normal.warning

" --- TERMINAL (wisteria badge) ---
let s:p.terminal.left  = [ s:cell(s:bg,    s:wisteria,'bold'),
                         \  s:cell(s:quartz,s:bg2          ) ]
let s:p.terminal.right = s:p.command.right
let s:p.terminal.middle= s:p.command.middle
let s:p.terminal.error  = s:p.normal.error
let s:p.terminal.warning= s:p.normal.warning

" --- INACTIVE (muted, no bold) ---
let s:p.inactive.left  = [ s:cell(s:quartz, s:bg1),
                         \  s:cell(s:quartz, s:bg1) ]
let s:p.inactive.right = [ s:cell(s:quartz, s:bg1),
                         \  s:cell(s:quartz, s:bg1) ]
let s:p.inactive.middle= [ s:cell(s:quartz, s:bg ) ]

" --- TABLINE ---
let s:p.tabline.left   = [ s:cell(s:quartz, s:bg1) ]
let s:p.tabline.tabsel = [ s:cell(s:yellow, s:bg,  'bold') ]
let s:p.tabline.middle = [ s:cell(s:quartz, s:bg1) ]
let s:p.tabline.right  = [ s:cell(s:quartz, s:bg1) ]

let g:lightline#colorscheme#gruber_darker#palette = lightline#colorscheme#flatten(s:p)
