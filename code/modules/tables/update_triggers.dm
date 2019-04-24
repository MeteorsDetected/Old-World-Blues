/obj/structure/window/proc/updateTables(var/atom/loc)
	for(var/obj/structure/table/T in view(loc, 1))
		T.update_connections()
		T.update_icon()

/obj/structure/window/initialize(maploaded = FALSE)
	. = ..()
	if(!maploaded)
		updateTables(src)

/obj/structure/window/Destroy()
	var/oldloc = loc
	loc = null
	updateTables(oldloc)
	loc = oldloc
	. = ..()

/obj/structure/window/Move()
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		updateTables(loc)
		updateTables(oldloc)

/obj/structure/window/forceMove()
	var/oldloc = loc
	. = ..()
	if(loc != oldloc)
		updateTables(loc)
		updateTables(oldloc)
