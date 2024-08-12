/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 *		Vortex Manipulator
 */

/*
 * Locator
 */
/obj/item/weapon/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0
	flags = CONDUCT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH(T_MAGNET) = 1)
	matter = list(MATERIAL_STEEL = 400)

/obj/item/weapon/locator/attack_self(mob/user as mob)
	user.set_machine(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
<B>Persistent Signal Locator</B><HR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='?src=\ref[src];refresh=1'>Refresh</A>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/locator/Topic(href, href_list)
	..()
	if (usr.incapacitated())
		return
	var/turf/current_location = get_turf(usr)//What turf is the user on?
	if(!current_location||current_location.z==2)//If turf was not found or they're on z level 2.
		usr << "The [src] is malfunctioning."
		return
	if ((usr.contents.Find(src) || (IN_RANGE(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/obj/item/device/radio/beacon/W in world)
					if (W.frequency == src.frequency)
						var/turf/tr = get_turf(W)
						if (tr.z == sr.z && tr)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extranneous Signals:</B><BR>"
				for (var/obj/item/weapon/implant/tracking/W in world)
					if (!W.implanted || !(istype(W.loc,/obj/item/organ/external) || ismob(W.loc)))
						continue
					else
						var/mob/M = W.loc
						if (M.stat == DEAD)
							if (M.timeofdeath + 6000 < world.time)
								continue

					var/turf/tr = get_turf(W)
					if (tr.z == sr.z && tr)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if (direct < 20)
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if (href_list["temp"])
					src.temp = null
		if(ismob(src.loc))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return


/*
 * Hand-tele
 */
/obj/item/weapon/hand_tele
	name = "hand tele"
	desc = "A portable item using blue-space technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH(T_MAGNET) = 1, TECH(T_BLUESPACE) = 3)
	matter = list(MATERIAL_STEEL = 10000)

/obj/item/weapon/hand_tele/attack_self(mob/user as mob)
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!isPlayerLevel(current_location.z))
		user << SPAN_NOTE("\The [src] is malfunctioning.")
		return
	var/list/L = list()
	for(var/obj/machinery/teleport/hub/R in machines)
		var/obj/machinery/computer/teleporter/com = R.com
		if (istype(com) && com.locked && com.locked.is_active() && !com.one_time_use)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked.target_obj
			else
				L["[com.id] (Inactive)"] = com.locked.target_obj
	var/list/turfs = list()
	for(var/turf/T in RANGE_TURFS(10, current_location))
		if(T.x>world.maxx-8 || T.x<8)
			continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)
			continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") as null|anything in L
	if(t1 == null || user.get_active_hand() != src || user.incapacitated())
		return
	var/count = 0	//num of portals from this teleport in world
	for(var/obj/effect/portal/PO in world)
		if(PO.creator == src)	count++
	if(count >= 3)
		user << SPAN_NOTE("\The [src] is recharging!")
		return
	var/atom/T = L[t1]
	for(var/mob/O in hearers(user, null))
		O.show_message(SPAN_NOTE("Locked In."), 2)
	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	src.add_fingerprint(user)
	return

/*
 * Vortex Manipulator (Hello Missy)
 * TODO:
 * - New Icon
 * - Random Malfunctions - maybe add more effects of spawning sth 'out of bluespace rift'
 * - EMP interactions - more random effects
 */

/obj/item/weapon/vortex_manipulator
	name = "Vortex Manipulator"
	desc = "Strange and complex reverse-engineered technology of some ancient race designed to travel through space and time. Unfortunately, time-shifting is DNA-locked."
	icon = 'icons/obj/device.dmi'
	icon_state = "vm_closed"
	item_state = "electronic"
	var/chargecost_area = 5000
	var/chargecost_beacon = 1000
	var/chargecost_local = 500
	var/cover_open = 0
	var/timelord_mode = 0
	var/unique_id = 0
	// var/master_dna
	var/active = 0
	var/list/possible_ids = list(1, 2, 3)
	var/list/beacon_locations = list()
	var/obj/item/weapon/cell/vcell
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH(T_MATERIAL) = 9, TECH(T_BLUESPACE) = 10, TECH(T_MAGNET) = 8, TECH(T_POWER) = 8, TECH(T_ARCANE) = 4, TECH(T_ILLEGAL) = 5)
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)

