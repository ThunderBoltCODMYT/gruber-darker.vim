" ============================================================
" gruber-darker.vim
" Faithful Vim/Neovim port of gruber-darker-theme.el
" Original Emacs theme by Jason R. Blevins & Alexey Kutepov
" You can find the original theme here: https://github.com/rexim/gruber-darker-theme
"
" LOCATION: colors/gruber-darker.vim
" USAGE:    colorscheme gruber-darker
" ============================================================

hi clear
if exists("syntax_on")
  syntax reset
endif

set background=dark
let g:colors_name = "gruber-darker"

" ============================================================
" WARNING COLLECTOR
" Warnings are accumulated throughout the file and printed
" all at once at the bottom so the user sees them on load.
" ============================================================

let s:warnings = []

" ============================================================
" USER OPTIONS
" ============================================================

let g:gruber_transparent_bg  = get(g:, 'gruber_transparent_bg', 0)
let g:gruber_bold_keywords    = get(g:, 'gruber_bold_keywords',  1)
let g:gruber_italic_comments  = get(g:, 'gruber_italic_comments',1)
let g:gruber_contrast         = get(g:, 'gruber_contrast',       "medium")

" ------------------------------------------------------------
" OPTION VALIDATION
" Every option is checked for type and legal value.
" Bad values are reset to safe defaults so the theme always
" loads fully — but the user is warned.
" ------------------------------------------------------------

" --- g:gruber_contrast ---
" Must be a string and one of the three legal values.
" A number or list would silently make all contrast checks fail.
if type(g:gruber_contrast) != type("")
  call add(s:warnings,
    \ "g:gruber_contrast must be a string — got type "
    \ . type(g:gruber_contrast) . " — reset to 'medium'")
  let g:gruber_contrast = "medium"
elseif g:gruber_contrast !=# "soft"
    \ && g:gruber_contrast !=# "medium"
    \ && g:gruber_contrast !=# "hard"
  call add(s:warnings,
    \ "g:gruber_contrast '" . g:gruber_contrast
    \ . "' is not valid — must be 'soft', 'medium', or 'hard' — reset to 'medium'")
  let g:gruber_contrast = "medium"
endif

" --- g:gruber_transparent_bg ---
" Must be a number (0 or 1).  A non-empty string like "false"
" or "0" is truthy in Vimscript — silently wrong.
if type(g:gruber_transparent_bg) != type(0)
  call add(s:warnings,
    \ "g:gruber_transparent_bg must be 0 or 1 — got type "
    \ . type(g:gruber_transparent_bg) . " — reset to 0")
  let g:gruber_transparent_bg = 0
elseif g:gruber_transparent_bg != 0 && g:gruber_transparent_bg != 1
  call add(s:warnings,
    \ "g:gruber_transparent_bg should be 0 or 1 — got "
    \ . g:gruber_transparent_bg . " (treating as ON)")
endif

" --- g:gruber_bold_keywords ---
if type(g:gruber_bold_keywords) != type(0)
  call add(s:warnings,
    \ "g:gruber_bold_keywords must be 0 or 1 — got type "
    \ . type(g:gruber_bold_keywords) . " — reset to 1")
  let g:gruber_bold_keywords = 1
elseif g:gruber_bold_keywords != 0 && g:gruber_bold_keywords != 1
  call add(s:warnings,
    \ "g:gruber_bold_keywords should be 0 or 1 — got "
    \ . g:gruber_bold_keywords . " (treating as ON)")
endif

" --- g:gruber_italic_comments ---
if type(g:gruber_italic_comments) != type(0)
  call add(s:warnings,
    \ "g:gruber_italic_comments must be 0 or 1 — got type "
    \ . type(g:gruber_italic_comments) . " — reset to 1")
  let g:gruber_italic_comments = 1
elseif g:gruber_italic_comments != 0 && g:gruber_italic_comments != 1
  call add(s:warnings,
    \ "g:gruber_italic_comments should be 0 or 1 — got "
    \ . g:gruber_italic_comments . " (treating as ON)")
endif

let s:bold   = g:gruber_bold_keywords   ? 'bold'   : 'NONE'
let s:italic = g:gruber_italic_comments ? 'italic' : 'NONE'

