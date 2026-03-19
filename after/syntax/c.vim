" after/syntax/c.vim
" C/C++ syntax overrides for gruber-darker theme
" This file loads AFTER Vim's default C/C++ syntax, ensuring our overrides stick

" Only run for C files
if &filetype !=# 'c'
  finish
endif

" void is a keyword (YELLOW), not a type
" Override Vim's definition that makes it gray
syn clear cType
syn keyword cType int float double long short char bool
syn keyword cType unsigned signed size_t ptrdiff_t
syn keyword cType int8_t int16_t int32_t int64_t
syn keyword cType uint8_t uint16_t uint32_t uint64_t
syn keyword cType intptr_t uintptr_t ssize_t off_t
syn keyword cType wchar_t char16_t char32_t

" C++ specific types
syn keyword cType bool string vector map set

" void gets its own keyword group (YELLOW)
syn keyword cVoidKeyword void

" Apply colors
hi! link cType        Type      " GRAY (type names: int, float, char, etc.)
hi! link cVoidKeyword Keyword   " YELLOW (void only)