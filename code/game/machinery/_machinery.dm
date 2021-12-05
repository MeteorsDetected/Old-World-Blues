/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   panel_open (num)
      Whether the panel is open

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

Class Procs:
   New()                     'game/machinery/machine.dm'

   Destroy()                     'game/machinery/machine.dm'

   auto_use_power()            'game/machinery/machine.dm'
      This proc determines how power mode power is deducted by the machine.
      'auto_use_power()' is called by the 'master_controller' game_controller every
      tick.

      Return Value:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.
      If it's autocalled then everything is normal, if something else calls use_power we are going to
      need to recalculate the power two ticks in a row.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   InitCircuit()
      Called in New. If circuit is not null, create Parts.

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER

	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP //EQUIP, ENVIRON or LIGHT
	var/list/component_parts = list() //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/obj/item/weapon/circuitboard/circuit = null

/obj/machinery/New(l, d=0)
	..(l)
	if(d)
		set_dir(d)

/obj/machinery/initialize()
	. = ..()
	InitCircuit()
	if(!machinery_sort_required && ticker)
		dd_insertObjectList(machines, src)
	else
		machines += src
		machinery_sort_required = 1

/obj/machinery/Destroy()
	machines -= src
	if(component_parts)
		for(var/atom/A in component_parts)
			qdel(A)
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			qdel(A)
	. = ..()

/obj/machinery/process()//If you dont use process or power why are you here
	if(!(use_power || idle_power_usage || active_power_usage))
		return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && !stat)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = PoolOrNew(/obj/effect/overlay, src.loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(cardinal))

		spawn(10)
			qdel(pulse2)
	..()

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(25))
				qdel(src)

/obj/machinery/blob_act()
	if(prob(50))
		qdel(src)

//sets the use_power var and then forces an area power update
/obj/machinery/proc/update_use_power(var/new_use_power)
	use_power = new_use_power

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(src.use_power == 1)
		use_power(idle_power_usage,power_channel, 1)
	else if(src.use_power >= 2)
		use_power(active_power_usage,power_channel, 1)
	return 1

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/machinery/CanUseTopic(var/mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	return ..()

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(src in view(world.view, user))
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)
	if(inoperable(MAINT))
		return 1
	if(user.incapacitated())
		return 1
	if (!user.IsAdvancedToolUser())
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return 1

	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 55)
			visible_message("<span class='warning'>[H] stares cluelessly at [src].</span>")
			return 1
		else if(prob(H.getBrainLoss()))
			user << "<span class='warning'>You momentarily forget how to use \the [src].</span>"
			return 1

	src.add_fingerprint(user)

	return ..()

/obj/machinery/proc/InitCircuit()
	if(!circuit)
		return

	if(ispath(circuit))
		circuit = PoolOrNew(circuit, null)

	component_parts = list()
	if(circuit)
		component_parts += circuit

	for(var/item in circuit.req_components)
		if(item == /obj/item/stack/cable_coil)
			component_parts += PoolOrNew(item, list(null, circuit.req_components[item]))
		else
			for(var/j = 1 to circuit.req_components[item])
				component_parts += PoolOrNew(item, null)

	RefreshParts()

//Placeholder proc for machines that are built using frames.
/obj/machinery/proc/RefreshParts()

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] <span class = 'notice'>[msg]</span>", 2)

/obj/machinery/proc/ping(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	return electrocute_mob(user, get_area(src), src, 0.7)

/obj/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/storage/part_replacer/R)
	if(!istype(R))
		return 0
	if(!component_parts)
		return 0
	if(panel_open)
		var/P
		for(var/obj/item/weapon/stock_parts/A in component_parts)
			for(var/D in circuit.req_components)
				if(istype(A, D))
					P = D
					break
			for(var/obj/item/weapon/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.rating > A.rating)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.forceMove(null)
						user << SPAN_NOTE("[A.name] replaced with [B.name].")
						break
			update_icon()
			RefreshParts()
	else
		user << SPAN_NOTE("Following parts detected in the machine:")
		for(var/var/obj/item/C in component_parts)
			user << SPAN_NOTE("    [C.name]")
	return 1

/obj/machinery/proc/default_deconstruction_crowbar(var/mob/user, var/obj/item/weapon/crowbar/C)
	if(!istype(C))
		return 0
	if(!panel_open)
		return 0
	. = dismantle()

/obj/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/obj/item/weapon/screwdriver/S)
	if(!istype(S))
		return 0
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
	panel_open = !panel_open
	user << SPAN_NOTE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src].")
	update_icon()
	return 1

/obj/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	var/obj/machinery/constructable_frame/machine_frame/M = PoolOrNew(/obj/machinery/constructable_frame/machine_frame, loc)
	M.set_dir(src.dir)
	M.state = 2
	M.icon_state = "box_1"
	for(var/obj/I in component_parts)
		I.forceMove(loc)
		component_parts -= I
	circuit.forceMove(loc)
	circuit.deconstruct(src)
	qdel(src)
	return 1