/obj/item/weapon/vortex_manipulator/attack_self(mob/user as mob)
	if(cover_open)
		user.set_machine(src)
		var/dat = "<B>Vortex Manipulator Menu:</B><BR>"
		if(vcell)
			dat += "Current charge: [src.vcell.charge] out of [src.vcell.maxcharge]<BR>"
		else
			dat += "The device has no power source!<BR>"
		if(timelord_mode)
			dat += "SAY SOMETHING NICE<BR>"
		dat += "<HR>"
		dat += "<B>Unstable technology: Major Malfunction Possible!</B><BR>"
		if(active && (timelord_mode || vcell))
			dat += "<A href='byond://?src=\ref[src];close_cover=1'>Flip device's protective cover</A><BR>"
			dat += "<B>Teleportation abilities:</B><BR>"
			dat += "<A href='byond://?src=\ref[src];area_teleport=1'>Teleport to Area</A><BR>"
			dat += "<A href='byond://?src=\ref[src];beacon_teleport=1'>Teleport to Beacon</A><BR>"
			dat += "<A href='byond://?src=\ref[src];local_teleport=1'>Space-shift locally</A><BR>"
			dat += "<HR>"
			dat += "<B>Special abilities:</B><BR>"
			dat += "<A href='byond://?src=\ref[src];lmr_ability=1'>Create local space-time anomaly </A> <B>DANGER: COMBAT ABILITY</B><BR>"
			dat += "<A href='byond://?src=\ref[src];ebt_ability=1'>Teleport to random beacon </A><B>WARNING: USE IN EMERGENCY ONLY</B><BR>"
			dat += "<A href='byond://?src=\ref[src];vma_ability=1'>Announce something to all active VM users </A><B>WARNING: EXTREME POWER DRAIN</B><BR>"
		else
			dat += "ALERT: THE DEVICE IS INACTIVE OR HAS NO SOURCE OF POWER"
			if(vcell)
				dat += "<A href='byond://?src=\ref[src];attempt_activate=1'>Activate the Vortex Manipulator</A><BR>"
			else
				dat += "<B>INSTALL POWER CELL! (vortex power cell recommended)</B><BR>"

		dat += "Kind regards,<br>Dominus temporis. <br><br>P.S. Don't forget to ask someone to say something nice.<HR>"
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return
	else
		user << SPAN_NOTE("You flip Vortex Manipulator's protective cover open")
		cover_open = 1

		if(vcell)
			icon_state = "vm_open"
		else
			icon_state = "vm_nocell"

		update_icon()

/obj/item/weapon/vortex_manipulator/attackby(obj/item/weapon/W, mob/user)
	if(cover_open)
		if(istype(W, /obj/item/weapon/cell))
			if(!vcell)
				user.drop_from_inventory(W, src)
				vcell = W
				user << SPAN_NOTE("You install a cell in [src].")
				icon_state = "vm_open"
				update_icon()
			else
				user << SPAN_NOTE("[src] already has a cell.")

		else if(istype(W, /obj/item/weapon/screwdriver))
			if(vcell)
				vcell.update_icon()
				vcell.forceMove(get_turf(src.loc))
				vcell = null
				user << SPAN_NOTE("You remove the cell from the [src].")
				icon_state = "vm_nocell"
				update_icon()
				return
			..()
		return
	else
		user << SPAN_NOTE("Open cover first!")

/obj/item/weapon/vortex_manipulator/Topic(href, href_list)
	if(..())
		return 1
	if (usr.incapacitated() || src.loc != usr)
		return
	if (!ishuman(usr))
		return 1
	var/mob/living/carbon/human/H = usr
	if ((H == src.loc || (IN_RANGE(src, H) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if(!vcell)
			return
		if (href_list["area_teleport"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_area)))
				areateleport(H, 0)
		else if (href_list["beacon_teleport"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_beacon)))
				beaconteleport(H, 0)
		else if (href_list["local_teleport"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_local * 7)))
				localteleport(H, 0)
		else if (href_list["lmr_ability"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_area)))
				localmassiverandom(H)
		else if (href_list["ebt_ability"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_area)))
				beaconteleport(H, 1)
		else if (href_list["vma_ability"])
			if (active && (timelord_mode || (src.vcell.charge >= src.chargecost_area)))
				vortexannounce(H, 1)
		else if (href_list["attempt_activate"])
			self_activate(H)
		else if (href_list["close_cover"])
			cover_open = 0
			icon_state = "vm_closed"
			H << SPAN_NOTE("You flip Vortex Manipulator's protective cover closed")
			update_icon()
			return

	attack_self(H)
	return

