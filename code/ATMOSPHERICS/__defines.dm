#define BUILD_COLORBASED_SUBTYPES(type) 	\
##type/visible{								\
	level = 2								\
}											\
##type/visible/scrubbers{					\
	color = PIPE_COLOR_RED;					\
	connect_types = CONNECT_TYPE_SCRUBBER;	\
	icon_connect_type = "-scrubbers"		\
}											\
##type/visible/supply{						\
	color = PIPE_COLOR_BLUE;				\
	connect_types = CONNECT_TYPE_SUPPLY;	\
	icon_connect_type = "-supply"			\
}											\
##type/visible/yellow{						\
	color = PIPE_COLOR_YELLOW				\
}											\
##type/visible/cyan{						\
	color = PIPE_COLOR_CYAN					\
}											\
##type/visible/green{						\
	color = PIPE_COLOR_GREEN				\
}											\
##type/visible/black{						\
	color = PIPE_COLOR_BLACK				\
}											\
##type/visible/red{							\
	color = PIPE_COLOR_RED					\
}											\
##type/visible/blue{						\
	color = PIPE_COLOR_BLUE					\
}											\
##type/visible/purple{						\
	color = PIPE_COLOR_PURPLE				\
}											\
											\
##type/hidden{								\
	level = 1;								\
	alpha = 128								\
}											\
##type/hidden/scrubbers{					\
	color = PIPE_COLOR_RED;					\
	connect_types = CONNECT_TYPE_SCRUBBER;	\
	icon_connect_type = "-scrubbers"		\
}											\
##type/hidden/supply{						\
	color = PIPE_COLOR_BLUE;				\
	connect_types = CONNECT_TYPE_SUPPLY;	\
	icon_connect_type = "-supply"			\
}											\
##type/hidden/yellow{						\
	color = PIPE_COLOR_YELLOW				\
}											\
##type/hidden/cyan{							\
	color = PIPE_COLOR_CYAN					\
}											\
##type/hidden/green{						\
	color = PIPE_COLOR_GREEN				\
}											\
##type/hidden/black{						\
	color = PIPE_COLOR_BLACK				\
}											\
##type/hidden/red{							\
	color = PIPE_COLOR_RED					\
}											\
##type/hidden/blue{							\
	color = PIPE_COLOR_BLUE					\
}											\
##type/hidden/purple{						\
	color = PIPE_COLOR_PURPLE				\
}

