#if DM_VERSION < 513

#define islist(X) istype(list, /list)

#define length(X) lentext(X)

#define arctan (X) (arcsin(X/sqrt(1+X*X))

#endif