" ============================================================
" FULL PALETTE — mirrors gruber-darker-theme.el exactly
"
" Format: ['#hexcolor', cterm_number]
" - First element: GUI color (24-bit)
" - Second element: Terminal color (256-color fallback)
" ============================================================

let s:palette = {
  \ 'fg'       : ['#e4e4ef', 253],
  \ 'fg1'      : ['#f4f4ff', 255],
  \ 'fg2'      : ['#f5f5f5', 255],
  \ 'white'    : ['#ffffff', 231],
  \ 'black'    : ['#000000',  16],
  \ 'bg_1'     : ['#101010', 233],
  \ 'bg'       : ['#181818', 234],
  \ 'bg1'      : ['#282828', 235],
  \ 'bg2'      : ['#453d41', 238],
  \ 'bg3'      : ['#484848', 239],
  \ 'bg4'      : ['#52494e', 240],
  \ 'red_1'    : ['#c73c3f', 160],
  \ 'red'      : ['#f43841', 196],
  \ 'red1'     : ['#ff4f58', 203],
  \ 'green'    : ['#73c936',  76],
  \ 'yellow'   : ['#ffdd33', 220],
  \ 'brown'    : ['#cc8c3c', 172],
  \ 'quartz'   : ['#95a99f', 108],
  \ 'niagara2' : ['#303540', 236],
  \ 'niagara1' : ['#565f73',  60],
  \ 'niagara'  : ['#96a6c8', 147],
  \ 'wisteria' : ['#9e95c7',  98],
  \ }

" ------------------------------------------------------------
" USER PALETTE OVERRIDE — validated before applying
" Every entry is checked for:
"   • correct type (must be a dict)
"   • each value is a 2-element list
"   • hex  : '#rrggbb' format or 'NONE'
"   • cterm : integer 0-255 or 'NONE'
"   • unknown keys are flagged (typos, old key names)
" Only entries that pass ALL checks are merged into s:palette.
" ------------------------------------------------------------

if exists("g:gruber_palette")
  if type(g:gruber_palette) != type({})
    " Wrong type entirely — skip the whole thing to avoid crashing extend()
    call add(s:warnings,
      \ "g:gruber_palette must be a dict { 'colorname': ['#hex', cterm] }"
      \ . " — got type " . type(g:gruber_palette) . " — ignored entirely")
  else
    let s:_known = keys(s:palette)
    let s:_valid_overrides = {}

    for [s:_pk, s:_pv] in items(g:gruber_palette)

      " Unknown key — still allow it (user may be adding custom names)
      " but warn so typos are caught
      if index(s:_known, s:_pk) == -1
        call add(s:warnings,
          \ "g:gruber_palette: '" . s:_pk
          \ . "' is not a built-in palette key — accepted, but check for typos")
      endif

      " Value must be a list
      if type(s:_pv) != type([])
        call add(s:warnings,
          \ "g:gruber_palette['" . s:_pk . "'] must be a list ['#hex', cterm]"
          \ . " — got type " . type(s:_pv) . " — skipped")
        continue
      endif

      " List must have exactly 2 elements
      if len(s:_pv) != 2
        call add(s:warnings,
          \ "g:gruber_palette['" . s:_pk . "'] must have exactly 2 elements"
          \ . " — got " . len(s:_pv) . " — skipped")
        continue
      endif

      " Element 0: hex string
      let s:_hex = s:_pv[0]
      if type(s:_hex) != type("")
        call add(s:warnings,
          \ "g:gruber_palette['" . s:_pk . "'][0] hex must be a string"
          \ . " — got type " . type(s:_hex) . " — skipped")
        continue
      endif
      if s:_hex !=# 'NONE' && s:_hex !~# '^#[0-9a-fA-F]\{6\}$'
        call add(s:warnings,
          \ "g:gruber_palette['" . s:_pk . "'][0] hex '" . s:_hex
          \ . "' is not a valid #rrggbb color or 'NONE' — skipped")
        continue
      endif

      " Element 1: cterm — number 0-255 or the string 'NONE'
      let s:_ct = s:_pv[1]
      if type(s:_ct) == type("")
        if s:_ct !=# 'NONE'
          call add(s:warnings,
            \ "g:gruber_palette['" . s:_pk . "'][1] cterm string must be 'NONE'"
            \ . " — got '" . s:_ct . "' — skipped")
          continue
        endif
      elseif type(s:_ct) == type(0)
        if s:_ct < 0 || s:_ct > 255
          call add(s:warnings,
            \ "g:gruber_palette['" . s:_pk . "'][1] cterm " . s:_ct
            \ . " is out of range (0-255) — skipped")
          continue
        endif
      else
        call add(s:warnings,
          \ "g:gruber_palette['" . s:_pk . "'][1] cterm must be a number (0-255)"
          \ . " or 'NONE' — got type " . type(s:_ct) . " — skipped")
        continue
      endif

      " Passed all checks — queue for merge
      let s:_valid_overrides[s:_pk] = s:_pv

    endfor

    " Merge only validated entries — safe to call extend() now
    if !empty(s:_valid_overrides)
      call extend(s:palette, s:_valid_overrides, 'force')
    endif

    unlet s:_known s:_valid_overrides s:_pk s:_pv s:_hex s:_ct
  endif
