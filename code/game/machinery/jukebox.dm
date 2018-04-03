/obj/machinery/media/jukebox/
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/playing = 0

	var/current_track = ""
	var/list/tracks = list(
		"Beyond"			= list('sound/ambience/ambispace.ogg'),
		"Edith Piaf"		= list('sound/jukebox/Edith_Piaf.ogg'),
		"D`Bert"			= list('sound/music/title2.ogg'),
		"D`Fort"			= list('sound/ambience/song_game.ogg'),
		"Floating"			= list('sound/music/main.ogg'),
		"Endless Space"		= list('sound/music/space.ogg'),
		"Part A"			= list('sound/misc/TestLoop1.ogg'),
		"Scratch"			= list('sound/music/title1.ogg'),
		"Space Song"		= list('sound/jukebox/Space_Song.ogg'),
		"Sweet Jane"		= list('sound/jukebox/Sweet_Jane.ogg'),
		"Funnel of Love"	= list('sound/jukebox/FunnelofLove.ogg'),
		"Nowhere to Run"	= list('sound/jukebox/Nowhere_to_Run.ogg'),
		"Sad Song"			= list('sound/jukebox/Look_On_Down_From_The_Bridge.ogg'),
		"Detective Blues"	= list('sound/jukebox/Blade_Runner_Blues.ogg'),
		"Space Oddity"		= list('sound/music/david_bowie-space_oddity_original.ogg'),
		"Lotsa Luck!"		= list('sound/jukebox/Who_Do_You_Love.ogg'),
		"Resist"			= list('sound/jukebox/Old_Friends.ogg'),
		"Turf"				= list('sound/jukebox/Turf.ogg'),
		"Don't You Want?"	= list('sound/jukebox/Somebody_to_Love.ogg'),
		"Heroes"			= list('sound/jukebox/Heroes.ogg'),
		"See You Tomorrow?"	= list('sound/jukebox/See_You_Tomorrow.ogg'),
		"Lovesong"			= list('sound/jukebox/lovesong.ogg'),
		"Crystals"			= list('sound/jukebox/Crystals.ogg'),
		"Drive"				= list('sound/jukebox/Real_Hero.ogg'),
		"Mystyrious Song"	= list('sound/jukebox/Pumpit.ogg'),
		"Bob"				= list('sound/jukebox/TheTimesTheyArAChangin.ogg')
	)

/obj/machinery/media/jukebox/Destroy()
	StopPlaying()
	..()

/obj/machinery/media/jukebox/power_change()
	if(!powered(power_channel) || !anchored)
		stat |= NOPOWER
	else
		stat &= ~NOPOWER

	if(stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()
	update_icon()

/obj/machinery/media/jukebox/update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			overlays += "[state_base]-emagged"
		else
			overlays += "[state_base]-running"

/obj/machinery/media/jukebox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || issilicon(usr)))
		return

	if(!anchored)
		usr << "<span class='warning'>You must secure \the [src] first.</span>"
		return

	if(stat & (NOPOWER|BROKEN))
		usr << "\The [src] doesn't appear to function."
		return

	if(href_list["change_track"])
		var/T = href_list["title"]
		if(T)
			current_track = T
			StartPlaying()
	else if(href_list["stop"])
		StopPlaying()
	else if(href_list["play"])
		if(emagged)
			playsound(src.loc, 'sound/items/AirHorn.ogg', 100, 1)
			for(var/mob/living/carbon/M in ohearers(6, src))
				if(M.get_ear_protection() >= 2)
					continue
				M.sleeping = 0
				M.stuttering += 20
				M.ear_deaf += 30
				M.Weaken(3)
				if(prob(30))
					M.Stun(10)
					M.Paralyse(4)
				else
					M.make_jittery(500)
			spawn(15)
				explode()
		else if(!current_track)
			usr << "No track selected."
		else
			StartPlaying()

	return 1

/obj/machinery/media/jukebox/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		usr << "\The [src] doesn't appear to function."
		return

	ui_interact(user)

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]

	if(!(stat & (NOPOWER|BROKEN)))
		data["current_track"] = current_track ? current_track : ""
		data["playing"] = playing

		var/list/nano_tracks = list()
		for(var/T in tracks)
			nano_tracks += T

		data["tracks"] = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_message("<span class='danger'>\the [src] blows apart!</span>", 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(W, /obj/item/weapon/wrench))
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", SPAN_NOTE("You [anchored ? "un" : ""]secure \the [src]."))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		power_change()
		update_icon()
		return
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	var/area/main_area = get_area(src)
	// Always kill the current sound
	for(var/mob/living/M in mobs_in_area(main_area))
		M << sound(null, channel = 1)

		main_area.forced_ambience = null
	playing = 0
	update_use_power(1)
	update_icon()


/obj/machinery/media/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	var/area/main_area = get_area(src)
	main_area.forced_ambience = list(pick(tracks[current_track]))
	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

	playing = 1
	update_use_power(2)
	update_icon()
