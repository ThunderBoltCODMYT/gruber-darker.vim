" after/syntax/c.vim
" C syntax overrides for gruber-darker theme
" This file loads AFTER Vim's default C syntax, ensuring our overrides stick

" Only run for C files
if &filetype !=# 'c'
  finish
endif

" void is a TYPE (GRAY), same as int, float, char, etc.
" Override Vim's default cType definition to redefine exactly which types
" belong here — void included.
syn clear cType
syn keyword cType void int float double long short char bool
syn keyword cType unsigned signed size_t ptrdiff_t
syn keyword cType int8_t int16_t int32_t int64_t
syn keyword cType uint8_t uint16_t uint32_t uint64_t
syn keyword cType intptr_t uintptr_t ssize_t off_t
syn keyword cType wchar_t char16_t char32_t

" Apply colors
hi! link cType        Type      " GRAY (quartz) — all type names including void