endif

" ------------------------------------------------------------
" CONTRAST SYSTEM
" (g:gruber_contrast is guaranteed valid by this point)
" ------------------------------------------------------------

if g:gruber_contrast ==# "soft"
  let s:palette.bg  = ['#1c1c1c', 234]
  let s:palette.bg1 = ['#262626', 235]
  let s:palette.bg2 = ['#303030', 236]
elseif g:gruber_contrast ==# "hard"
  let s:palette.bg  = ['#141414', 232]
  let s:palette.bg1 = ['#202020', 234]
  let s:palette.bg2 = ['#2a2a2a', 235]
endif

if g:gruber_transparent_bg
  let s:palette.bg = ['NONE', 'NONE']
endif

" ------------------------------------------------------------
" PRECOMPUTE COLOR STRINGS
"
" Each palette entry is re-validated here as a safety net in
" case future code paths introduce a bad value. Bad entries
" fall back to NONE rather than crashing the loop.
" ------------------------------------------------------------

let s:F = { '': 'guifg=NONE ctermfg=NONE' }
let s:B = { '': 'guibg=NONE ctermbg=NONE' }

for [s:_n, s:_c] in items(s:palette)
  " Guard: value must be a 2-element list — never crash the loop
  if type(s:_c) != type([]) || len(s:_c) < 2
    call add(s:warnings,
      \ "Internal: palette entry '" . s:_n
      \ . "' is malformed — falling back to NONE for this color")
    let s:F[s:_n] = 'guifg=NONE ctermfg=NONE'
    let s:B[s:_n] = 'guibg=NONE ctermbg=NONE'
    continue
  endif
  let s:F[s:_n] = 'guifg=' . s:_c[0] . ' ctermfg=' . s:_c[1]
  let s:B[s:_n] = 'guibg=' . s:_c[0] . ' ctermbg=' . s:_c[1]
endfor
unlet s:_n s:_c

" ------------------------------------------------------------
" HIGHLIGHT HELPER
" ------------------------------------------------------------

function! s:hi(group, fg, bg, attr)
  execute 'hi ' . a:group . ' '
    \ . get(s:F, a:fg, s:F['']) . ' '
    \ . get(s:B, a:bg, s:B['']) . ' '
    \ . (a:attr ==# '' ? 'gui=NONE cterm=NONE'
    \                  : 'gui=' . a:attr . ' cterm=' . a:attr)
endfunction

" ============================================================
" UI
" ============================================================

call s:hi('Normal',       'fg',     'bg',    '')
call s:hi('Cursor',       'black',  'yellow','')
call s:hi('CursorIM',     'black',  'yellow','')
call s:hi('lCursor',      'black',  'yellow','')

call s:hi('CursorLine',   '',       'bg1',   '')
hi link  CursorColumn CursorLine
hi link  ColorColumn  CursorLine

call s:hi('LineNr',       'bg4',    'bg',    '')
call s:hi('CursorLineNr', 'yellow', 'bg',    'bold')

call s:hi('Visual',       '',       'bg3',   '')
hi link  VisualNOS Visual

call s:hi('Search',       'black',  'fg2',   '')
call s:hi('IncSearch',    'black',  'fg2',   'bold')
hi link  CurSearch  IncSearch
call s:hi('Substitute',   'fg1',    'niagara1','')

call s:hi('MatchParen',   '',       'bg4',   'bold')

call s:hi('VertSplit',    'bg2',    'bg1',   '')
hi link  WinSeparator VertSplit

