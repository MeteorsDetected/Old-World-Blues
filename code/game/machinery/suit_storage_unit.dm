//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////

/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = 1
	density = 1
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/initialize()
	. = ..()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)

/obj/machinery/suit_storage_unit/update_icon()
	var/hashelmet = 0
	var/hassuit = 0
	var/hashuman = 0
	if(HELMET)
		hashelmet = 1
	if(SUIT)
		hassuit = 1
	if(OCCUPANT)
		hashuman = 1
	icon_state = text("suitstorage[][][][][][][][][]", hashelmet, hassuit, hashuman, isopen, islocked, isUV, ispowered, isbroken, issuperUV)

/obj/machinery/suit_storage_unit/power_change()
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			islocked = 0
			isopen = 1
			dump_everything()
			update_icon()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)
			return
		else
			return
	return

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(panelopen) //The maintenance panel is open. Time for some shady stuff
		dat+= "<HEAD><TITLE>Suit storage unit: Maintenance panel</TITLE></HEAD>"
		dat+= "<Font color ='black'><B>Maintenance panel controls</B></font><HR>"
		dat+= "<font color ='grey'>The panel is ridden with controls, button and meters, labeled in strange signs and symbols that <BR>you cannot understand. Probably the manufactoring world's language.<BR> Among other things, a few controls catch your eye.</font><BR><BR>"
		dat+= text("<font color ='black'>A small dial with a small lambda symbol on it. It's pointing towards a gauge that reads []</font>.<BR> <font color='blue'><A href='?src=\ref[];toggleUV=1'> Turn towards []</A></font><BR>",(issuperUV ? "15nm" : "185nm"),src,(issuperUV ? "185nm" : "15nm"))
		dat+= text("<font color ='black'>A thick old-style button, with 2 grimy LED lights next to it. The [] LED is on.</font><BR><font color ='blue'><A href='?src=\ref[];togglesafeties=1'>Press button</a></font>",(safetieson? "<font color='green'><B>GREEN</B></font>" : "<font color='red'><B>RED</B></font>"),src)
		dat+= text("<HR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close panel</A>", user)
		//user << browse(dat, "window=ssu_m_panel;size=400x500")
		//onclose(user, "ssu_m_panel")
	else if(isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat+= "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"
		//dat+= "<font colr='black'><B>Cycle end in: [cycletimeleft()] seconds. </font></B>"
		//user << browse(dat, "window=ssu_cycling_panel;size=400x500")
		//onclose(user, "ssu_cycling_panel")

	else
		if(!isbroken)
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='blue'><font size = 4><B>U-Stor-It Suit Storage Unit, model DS1900</B></FONT><BR>"
			dat+= "<B>Welcome to the Unit control panel.</B></FONT><HR>"
			dat+= text("<font color='black'>Helmet storage compartment: <B>[]</B></font><BR>",(HELMET ? HELMET.name : "</font><font color ='grey'>No helmet detected."))
			if(HELMET && isopen)
				dat+="<A href='?src=\ref[src];dispense_helmet=1'>Dispense helmet</A><BR>"
			dat+= text("<font color='black'>Suit storage compartment: <B>[]</B></font><BR>",(SUIT ? SUIT.name : "</font><font color ='grey'>No exosuit detected."))
			if(SUIT && isopen)
				dat+="<A href='?src=\ref[src];dispense_suit=1'>Dispense suit</A><BR>"
			dat+= text("<font color='black'>Breathmask storage compartment: <B>[]</B></font><BR>",(MASK ? MASK.name : "</font><font color ='grey'>No breathmask detected."))
			if(MASK && isopen)
				dat+="<A href='?src=\ref[src];dispense_mask=1'>Dispense mask</A><BR>"
			if(OCCUPANT)
				dat+= "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
				dat+= "<A href='?src=\ref[src];eject_guy=1'>Eject extra load</A>"
			dat+= text("<HR><font color='black'>Unit is: [] - <A href='?src=\ref[];toggle_open=1'>[] Unit</A></font> ",(isopen ? "Open" : "Closed"),src,(isopen ? "Close" : "Open"))
			if(isopen)
				dat+="<HR>"
			else
				dat+= text(" - <A href='?src=\ref[];toggle_lock=1'><font color ='orange'>*[] Unit*</A></font><HR>",src,(islocked ? "Unlock" : "Lock"))
			dat+= text("Unit status: []",(islocked? "<font color ='red'><B>**LOCKED**</B></font><BR>" : "<font color ='green'><B>**UNLOCKED**</B></font><BR>"))
			dat+= text("<A href='?src=\ref[];start_UV=1'>Start Disinfection cycle</A><BR>",src)
			dat += text("<BR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close control panel</A>", user)
			//user << browse(dat, "window=Suit Storage Unit;size=400x500")
			//onclose(user, "Suit Storage Unit")
		else //Ohhhh shit it's dirty or broken! Let's inform the guy.
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='maroon'><B>Unit chamber is too contaminated to continue usage. Please call for a qualified individual to perform maintenance.</font></B><BR><BR>"
			dat+= "<HR><A href='?src=\ref[user];mach_close=suit_storage_unit'>Close control panel</A>"
			//user << browse(dat, "window=suit_storage_unit;size=400x500")
			//onclose(user, "suit_storage_unit")

	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")
	return


/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if((get_dist(src, usr)<=1) || isAI(usr))
		usr.set_machine(src)
		if(href_list["toggleUV"])
			toggleUV(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["togglesafeties"])
			togglesafeties(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["dispense_helmet"])
			dispense_helmet(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["dispense_suit"])
			dispense_suit(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["dispense_mask"])
			dispense_mask(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["toggle_open"])
			toggle_open(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["toggle_lock"])
			toggle_lock(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["start_UV"])
			start_UV(usr)
			updateUsrDialog()
			update_icon()
		if(href_list["eject_guy"])
			eject_occupant(usr)
			updateUsrDialog()
			update_icon()
	/*if(href_list["refresh"])
		updateUsrDialog()*/
	add_fingerprint(usr)
	return


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else  //welp, the guy is protected, we can continue
		if(issuperUV)
			user << "You slide the dial back towards \"185nm\"."
			issuperUV = 0
		else
			user << "You crank the dial all the way up to \"15nm\"."
			issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else
		user << "You push the button. The coloured LED next to it changes."
		safetieson = !safetieson


/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(!HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		HELMET.forceMove(src.loc)
		HELMET = null


/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(!SUIT)
		return
	else
		SUIT.forceMove(src.loc)
		SUIT = null


/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(!MASK)
		return
	else
		MASK.forceMove(src.loc)
		MASK = null


/obj/machinery/suit_storage_unit/proc/dump_everything()
	islocked = 0 //locks go free
	if(SUIT)
		SUIT.forceMove(src.loc)
		SUIT = null
	if(HELMET)
		HELMET.forceMove(src.loc)
		HELMET = null
	if(MASK)
		MASK.forceMove(src.loc)
		MASK = null
	if(OCCUPANT)
		eject_occupant(OCCUPANT)
	return


/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(islocked || isUV)
		user << "<font color='red'>Unable to open unit.</font>"
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(OCCUPANT && safetieson)
		user << "<font color='red'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</font>"
		return
	if(isopen)
		return
	islocked = !islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safetieson)
		user << "<font color='red'><B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</font>"
		return
	if(!HELMET && !MASK && !SUIT && !OCCUPANT) //shit's empty yo
		user << "<font color='red'>Unit storage bays empty. Nothing to disinfect -- Aborting.</font>"
		return
	user << "You start the Unit's cauterisation cycle."
	cycletime_left = 20
	isUV = 1
	if(OCCUPANT && !islocked)
		islocked = 1 //Let's lock it for good measure
	update_icon()
	updateUsrDialog()

	for(var/i=0,i<4,i++)
		sleep(50)
		if(src.OCCUPANT)
			OCCUPANT.radiation += 50
			var/obj/item/organ/internal/nutrients/rad_organ = locate() in OCCUPANT.internal_organs
			if (!rad_organ)
				if(src.issuperUV)
					var/burndamage = rand(28,35)
					OCCUPANT.take_organ_damage(0,burndamage)
					if (!(OCCUPANT.species && (OCCUPANT.species.flags & NO_PAIN)))
						OCCUPANT.emote("scream")
				else
					var/burndamage = rand(6,10)
					OCCUPANT.take_organ_damage(0,burndamage)
					if (!(OCCUPANT.species && (OCCUPANT.species.flags & NO_PAIN)))
						OCCUPANT.emote("scream")
		if(i==3) //End of the cycle
			if(!issuperUV)
				if(HELMET)
					HELMET.clean_blood()
				if(SUIT)
					SUIT.clean_blood()
				if(MASK)
					MASK.clean_blood()
			else //It was supercycling, destroy everything
				if(HELMET)
					HELMET = null
				if(SUIT)
					SUIT = null
				if(MASK)
					MASK = null
				visible_message("<font color='red'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</font>", 3)
				isbroken = 1
				isopen = 1
				islocked = 0
				eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
			isUV = 0 //Cycle ends
	update_icon()
	updateUsrDialog()


/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(!OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.forceMove(src.loc)

	if(OCCUPANT.client)
		if(user != OCCUPANT)
			OCCUPANT << "<font color='blue'>The machine kicks you out!</font>"
		if(user.loc != src.loc)
			OCCUPANT << "<font color='blue'>You leave the not-so-cozy confines of the SSU.</font>"

	OCCUPANT.forceMove(src.loc)
	OCCUPANT.reset_view()

	OCCUPANT = null
	if(!isopen)
		isopen = 1
	update_icon()

/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr == OCCUPANT)
		if(usr.incapacitated(INCAPACITATION_DISABLED))
			return
	else
		if(usr.incapacitated())
			return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated(INCAPACITATION_MOVE))
		return
	if(!isopen)
		usr << "<font color='red'>The unit's doors are shut.</font>"
		return
	if(!ispowered || isbroken)
		usr << "<font color='red'>The unit is not operational.</font>"
		return
	if((OCCUPANT) || (HELMET) || (SUIT))
		usr << "<font color='red'>It's too cluttered inside for you to fit in!</font>"
		return
	visible_message("[usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10))
		usr.stop_pulling()
		usr.forceMove(src)
		usr.reset_view(src)
		OCCUPANT = usr
		isopen = 0 //Close the thing after the guy gets inside
		update_icon()

		add_fingerprint(usr)
		updateUsrDialog()
	else
		OCCUPANT = null //Testing this as a backup sanity test

/obj/machinery/suit_storage_unit/affect_grab(var/mob/user, var/mob/target)
	if(!isopen)
		user << SPAN_WARN("The unit's doors are shut.")
		return
	if(!ispowered || isbroken)
		user << SPAN_WARN("The unit is not operational.")
		return
	if(OCCUPANT || HELMET || SUIT) //Unit needs to be absolutely empty
		user << SPAN_WARN("The unit's storage area is too cluttered.")
		return
	visible_message("[user] starts putting [target] into the Suit Storage Unit.")
	if(do_after(user, 20, src) && Adjacent(target))
		target.forceMove(src)
		target.reset_view(src)
		OCCUPANT = target
		isopen = 0 //close ittt

		add_fingerprint(user)
		updateUsrDialog()
		update_icon()
		return TRUE

/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!ispowered)
		return
	if(istype(I, /obj/item/weapon/screwdriver))
		panelopen = !panelopen
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user << text("<font color='blue'>You [] the unit's maintenance panel.</font>",(panelopen ? "open up" : "close"))
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/suit/space))
		if(!isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(SUIT)
			user << "<font color='blue'>The unit already contains a suit.</font>"
			return
		user << "You load the [S.name] into the storage compartment."
		user.drop_from_inventory(S, src)
		SUIT = S
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/head/helmet))
		if(!isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(HELMET)
			user << "<font color='blue'>The unit already contains a helmet.</font>"
			return
		user << "You load the [H.name] into the storage compartment."
		user.drop_from_inventory(H, src)
		HELMET = H
		update_icon()
		updateUsrDialog()
		return
	if(istype(I,/obj/item/clothing/mask))
		if(!isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(MASK)
			user << "<font color='blue'>The unit already contains a mask.</font>"
			return
		user << "You load the [M.name] into the storage compartment."
		user.drop_from_inventory(M, src)
		MASK = M
		update_icon()
		updateUsrDialog()
		return
	update_icon()
	updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return attack_hand(user)

//////////////////////////////REMINDER: Make it lock once you place some fucker inside.

//God this entire file is fucking awful
//Suit painter for Bay's special snowflake aliums.

/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100"

	req_access = list(access_captain,access_heads)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair          // If set, the cycler can repair voidsuits.
	var/electrified = 0

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering","Mining","Medical","Security","Atmos")
	var/list/departments_datas = list(
		"Engineering" = list(
			/obj/item/clothing/head/helmet/space/void/engineering,
			/obj/item/clothing/suit/space/void/engineering
		),
		"Mining" = list(
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/item/clothing/suit/space/void/mining
		),
		"Medical" = list(
			/obj/item/clothing/head/helmet/space/void/medical,
			/obj/item/clothing/suit/space/void/medical
		),
		"Security" = list(
			/obj/item/clothing/head/helmet/space/void/security,
			/obj/item/clothing/suit/space/void/security
		),
		"Atmos" = list(
			/obj/item/clothing/head/helmet/space/void/atmos,
			/obj/item/clothing/suit/space/void/atmos
		),
		"Mercenary" = list(
			/obj/item/clothing/head/helmet/space/void/merc,
			/obj/item/clothing/suit/space/void/merc
		),
		"^%###^%$" = list(
			/obj/item/clothing/head/helmet/space/void/merc,
			/obj/item/clothing/suit/space/void/merc
		)
	)
	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA)

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	var/datum/wires/suit_storage_unit/wires = null

/obj/machinery/suit_cycler/initialize()
	. = ..()
	wires = new(src)
	target_department = departments[1]
	target_species = species[1]
	if(!target_department || !target_species)
		qdel(src)

/obj/machinery/suit_cycler/Destroy()
	qdel(wires)
	wires = null
	. = ..()

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering","Atmos")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI) //Add Unathi when sprites exist for their suits.

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_VOX)

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_VOX)
	can_repair = 1

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/affect_grab(var/mob/user, var/mob/target)
	if(locked)
		user << SPAN_DANGER("The suit cycler is locked.")
		return

	if(contents.len)
		user << SPAN_DANGER("There is no room inside the cycler for [target].")
		return

	visible_message(SPAN_NOTE("[user] starts putting [target] into the suit cycler."))

	if(do_after(user, 20) && Adjacent(target))
		target.forceMove(src)
		target.reset_view(src)
		occupant = target

		add_fingerprint(user)
		updateUsrDialog()
		return TRUE