/obj/item/weapon/vortex_manipulator/emp_act(var/severity)
	var/vm_owner = get_owner()
	if(!ishuman(vm_owner))
		return
	var/mob/living/carbon/human/H = vm_owner
	if(!vcell || !cover_open)
		return
	if(timelord_mode || (severity == 2))
		if(prob(25))
			if(prob(50))
				H.visible_message(SPAN_NOTE("The Vortex Manipulator suddenly teleports user to specific beacon for its own reasons."))
				beaconteleport(H, 1)
			else
				malfunction()
		else
			if(prob(75))
				H.visible_message(SPAN_NOTE("The Vortex Manipulator is automatically trying to avoid local space-time anomaly."))
				localteleport(H, 1)
			else
				malfunction()
	else
		if(prob(50))
			if(prob(50))
				H.visible_message(SPAN_WARN("The Vortex Manipulator violently shakes and extracts Space Carps from local bluespace anomaly!"))
				playsound(get_turf(src), 'sound/effects/phasein.ogg', 50, 1)
				new /mob/living/simple_animal/hostile/carp(get_turf(src))
				H.visible_message(SPAN_NOTE("The Vortex Manipulator automatically initiates emergency area teleportation procedure."))
				areateleport(H, 1)
			else
				malfunction()
		else
			if(prob(50))
				H.visible_message(SPAN_WARN("The Vortex Manipulator violently shakes and extracts Space Carps from local bluespace anomaly!"))
				playsound(get_turf(src), 'sound/effects/phasein.ogg', 50, 1)
				new /mob/living/simple_animal/hostile/carp(get_turf(src))
				var/temp_turf = get_turf(H)
				H.visible_message(SPAN_NOTE("The Vortex Manipulator suddenly teleports user to specific beacon for its own reasons."))
				beaconteleport(H, 1)
				for(var/mob/M in range(rand(2, 7), temp_turf))
					localteleport(M, 1)
			else
				malfunction()

/obj/item/weapon/vortex_manipulator/proc/self_activate(var/mob/living/carbon/human/user)
	if(!active)
		user << SPAN_NOTE("You attempt to activate Vortex Manipulator")
		if(timelord_mode)
			unique_id = rand(1000, 9999)
			active = 1
			log_game("[user] has activated Vortex Manipulator [unique_id]!")
			user << SPAN_NOTE("You successfully activate Vortex Manipulator. Its unique identifier is now: [unique_id]")
			return
		for(var/i in possible_ids)
			var/check_id = 1
			for(var/obj/item/weapon/vortex_manipulator/VM in world)
				if (VM.unique_id == i)
					// There can only be one.
					check_id = 0
					break
			if(check_id)
				unique_id = i
				active = 1
				log_game("[user] has activated Vortex Manipulator [unique_id]!")
				user << SPAN_NOTE("You successfully activate Vortex Manipulator. Its unique identifier is now: [unique_id]")
				return
		user << SPAN_WARN("You fail to activate your Vortex Manipulator - local space-time can't hold any more active VMs.")
	else
		//currently not used
		user << SPAN_NOTE("You deactivate your Vortex Manipulator and clean all personal settings")
		unique_id = 0
		active = 0
		timelord_mode = 0

// Gets CURRENT HOLDER (or turf, if no mob is holding it) of VM, avoiding runtimes. Returns 0 just in case it's located in sth wrong.
/obj/item/weapon/vortex_manipulator/proc/get_owner()
	var/obj/item/temp_loc = src
	while(!ishuman(temp_loc.loc) && !istype(temp_loc.loc, /turf))
		if(!ismob(temp_loc.loc) && !isobj(temp_loc.loc))
			return 0
		temp_loc = temp_loc.loc
	return temp_loc.loc