call s:hi('StatusLine',   'white',  'bg1',   'bold')
call s:hi('StatusLineNC', 'quartz', 'bg1',   '')

call s:hi('TabLine',      'bg4',    'bg1',   '')
call s:hi('TabLineSel',   'yellow', '',      'bold')
call s:hi('TabLineFill',  '',       'bg1',   '')

call s:hi('Pmenu',        'fg',     'bg1',   '')
call s:hi('PmenuSel',     'fg',     'bg_1',  '')
call s:hi('PmenuSbar',    '',       'bg2',   '')
call s:hi('PmenuThumb',   '',       'bg_1',  '')

call s:hi('NormalFloat',  'fg',     'bg1',   '')
call s:hi('FloatBorder',  'brown',  'bg1',   '')

call s:hi('Folded',       'quartz', 'bg1',   s:italic)
call s:hi('FoldColumn',   'quartz', 'bg',    '')
call s:hi('SignColumn',   '',       'bg',    '')

call s:hi('WildMenu',     'black',  'yellow','bold')

call s:hi('NonText',      'bg2',    '',      '')
call s:hi('SpecialKey',   'bg3',    '',      '')
call s:hi('Whitespace',   'bg1',    '',      '')
call s:hi('EndOfBuffer',  'bg1',    '',      '')
call s:hi('Fringe',       'bg2',    'bg',    '')

call s:hi('Directory',    'niagara','',      'bold')
call s:hi('Underlined',   'niagara','',      'underline')

call s:hi('Title',        'niagara','',      'bold')
call s:hi('Question',     'green',  '',      '')
call s:hi('MoreMsg',      'green',  '',      '')
call s:hi('ModeMsg',      'yellow', '',      '')
call s:hi('ErrorMsg',     'red1',   'bg',    'bold')
call s:hi('WarningMsg',   'brown',  'bg',    'bold')

call s:hi('DiffAdd',      'green',  '',      '')
call s:hi('DiffDelete',   'red1',   '',      '')
call s:hi('DiffChange',   'yellow', '',      '')
call s:hi('DiffText',     'black',  'yellow','bold')

hi SpellBad   gui=undercurl guisp=#f43841 cterm=underline
hi SpellCap   gui=undercurl guisp=#ffdd33 cterm=underline
hi SpellRare  gui=undercurl guisp=#9e95c7 cterm=underline
hi SpellLocal gui=undercurl guisp=#96a6c8 cterm=underline

call s:hi('TrailingWhitespace','red',  'red', '')
call s:hi('Tooltip',           'white','bg4', '')

" ============================================================
" SYNTAX
" ============================================================

call s:hi('Comment',        'brown',   '', s:italic)
call s:hi('SpecialComment', 'green',   '', s:italic)

call s:hi('String',         'green',   '', '')
hi link  Character String

" NUMBERS — bright white for all numeric literals
call s:hi('Number',         'white',  '', '')
hi link  Boolean cConstant " the path is like this: Boolean(bool values) -> cConstant(highlight group) =>(inherits from) Constant(also a highlight group, defined as gray, thus, bool values are gray);
hi link  Float   Number

call s:hi('Function',       'niagara', '', '')
call s:hi('Identifier',     'fg1',     '', '')

call s:hi('Keyword',        'yellow',  '', s:bold)
hi link  Statement   Keyword
hi link  Conditional Keyword
hi link  Repeat      Keyword
hi link  Exception   Keyword
hi link  Label       Keyword

call s:hi('Special',        'yellow',  '', '')

call s:hi('Type',           'quartz',  '', '')
hi link  StorageClass Type
hi link  Structure    Type
hi link  Typedef      Type

call s:hi('PreProc',        'quartz',  '', '')
hi link  Include PreProc
hi link  Define  PreProc
call s:hi('Macro',          'niagara', '', '')

call s:hi('Constant',       'quartz',  '', '')
call s:hi('Operator',       'fg',      '', '')
call s:hi('Delimiter',      'fg',      '', '')
call s:hi('SpecialChar',    'wisteria','', '')
call s:hi('Debug',          'wisteria','', '')
call s:hi('Todo',           'black',   'yellow','bold')
call s:hi('Error',          'red1',    'bg',    'bold')

" ============================================================
" LSP DIAGNOSTICS
" ============================================================

