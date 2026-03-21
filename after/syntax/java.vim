" after/syntax/java.vim
" Java syntax overrides for gruber-darker theme
" Ensures proper keyword vs type distinction

" ============================================================
" KEYWORDS → YELLOW (control flow, modifiers, etc.)
" ============================================================

" Clear default Java syntax groups that lump everything together
syn clear javaStorageClass
syn clear javaClassDecl
syn clear javaMethodDecl
syn clear javaType

" Control flow keywords → YELLOW
syn keyword javaKeyword if else switch case default
syn keyword javaKeyword for while do break continue return
syn keyword javaKeyword try catch finally throw throws
syn keyword javaKeyword synchronized volatile transient native strictfp

" Modifiers → YELLOW
syn keyword javaModifier public private protected
syn keyword javaModifier static final abstract
syn keyword javaModifier const

" OOP keywords → YELLOW
syn keyword javaOOP class interface enum extends implements
syn keyword javaOOP new this super instanceof
syn keyword javaOOP import package

" Special keywords → YELLOW
" Note: void is a keyword in Java (not a type like in C)
syn keyword javaKeyword assert void var

" ============================================================
" TYPES → GRAY (primitive types, type names)
" ============================================================

" Primitive types → GRAY (quartz via Type)
syn keyword javaPrimitiveType boolean byte char short int long float double

" Boxed types → GRAY
syn keyword javaBoxedType Boolean Byte Character Short Integer Long Float Double
syn keyword javaBoxedType String Object Class

" Common Java types → GRAY
syn keyword javaCommonType List ArrayList LinkedList
syn keyword javaCommonType Map HashMap TreeMap LinkedHashMap
syn keyword javaCommonType Set HashSet TreeSet LinkedHashSet
syn keyword javaCommonType Queue Deque Stack Vector
syn keyword javaCommonType Thread Runnable Callable Future
syn keyword javaCommonType Exception RuntimeException Error Throwable

" ============================================================
" LITERALS → GRAY (booleans and null are constants, not numbers)
" ============================================================

" true / false / null → Constant (quartz, gray)
" Use Boolean instead if you want WHITE (Boolean links to Number in this theme)
syn keyword javaBooleanLiteral true false null

" ============================================================
" APPLY COLORS
" ============================================================

hi! link javaKeyword      Keyword     " YELLOW
hi! link javaModifier     Keyword     " YELLOW
hi! link javaOOP          Keyword     " YELLOW

hi! link javaPrimitiveType Type       " GRAY (quartz)
hi! link javaBoxedType     Type       " GRAY (quartz)
hi! link javaCommonType    Type       " GRAY (quartz)

hi! link javaBooleanLiteral Constant  " GRAY (quartz via Constant)

" Ensure numbers are white
hi! link javaNumber       Number      " WHITE

" ============================================================
" ANNOTATIONS → SPECIAL (preprocessor-like)
" ============================================================

" Annotations like @Override, @Deprecated
syn match javaAnnotation "@\w\+"
hi! link javaAnnotation   PreProc     " GRAY (quartz)

" ============================================================
" GENERIC TYPE PARAMETERS → GRAY
" ============================================================

" Type parameters in generics (T, E, K, V, etc.)
syn match javaTypeParam "<\s*\w\+\s*>" contains=javaTypeParamName
syn match javaTypeParamName "\w\+" contained
hi! link javaTypeParamName Type       " GRAY (quartz)
