" after/syntax/cpp.vim
" C++ syntax overrides for gruber-darker theme
" This file loads AFTER Vim's default C++ syntax, ensuring our overrides stick

" Clear Vim's default type definitions so we control exactly what's in cType
syn clear cppType

" All types → GRAY (quartz), void included — consistent with c.vim
syn keyword cppType void int float double long short char
syn keyword cppType unsigned signed size_t ptrdiff_t
syn keyword cppType int8_t int16_t int32_t int64_t
syn keyword cppType uint8_t uint16_t uint32_t uint64_t
syn keyword cppType intptr_t uintptr_t ssize_t off_t
syn keyword cppType wchar_t char16_t char32_t

" C++ specific types → GRAY
syn keyword cppType bool string wstring
syn keyword cppType vector map set list deque queue stack
syn keyword cppType unique_ptr shared_ptr weak_ptr
syn keyword cppType thread mutex lock_guard

" Apply colors
hi! link cppType        Type      " GRAY (quartz) — all type names including void