call s:hi('DiagnosticError',             'red',     '', 'bold')
call s:hi('DiagnosticWarn',             'yellow',  '', 'bold')
call s:hi('DiagnosticInfo',             'niagara', '', '')
call s:hi('DiagnosticHint',             'quartz',  '', '')
call s:hi('DiagnosticUnnecessary',      'niagara1','', s:italic)

call s:hi('DiagnosticVirtualTextError', 'red',     'bg','')
call s:hi('DiagnosticVirtualTextWarn',  'yellow',  'bg','')
call s:hi('DiagnosticVirtualTextInfo',  'niagara', 'bg','')
call s:hi('DiagnosticVirtualTextHint',  'quartz',  'bg','')

hi DiagnosticUnderlineError gui=undercurl guisp=#f43841 cterm=underline
hi DiagnosticUnderlineWarn  gui=undercurl guisp=#ffdd33 cterm=underline
hi DiagnosticUnderlineInfo  gui=undercurl guisp=#96a6c8 cterm=underline
hi DiagnosticUnderlineHint  gui=undercurl guisp=#95a99f cterm=underline

" ============================================================
" TREESITTER (THIS IS NEOVIM/NVIM ONLY, MIGHT GET W18 ERRORS IF YOU LOAD THIS INSIDE OF GVIM) — all hi link, zero execute overhead
" ============================================================

if has('nvim')
    " --- Core Language ---
    hi link @comment                   Comment
    hi link @comment.documentation     SpecialComment
    hi link @string                    String
    hi link @string.documentation      SpecialComment
    hi link @character                 Character
    hi link @number                    Number
    hi link @float                     Float
    hi link @boolean                   Boolean

    " --- Functions & Methods ---
    hi link @function                  Function
    hi link @function.call             Function
    hi link @function.builtin          Special
    hi link @function.macro            Macro
    hi link @method                    Function
    hi link @method.call               Function
    hi link @constructor               Function

    " --- Keywords & Control Flow ---
    hi link @keyword                   Keyword
    hi link @keyword.return            Keyword
    hi link @keyword.function          Function
    hi link @keyword.operator          Operator
    hi link @keyword.import            Include
    hi link @keyword.storage           Keyword
    hi link @keyword.type              Keyword
    hi link @conditional               Conditional
    hi link @repeat                    Repeat
    hi link @exception                 Exception
    hi link @operator                  Operator

    " --- Types & Constants ---
    hi link @type                      Type
    hi link @type.builtin              Type
    hi link @type.definition           Typedef
    hi link @type.qualifier            Keyword
    hi link @constant                  Constant
    hi link @constant.builtin          Special
    hi link @constant.macro            Define
    hi link @variable                  Identifier
    hi link @variable.builtin          Special

    " --- Structure ---
    hi link @field                     Identifier
    hi link @property                  Identifier
    hi link @parameter                 Identifier
    hi link @namespace                 Type
    hi link @include                   Include
    hi link @preproc                   PreProc
    hi link @define                    Define
    hi link @macro                     Macro
    hi link @label                     Label

    " --- Syntax Elements ---
    hi link @punctuation.delimiter     Delimiter
    hi link @punctuation.bracket       Delimiter
    hi link @punctuation.special       SpecialChar
    hi link @tag                       Keyword
    hi link @tag.attribute             Identifier
    hi link @tag.delimiter             Delimiter

    " --- Markup (replacing @text.* - future-proof) ---
    hi link @markup.heading            Title
    hi link @markup.heading.1          Title
    hi link @markup.heading.2          Title
    hi link @markup.heading.3          Title
    hi link @markup.strong             Bold
    hi link @markup.emphasis           Italic
    hi link @markup.strikethrough      Comment
    hi link @markup.underline          Underlined
    hi link @markup.link               Underlined
    hi link @markup.link.url           Underlined
    hi link @markup.raw                String
    hi link @markup.raw.block          String
    hi link @markup.list               Special
    hi link @markup.list.checked       Special
    hi link @markup.list.unchecked     Comment

    " --- Annotations & Attributes ---
    hi link @attribute                 PreProc
    hi link @annotation                PreProc

    " --- LSP Semantic Tokens ---
    hi link @lsp.type.class            Type
    hi link @lsp.type.decorator        Function
    hi link @lsp.type.enum             Type
    hi link @lsp.type.interface        Type
    hi link @lsp.type.struct           Type
    hi link @lsp.type.typeParameter    Type
    hi link @lsp.type.parameter        Identifier
    hi link @lsp.type.variable         Identifier
    hi link @lsp.type.property         Identifier
    hi link @lsp.type.enumMember       Constant
    hi link @lsp.type.function         Function
    hi link @lsp.type.method           Function
    hi link @lsp.type.macro            Macro
    hi link @lsp.type.comment          Comment

    " --- Diagnostics ---
    hi link @error                     Error
    hi link @warning                   WarningMsg
