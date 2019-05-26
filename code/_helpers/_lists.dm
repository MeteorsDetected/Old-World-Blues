/*
 * Misc
 */

#define LAZYINITLIST(L) if (!L) L = list()
#define UNSETEMPTY(L) if (L && !length(L)) L = null
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
#define LAZYFIND(L, V) L ? L.Find(V) : 0
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
#define LAZYLEN(L) length(L)
#define LAZYCLEARLIST(L) if(L) L.Cut()
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
#define reverseList(L) reverseRange(L.Copy())

