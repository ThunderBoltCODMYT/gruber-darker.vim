" after/syntax/cs.vim
" C# syntax overrides for gruber-darker theme
" Ensures proper keyword vs type distinction

" ============================================================
" KEYWORDS → YELLOW (control flow, modifiers, etc.)
" ============================================================

" Clear default C# syntax groups
syn clear csStorage
syn clear csClass
syn clear csType

" Control flow keywords → YELLOW
syn keyword csKeyword if else switch case default
syn keyword csKeyword for foreach while do break continue return goto
syn keyword csKeyword try catch finally throw
syn keyword csKeyword lock checked unchecked unsafe fixed

" Modifiers → YELLOW
syn keyword csModifier public private protected internal
syn keyword csModifier static readonly const volatile
syn keyword csModifier virtual override abstract sealed
syn keyword csModifier async await
syn keyword csModifier extern

" OOP keywords → YELLOW
syn keyword csOOP class struct interface enum record
syn keyword csOOP new this base typeof sizeof nameof
syn keyword csOOP is as in out ref params
syn keyword csOOP using namespace

" Special keywords → YELLOW
" Note: void is a keyword in C# (not a type like in C)
" Note: null is NOT here — it lives in csBooleanLiteral below to avoid conflict
syn keyword csKeyword var dynamic void
syn keyword csKeyword get set value add remove
syn keyword csKeyword where select from join let orderby group into

" LINQ keywords → YELLOW
syn keyword csLINQ from where select group into
syn keyword csLINQ join on equals let orderby
syn keyword csLINQ ascending descending by

" ============================================================
" TYPES → GRAY (primitive types, type names)
" ============================================================

" Primitive types → GRAY (quartz via Type)
syn keyword csPrimitiveType bool byte sbyte char
syn keyword csPrimitiveType short ushort int uint
syn keyword csPrimitiveType long ulong float double decimal
syn keyword csPrimitiveType string object

" Common .NET types → GRAY
syn keyword csCommonType String Object Type
syn keyword csCommonType Int32 Int64 Double Single Boolean Char
syn keyword csCommonType List Dictionary HashSet Queue Stack
syn keyword csCommonType Array ArrayList Hashtable
syn keyword csCommonType Task Action Func Predicate
syn keyword csCommonType Exception ArgumentException InvalidOperationException
syn keyword csCommonType IEnumerable IList ICollection IDictionary
syn keyword csCommonType StringBuilder DateTime TimeSpan Guid

" ============================================================
" LITERALS → GRAY (booleans and null are constants, not numbers)
" ============================================================

" true / false / null → Constant (quartz, gray)
" Use Boolean instead if you want WHITE (Boolean links to Number in this theme)
syn keyword csBooleanLiteral true false null

" ============================================================
" APPLY COLORS
" ============================================================

hi! link csKeyword       Keyword     " YELLOW
hi! link csModifier      Keyword     " YELLOW
hi! link csOOP           Keyword     " YELLOW
hi! link csLINQ          Keyword     " YELLOW

hi! link csPrimitiveType Type        " GRAY (quartz)
hi! link csCommonType    Type        " GRAY (quartz)

hi! link csBooleanLiteral Constant   " GRAY (quartz via Constant)

" Ensure numbers are white
hi! link csNumber        Number      " WHITE

" ============================================================
" ATTRIBUTES → SPECIAL (like Java annotations)
" ============================================================

" Attributes like [Serializable], [Obsolete]
syn match csAttribute "\[\_.\{-}\]" contains=csAttributeName
syn match csAttributeName "\w\+" contained
hi! link csAttribute     PreProc     " GRAY (quartz)
hi! link csAttributeName PreProc     " GRAY (quartz)

" ============================================================
" GENERICS → GRAY
" ============================================================

" Generic type parameters (T, TKey, TValue, etc.)
syn match csGenericType "<\s*\w\+\s*>" contains=csGenericTypeName
syn match csGenericTypeName "\w\+" contained
hi! link csGenericTypeName Type      " GRAY (quartz)

" ============================================================
" PREPROCESSOR → SPECIAL
" ============================================================

" C# preprocessor directives (#if, #define, #region, etc.)
syn match csPreprocessor "^\s*#\s*\(if\|else\|elif\|endif\|define\|undef\|region\|endregion\|pragma\|warning\|error\|line\)"
hi! link csPreprocessor  PreProc     " GRAY (quartz)

" ============================================================
" STRING INTERPOLATION → Keep strings green
" ============================================================

hi! link csInterpolatedString String  " GREEN