endif

" --------------------------------------------------
" --- Diff ---
hi link @diff.plus                 DiffAdd
hi link @diff.minus                DiffDelete
hi link @diff.delta                DiffChange

" --- C/C++ Keywords → YELLOW (not gray) ---
hi! link cStorageClass   Keyword   " static, extern, register, auto
hi! link cStructure      Keyword   " struct, union, enum
hi! link cTypedef        Keyword   " typedef

augroup GruberDarkerC
  autocmd!
  autocmd FileType c,cpp syn keyword cType void
  autocmd FileType c,cpp hi! link cType Type
augroup END

" --- Ensure all number literals are WHITE ---
hi! link cNumbers        Number
hi! link cNumbersCom     Number
hi! link cOctal          Number
hi! link cOctalZero      Number
hi! link cFloat          Number
hi! link cHex            Number
hi! link cBinary         Number

" --- Java ---
hi! link javaStorageClass    Keyword
hi! link javaStructure       Keyword

augroup GruberDarkerJava
  autocmd!
  " Ensure Java keywords stay yellow after syntax load
  autocmd FileType java syn keyword javaKeyword void var
  autocmd FileType java hi! link javaKeyword Keyword
  autocmd FileType java hi! link javaModifier Keyword
  autocmd FileType java hi! link javaOOP Keyword
augroup END

" --- C# ---
hi! link csStorage           Keyword
hi! link csClass             Keyword
hi! link csNewType           Keyword

augroup GruberDarkerCSharp
  autocmd!
  " Ensure C# keywords stay yellow after syntax load
  autocmd FileType cs syn keyword csKeyword void var
  autocmd FileType cs hi! link csKeyword Keyword
  autocmd FileType cs hi! link csModifier Keyword
  autocmd FileType cs hi! link csOOP Keyword
  autocmd FileType cs hi! link csLINQ Keyword
augroup END

" --- Python ---
hi! link pythonBuiltin       Special

" --- JavaScript/TypeScript ---
hi! link jsStorageClass      Keyword
hi! link typescriptStorageClass Keyword
hi! link typescriptBOM       Special

" --- Rust ---
hi! link rustStorage         Keyword
hi! link rustStructure       Keyword

" ============================================================
" TERMINAL COLORS — mirrors Emacs term-color-* faces exactly
" ============================================================

let s:_p = s:palette
let g:terminal_color_0  = s:_p.bg3[0]
let g:terminal_color_8  = s:_p.bg4[0]
let g:terminal_color_1  = s:_p.red_1[0]
let g:terminal_color_9  = s:_p.red_1[0]
let g:terminal_color_2  = s:_p.green[0]
let g:terminal_color_10 = s:_p.green[0]
let g:terminal_color_3  = s:_p.yellow[0]
let g:terminal_color_11 = s:_p.yellow[0]
let g:terminal_color_4  = s:_p.niagara[0]
let g:terminal_color_12 = s:_p.niagara[0]
let g:terminal_color_5  = s:_p.wisteria[0]
let g:terminal_color_13 = s:_p.wisteria[0]
let g:terminal_color_6  = s:_p.quartz[0]
let g:terminal_color_14 = s:_p.quartz[0]
let g:terminal_color_7  = s:_p.fg[0]
let g:terminal_color_15 = s:_p.white[0]
unlet s:_p

" ============================================================
" USER HIGHLIGHT OVERRIDES
"
" Each entry is validated before execute is called:
"   • g:gruber_custom_highlights must be a dict
"   • each key must be a non-empty string (group name)
"   • each value must be a string (highlight spec)
"   • execute is wrapped in try/catch so a bad spec never
"     crashes the rest of the theme
" The unlet is guarded so an empty dict doesn't throw.
" ============================================================

