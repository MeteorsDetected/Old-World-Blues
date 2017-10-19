/mob/proc/on_mob_jump()
	return

/mob/observer/dead/on_mob_jump()
	following = null

ADMIN_VERB_ADD(/client/proc/Jump, R_ADMIN|R_DEBUG)
/client/proc/Jump(var/area/A in return_sorted_areas())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		usr.on_mob_jump()
		usr.loc = pick(get_area_turfs(A))

		log_admin("[key_name(usr)] jumped to [A]", A, 0)
	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/jumptoturf, R_ADMIN)
/*allows us to jump to a specific turf*/
/client/proc/jumptoturf(var/turf/T in view())
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T].", T, 0)
		usr.on_mob_jump()
		usr.loc = T
	else
		alert("Admin jumping disabled")
	return

ADMIN_VERB_ADD(/client/proc/jumptomob, R_ADMIN|R_DEBUG)
/*allows us to jump to a specific mob*/
/client/proc/jumptomob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Jump to Mob"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]", M, 0)
		if(src.mob)
			var/mob/A = src.mob
			var/turf/T = get_turf(M)
			if(T && isturf(T))
				A.on_mob_jump()
				A.loc = T
			else
				A << "This mob is not located in the game world."
	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/jumptocoord, R_ADMIN|R_DEBUG)
/*we ghost and jump to a coordinate*/
/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	jumptoturf(locate(tx,ty,tz))

ADMIN_VERB_ADD(/client/proc/jumptokey, R_ADMIN)
/*allows us to jump to the location of a mob with a certain ckey*/
/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			src << "No keys found."
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]", M, 0)
		usr.on_mob_jump()
		usr.loc = M.loc
	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/Getmob, R_ADMIN)
/*teleports a mob to our location*/
/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] teleported [key_name(M)]", M)
		M.on_mob_jump()
		M.loc = get_turf(usr)
	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/Getkey, R_ADMIN)
/*teleports a mob with a certain ckey to our location*/
/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]", M)
		if(M)
			M.on_mob_jump()
			M.loc = get_turf(usr)
	else
		alert("Admin jumping disabled")