// TODO: possible rework; different malfunctions in different situations (multipliers with default settings?)
/obj/item/weapon/vortex_manipulator/proc/malfunction()
	if(timelord_mode)
		return
	var/vm_owner = get_owner()
	if(!ishuman(vm_owner))
		return
	var/mob/living/carbon/human/H = vm_owner
	H.visible_message(SPAN_NOTE("The Vortex Manipulator malfunctions!"))
	var/turf/temp_turf = get_turf(H)
	if(prob(1))
		H.visible_message(SPAN_DANGER("The Vortex Manipulator releases its energy in a large explosion!"))
		explosion(temp_turf, 0, 0, 3, 4)
		areateleport(H, 1)
		explosion(temp_turf, 1, 2, 4, 5)
		for(var/mob/M in range(rand(3, 7), temp_turf))
			areateleport(M, 1)
		return
	else if(prob(5))
		H.visible_message(SPAN_WARN("The Vortex Manipulator violently shakes and extracts Space Carps from local space-time anomaly!"))
		playsound(get_turf(src), 'sound/effects/phasein.ogg', 50, 1)
		var/amount = rand(1,3)
		for(var/i=0;i<amount;i++)
			new /mob/living/simple_animal/hostile/carp(get_turf(src))
		for(var/mob/M in range(rand(3, 7), temp_turf))
			localteleport(M, 1)
		return
	else if(prob(5))
		H.visible_message(SPAN_WARN("The Vortex Manipulator violently shakes and releases some of its hidden energy!"))
		explosion(get_turf(src), 0, 0, 3, 4)
		return
	else if(prob(10))
		H.visible_message(SPAN_NOTE("The Vortex Manipulator automatically initiates emergency area teleportation procedure."))
		areateleport(H, 1)
		for(var/mob/M in range(rand(3, 7), temp_turf))
			beaconteleport(M, 1)
		return
	else if(prob(25))
		H.visible_message(SPAN_NOTE("The Vortex Manipulator suddenly teleports user to specific beacon for its own reasons."))
		beaconteleport(H, 1)
		for(var/mob/M in range(rand(3, 7), temp_turf))
			localteleport(M, 1)
		return
	else if(prob(35))
		H.visible_message(SPAN_NOTE("The Vortex Manipulator is automatically trying to avoid local space-time anomaly."))
		if(prob(50))
			H.visible_message(SPAN_WARN("The Vortex Manipulator fails to avoid local space-time anomaly!"))
			for(var/mob/M in range(rand(3, 7), temp_turf))
				localteleport(M, 1)
			return
		localteleport(H, 1)
	playsound(get_turf(src), "sparks", 50, 1)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(src))
	sparks.start()

// Lowers cellcharge according to power spent. Protected against negative charge values.
/obj/item/weapon/vortex_manipulator/proc/deductcharge(var/chrgdeductamt)
	if(vcell)
		if(vcell.checked_use(chrgdeductamt))
			return 1
		else
			return 0
	return null

