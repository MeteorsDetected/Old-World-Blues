/datum/antagonist/proc/get_panel_entry(var/datum/mind/player)

	var/dat = "<tr><td><b>[role_text]:</b>"
	var/extra = get_extra_panel_options(player)
	if(is_antagonist(player))
		dat += "<a href='?src=\ref[player];remove_antagonist=[id]'>\[-\]</a>"
		dat += "<a href='?src=\ref[player];equip_antagonist=[id]'>\[Equip\]</a>"
		if(starting_locations && starting_locations.len)
			dat += "<a href='?src=\ref[player];move_antag_to_spawn=[id]'>\[Move to spawn\]</a>"
		if(extra) dat += "[extra]"
	else
		dat += "<a href='?src=\ref[player];add_antagonist=[id]'>\[+\]</a>"
		dat += "<a href='?src=\ref[player];equip_antagonist=[id]'>\[Equip\]</a>"
	dat += "</td></tr>"

	return dat

/datum/antagonist/proc/get_extra_panel_options()
	return

/datum/antagonist/proc/get_check_antag_output(var/datum/admins/caller)

	if(!current_antagonists || !current_antagonists.len)
		return ""

	var/dat = "<br><table cellspacing=5><tr><td><B>[role_text_plural]</B></td><td></td></tr>"
	for(var/datum/mind/player in current_antagonists)
		var/mob/M = player.current
		dat += "<tr>"
		if(M)
			dat += "<td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>"
			if(!M.client)      dat += " <i>(logged out)</i>"
			if(M.stat == DEAD) dat += " <b><font color=red>(DEAD)</font></b>"
			dat += "</td>"
			dat += "<td>\[<A href='?src=\ref[caller];priv_msg=[M.ckey]'>PM</A>\]\[<A href='?src=\ref[caller];traitor=\ref[M]'>TP</A>\]</td>"
		else
			dat += "<td><i>Mob not found!</i></td>"
		dat += "</tr>"
	dat += "</table>"

	if(flags & ANTAG_HAS_NUKE)
		dat += "<br><table><tr><td><B>Nuclear disk(s)</B></td></tr>"
		for(var/obj/item/weapon/disk/nuclear/N in world)
			dat += "<tr><td>[N.name], "
			var/atom/disk_loc = N.loc
			while(!istype(disk_loc, /turf))
				if(ismob(disk_loc))
					var/mob/M = disk_loc
					dat += "carried by <a href='?src=\ref[caller];adminplayeropts=\ref[M]'>[M.real_name]</a> "
				if(isobj(disk_loc))
					var/obj/O = disk_loc
					dat += "in \a [O.name] "
				disk_loc = disk_loc.loc
			dat += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td></tr>"
		dat += "</table>"
	dat += get_additional_check_antag_output(caller)
	dat += "<hr>"
	return dat

//Overridden elsewhere.
/datum/antagonist/proc/get_additional_check_antag_output(var/datum/admins/caller)
	return ""
