" after/syntax/cpp.vim
" C++ syntax overrides for gruber-darker theme
" This file loads AFTER Vim's default C++ syntax, ensuring our overrides stick
"
" HYBRID APPROACH: Also defined in main theme with autocmds for double protection

" Clear Vim's default void definition from cppType/cType
syn clear cType
syn clear cppType

" Redefine numeric types (GRAY) - but NOT void
syn keyword cType int float double long short char
syn keyword cType unsigned signed size_t ptrdiff_t
syn keyword cType int8_t int16_t int32_t int64_t
syn keyword cType uint8_t uint16_t uint32_t uint64_t
syn keyword cType intptr_t uintptr_t ssize_t off_t
syn keyword cType wchar_t char16_t char32_t

" C++ specific types
syn keyword cType bool string wstring
syn keyword cType vector map set list deque queue stack
syn keyword cType unique_ptr shared_ptr weak_ptr
syn keyword cType thread mutex lock_guard

" void is a keyword (YELLOW), not a type
syn keyword cVoidKeyword void

" Apply colors - link to existing highlight groups
hi! link cType        Type      " GRAY (int, float, bool, string, etc.)
hi! link cVoidKeyword Keyword   " YELLOW (void only)