// Looks for all beacons located on station levels (station + tcomms for now) and adds them to refreshed (emptied) list of areas to teleport to.
/obj/item/weapon/vortex_manipulator/proc/get_beacon_locations()
	beacon_locations = list()
	for(var/obj/item/device/radio/beacon/R in world)
		var/area/AR = get_area(R)
		if(beacon_locations.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if(isStationLevel(picked.z))
			beacon_locations += AR.name
			beacon_locations[AR.name] = AR
	beacon_locations = sortAssoc(beacon_locations)

// phase_in & phase_out are from ninja's teleport mostly.
/obj/item/weapon/vortex_manipulator/proc/phase_in(var/mob/M,var/turf/T)
	if(!M || !T)
		return
	playsound(T, 'sound/effects/phasein.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)

/obj/item/weapon/vortex_manipulator/proc/phase_out(var/mob/M,var/turf/T)
	if(!M || !T)
		return
	playsound(T, 'sound/effects/phasein.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)
/*
 * Special VM abilities:
 * - Local massive random (COMBAT)
 * - Vortex Announce (COMMS)
 */

/*
 * Local massive random
 * Special combat ability allowing VM to teleport all those surrounding its wearer randomly.
 * User returns to his position after everyone's been teleported.
 */
/obj/item/weapon/vortex_manipulator/proc/localmassiverandom(var/mob/user)
	log_game("[user] has used Vortex Manipulator's Local Massive Random ability.")
	user.visible_message(SPAN_WARN("The Vortex Manipulator announces: Battle function activated. Assembling local space-time anomaly."))
	var/turf/temp_turf = get_turf(user)
	for(var/mob/M in range(5, temp_turf))
		localteleport(M, 1)
	phase_out(user,get_turf(user))
	user.forceMove(temp_turf)
	phase_in(user,get_turf(user))
	deductcharge(chargecost_area)

/*
 * Vortex Announce
 * Allows you to say something nice to all active VM users in world
 * TODO: add CD
 */

/obj/item/weapon/vortex_manipulator/proc/vortexannounce(var/mob/user, var/nonactive_announce = 0)
	var/input = sanitize(input(user, "Enter what you want to announce"))
	for(var/obj/item/weapon/vortex_manipulator/VM in world)
		var/H = VM.get_owner()
		if (ishuman(H) && (VM.active || nonactive_announce))
			H << SPAN_DANGER("Your Vortex Manipulator suddenly announces with voice of [user]: [input]")
	deductcharge(chargecost_beacon)


/*
 * VM basic teleporation types:
 * - Local teleport
 * - Beacon teleport
 * - Area teleport
 */

/*
 * Local teleport.
 * Teleports user with coordinates (x, y) to coordinates (x+a, y+b), allowing him to choose 'a' and 'b' in range [-5, 5].
 * When malfunctioning, picks random 'a' and 'b' values and has chance of next malfunction doubled.
 * Also teleports everyone aggressively grabbed by user.
 */
/obj/item/weapon/vortex_manipulator/proc/localteleport(var/mob/user, var/malf_use)
	if(!active)
		malf_use = 1
	var/list/possible_x = list(-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5)
	var/list/possible_y = list(-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5)
	var/A = pick(possible_x)
	var/B = pick(possible_y)
	if(!malf_use)
		A = input(user, "X-coordinate shift", "JEEROOONIMOOO") in possible_x
		B = input(user, "Y-coordinate shift", "JEEROOONIMOOO") in possible_y
	var/turf/starting = get_turf(user)
	var/new_x = starting.x + A
	var/new_y = starting.y + B
	var/turf/targetturf = locate(new_x, new_y, user.z)
	phase_out(user,get_turf(user))
	user.forceMove(targetturf)
	phase_in(user,get_turf(user))
	deductcharge(chargecost_local * round(sqrt(A * A + B * B)))
	for(var/obj/item/weapon/grab/G in user.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			G.affecting.forceMove(get_turf(user))
			phase_in(G.affecting,get_turf(G.affecting))
	if(prob(25 + (25 * malf_use)))
		malfunction()

/*
 * Beacon teleport.
 * Teleports user to every area with beacon in world on station levels (station + tcomms).
 * If there are two or more beacons in area, target beacon is chosen almost randomly.
 * When malfunctioning, picks random area from list of areas with beacons and has chance of next malfunction doubled.
 * Also teleports everyone aggressively grabbed by user.
 */
/obj/item/weapon/vortex_manipulator/proc/beaconteleport(var/mob/user, var/malf_use)
	if(!active)
		malf_use = 1
	get_beacon_locations()
	var/A = pick(beacon_locations)
	if(!malf_use)
		A = input(user, "Beacon to jump to", "JEEROOONIMOOO") in beacon_locations
	var/area/thearea = beacon_locations[A]
	if (user.incapacitated())
		return
	if(!((user == loc || (IN_RANGE(src, user) && istype(src.loc, /turf)))))
		return
	if(user && user.buckled)
		user.buckled.unbuckle_mob()
	for(var/obj/item/device/radio/beacon/R in world)
		if(get_area(R) == thearea)
			var/turf/T = get_turf(R)
			phase_out(user,get_turf(user))
			user.forceMove(T)
			phase_in(user,get_turf(user))
			deductcharge(chargecost_beacon)
			for(var/obj/item/weapon/grab/G in user.contents)
				if(G.affecting)
					phase_out(G.affecting,get_turf(G.affecting))
					G.affecting.forceMove(locate(user.x+rand(-1,1),user.y+rand(-1,1),T.z))
					phase_in(G.affecting,get_turf(G.affecting))
			break
	if(prob(5 + (5 * malf_use)))
		malfunction()

/*
 * Area teleport.
 * Teleports user to area selected from the same list of areas that wizard's teleportation scroll uses.
 * When malfunctioning, picks random area from this list. Also has chance of next malfunction doubled.
 * Which for now means definite malfunction after teleporation, so with the chance of 50% you will be teleported locally after that.
 * Also teleports everyone aggressively grabbed by user.
 */
/obj/item/weapon/vortex_manipulator/proc/areateleport(var/mob/user, var/malf_use)
	if(!active)
		malf_use = 1
	var/A = pick(teleportlocs)
	if(!malf_use)
		A = input(user, "Area to jump to", "JEEROOONIMOOO") in teleportlocs
	var/area/thearea = teleportlocs[A]
	if (user.incapacitated())
		return
	if(!((user == loc || (IN_RANGE(src, user) && istype(src.loc, /turf)))))
		return
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T
	if(!L.len)
		user <<"The space-time travel matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry."
		return
	if(user && user.buckled)
		user.buckled.unbuckle_mob()
	var/turf/T = pick(L)
	phase_out(user,get_turf(user))
	user.forceMove(T)
	phase_in(user,get_turf(user))
	deductcharge(chargecost_area)
	for(var/obj/item/weapon/grab/G in user.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			G.affecting.forceMove(locate(user.x+rand(-1,1),user.y+rand(-1,1),T.z))
			phase_in(G.affecting,get_turf(G.affecting))
	if(prob(50 + (malf_use * 50)))
		malfunction()