/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/device/multitool) || istype(I, /obj/item/weapon/wirecutters))
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(I,/obj/item/weapon/screwdriver))

		panel_open = !panel_open
		user << "You [panel_open ?  "open" : "close"] the maintenance panel."
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))

		if(locked)
			user << "<span class='danger'>The suit cycler is locked.</span>"
			return

		if(helmet)
			user << "<span class='danger'>The cycler already contains a helmet.</span>"
			return

		user << "You fit \the [I] into the suit cycler."
		user.drop_from_inventory(I, src)
		helmet = I

		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))

		if(locked)
			user << "<span class='danger'>The suit cycler is locked.</span>"
			return

		if(suit)
			user << "<span class='danger'>The cycler already contains a voidsuit.</span>"
			return

		user << "You fit \the [I] into the suit cycler."
		user.drop_from_inventory(I, src)
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		user << "<span class='danger'>The cycler has already been subverted.</span>"
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	user << "<span class='danger'>You run the sequencer across the interface, corrupting the operating protocols.</span>"
	departments = list("Engineering","Mining","Medical","Security","Atmos","HAZMAT","Construction","Biohazard","Crowd Control","Emergency Medical Response","^%###^%$")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

	emagged = 1
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user as mob)

	add_fingerprint(user)

	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(electrified != 0)
		if(shock(user, 100))
			return

	usr.set_machine(src)

	var/dat = "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(allowed(usr))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_department]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	if(panel_open)
		dat += wires()

	user << browse(dat, "window=suit_cycler")
	onclose(user, "suit_cycler")
	return