if exists("g:gruber_custom_highlights")
  if type(g:gruber_custom_highlights) != type({})
    call add(s:warnings,
      \ "g:gruber_custom_highlights must be a dict"
      \ . " { 'GroupName': 'guifg=... guibg=...' }"
      \ . " — got type " . type(g:gruber_custom_highlights) . " — ignored entirely")
  else
    for [s:_g, s:_s] in items(g:gruber_custom_highlights)

      " Key must be a non-empty string
      if type(s:_g) != type("") || s:_g ==# ''
        call add(s:warnings,
          \ "g:gruber_custom_highlights: highlight group name must be a non-empty"
          \ . " string — got '" . string(s:_g) . "' — skipped")
        continue
      endif

      " Value must be a string
      if type(s:_s) != type("")
        call add(s:warnings,
          \ "g:gruber_custom_highlights['" . s:_g . "'] value must be a string"
          \ . " — got type " . type(s:_s) . " — skipped")
        continue
      endif

      " Execute inside try/catch — a malformed spec must never
      " crash the rest of the theme or leave Vim in a broken state
      try
        execute 'hi ' . s:_g . ' ' . s:_s
      catch
        call add(s:warnings,
          \ "g:gruber_custom_highlights['" . s:_g . "']: Vim rejected this"
          \ . " highlight string — " . v:exception)
      endtry

    endfor

    " Only unlet if the loop ran at least once
    if !empty(g:gruber_custom_highlights)
      unlet s:_g s:_s
    endif
  endif
endif

" ============================================================
" COMMANDS
" ============================================================

" Functions are only defined once — reloading the colorscheme
" (e.g. via toggle commands) re-sources this file, and Vim will
" error if it tries to redefine a function currently on the call
" stack. The guard below prevents that entirely.

if !exists('s:functions_loaded')
  let s:functions_loaded = 1

  " :GruberHelp
  function! s:show_help()
    try
      help gruber-darker
    catch
      echo "Gruber-Darker Quick Help"
      echo "========================"
      echo ""
      echo "OPTIONS (set before colorscheme):"
      echo "  let g:gruber_contrast = 'soft'|'medium'|'hard'"
      echo "  let g:gruber_transparent_bg = 0|1"
      echo "  let g:gruber_bold_keywords = 0|1"
      echo "  let g:gruber_italic_comments = 0|1"
      echo ""
      echo "COMMANDS:"
      echo "  :GruberContrast {level}   - Change contrast"
      echo "  :GruberHealth             - System diagnostics"
      echo "  :GruberInfo               - Show current config"
      echo "  :GruberToggleTransparent  - Toggle transparency"
      echo "  :GruberToggleBold         - Toggle bold keywords"
      echo "  :GruberToggleItalic       - Toggle italic comments"
      echo ""
      echo "FULL DOCUMENTATION:"
      echo "  Run :helptags ALL then :help gruber-darker"
      echo ""
      echo "REPO: https://github.com/ThunderBoltCODMYT/gruber-darker.vim"
    endtry
  endfunction

  " :GruberContrast
  function! s:contrast_complete(ArgLead, CmdLine, CursorPos)
    return filter(['soft', 'medium', 'hard'], 'v:val =~ "^" . a:ArgLead')
  endfunction

  function! s:set_contrast(level)
    if a:level !=# "soft" && a:level !=# "medium" && a:level !=# "hard"
      echo "GruberContrast: soft | medium | hard"
      return
    endif
    let g:gruber_contrast = a:level
    colorscheme gruber-darker
  endfunction

  " :GruberHealth
  function! s:health()
    echo "Gruber-Darker Theme Diagnostics"
    echo "--------------------------------"
    echo has("termguicolors")   ? "✓ Truecolor supported"   : "⚠ Truecolor not supported"
    echo &termguicolors         ? "✓ termguicolors enabled"  : "⚠ termguicolors disabled — add 'set termguicolors' to your config"
    if has("nvim")
      echo exists(":TSInstall") ? "✓ Treesitter detected"   : "⚠ Treesitter not detected"
    endif
    echo &t_ZH != ""            ? "✓ Italics supported"      : "⚠ Italics may not render — check your terminal"
    echo "Diagnostics complete"
  endfunction

  " :GruberInfo
  function! s:info()
    echo "┌─ Gruber-Darker ──────────────────────────────┐"
    echo "│ Contrast        : " . g:gruber_contrast
    echo "│ Transparent bg  : " . (g:gruber_transparent_bg  ? "on"  : "off")
    echo "│ Bold keywords   : " . (g:gruber_bold_keywords    ? "on"  : "off")
    echo "│ Italic comments : " . (g:gruber_italic_comments  ? "on"  : "off")
    echo "├─ Palette ────────────────────────────────────┤"
    echo "│ fg        #e4e4ef   bg        #181818"
    echo "│ yellow    #ffdd33   green     #73c936"
    echo "│ niagara   #96a6c8   quartz    #95a99f"
    echo "│ wisteria  #9e95c7   brown     #cc8c3c"
    echo "│ red       #f43841   red-1     #c73c3f"
    echo "└──────────────────────────────────────────────┘"
    echo "Tip: override any color with g:gruber_palette"
  endfunction

  " :GruberToggleTransparent
  function! s:toggle_transparent()
    let g:gruber_transparent_bg = g:gruber_transparent_bg ? 0 : 1
    colorscheme gruber-darker
    echo "Gruber-Darker: transparent bg " . (g:gruber_transparent_bg ? "ON" : "OFF")
  endfunction

  " :GruberToggleBold
  function! s:toggle_bold()
    let g:gruber_bold_keywords = g:gruber_bold_keywords ? 0 : 1
    colorscheme gruber-darker
    echo "Gruber-Darker: bold keywords " . (g:gruber_bold_keywords ? "ON" : "OFF")
  endfunction

  " :GruberToggleItalic
  function! s:toggle_italic()
    let g:gruber_italic_comments = g:gruber_italic_comments ? 0 : 1
    colorscheme gruber-darker
    echo "Gruber-Darker: italic comments " . (g:gruber_italic_comments ? "ON" : "OFF")
  endfunction