/obj/machinery/suit_cycler/proc/wires()
	return wires.GetInteractWindow()

/obj/machinery/suit_cycler/Topic(href, href_list)
	if(href_list["eject_suit"])
		if(!suit) return
		suit.forceMove(get_turf(src))
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet) return
		helmet.forceMove(get_turf(src))
		helmet = null
	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.","Suit cycler",null) as null|anything in departments
		if(choice) target_department = choice
	else if(href_list["select_species"])
		var/choice = input("Please select the target species configuration.","Suit cycler",null) as null|anything in species
		if(choice) target_species = choice
	else if(href_list["select_rad_level"])
		var/choices = list(1,2,3)
		if(emagged)
			choices = list(1,2,3,4,5)
		radiation_level = input("Please select the desired radiation level.","Suit cycler",null) as null|anything in choices
	else if(href_list["repair_suit"])

		if(!suit || !can_repair) return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			usr << "You [locked ? "" : "un"]lock \the [src]."
		else
			usr << "<span class='danger'>Access denied.</span>"

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			usr << "<span class='danger'>The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle.</span>"
			return

		active = 1
		irradiating = 10
		updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	updateUsrDialog()
	return

/obj/machinery/suit_cycler/process()

	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level*2))
			occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.radiation += radiation_level*10

/obj/machinery/suit_cycler/proc/finished_job()
	state("The [src] pings loudly.")
	icon_state = initial(icon_state)
	active = 0
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

	return

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if(usr == occupant)
		if(usr.incapacitated(INCAPACITATION_DISABLED))
			return
	else
		if(usr.incapacitated())
			return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user as mob)

	if(locked || active)
		user << "<span class='warning'>The cycler is locked.</span>"
		return

	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant = null

	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()

	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet) helmet.refit_for_species(target_species)
		if(suit) suit.refit_for_species(target_species)
	var/list/data = departments_datas[target_department]
	var/obj/item/clothing/head/helmet/space/void/helmet_type = data[1]
	var/obj/item/clothing/suit/space/void/suit_type = data[2]
	if(helmet)
		helmet.name = "refitted [initial(helmet_type.name)]"
		helmet.icon_state = initial(helmet_type.icon_state)
		helmet.item_state = initial(helmet_type.item_state)
	if(suit)
		suit.name = "refitted [initial(suit_type.name)]"
		suit.icon_state = initial(suit_type.icon_state)
		suit.item_state = initial(suit_type.item_state)