endif

" ------------------------------------------------------------
" Command definitions — use ! so reloading never causes errors.
" These are safe to redefine; only function bodies need the guard.
" ------------------------------------------------------------

command!          GruberHelp                                              call s:show_help()
command! -nargs=1 -complete=customlist,s:contrast_complete GruberContrast call s:set_contrast(<f-args>)
command!          GruberHealth                                            call s:health()
command!          GruberInfo                                              call s:info()
command!          GruberToggleTransparent                                 call s:toggle_transparent()
command!          GruberToggleBold                                        call s:toggle_bold()
command!          GruberToggleItalic                                      call s:toggle_italic()

" ============================================================
" STARTUP VALIDATION REPORT
"
" Printed LAST so the theme is fully loaded before the user
" sees any warnings — a partial-looking theme never accompanies
" the messages.
"
" Environment issues (termguicolors) are also checked here
" since they affect how the theme looks, not whether it loads.
" ============================================================

" --- Environment checks ---

" termguicolors supported but not enabled — colors will be
" degraded to 256-color cterm fallbacks silently
if has("termguicolors") && !&termguicolors
  call add(s:warnings,
    \ "termguicolors is supported but not enabled — true 24-bit colors"
    \ . " will NOT render; add 'set termguicolors' to your config")
endif

" Vim version too old to support some highlight attributes
" (undercurl, gui= combos) used in this theme
if !has("nvim") && v:version < 800
  call add(s:warnings,
    \ "Vim " . v:version . " detected — this theme targets Vim 8+ / Neovim;"
    \ . " some highlight groups may not render correctly")
endif

" --- Print all collected warnings ---

if !empty(s:warnings)
  " Use echom so warnings also appear in :messages after dismissal
  echohl WarningMsg
  echom repeat('─', 62)
  echom " Gruber-Darker: " . len(s:warnings) . " warning(s) on load"
  echom repeat('─', 62)
  let s:_i = 1
  for s:_w in s:warnings
    echom " " . s:_i . ". " . s:_w
    let s:_i += 1
  endfor
  echom repeat('─', 62)
  echom " Run :GruberHealth for environment diagnostics."
  echom " Run :GruberInfo   to verify active settings."
  echom repeat('─', 62)
  echohl None
  unlet s:_i s:_w
endif

unlet s:warnings

" Only enable syntax if not already on
if !exists("g:syntax_on")
  syntax enable
endif
