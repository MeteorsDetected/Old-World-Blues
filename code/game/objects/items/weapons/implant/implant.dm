#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = ITEM_SIZE_TINY
	var/implanted = null
	var/mob/imp_in = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/allow_reagents = 0
	var/malfunction = 0

	proc/trigger(emote, source as mob)
		return

	proc/activate()
		return

	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
		if(src.imp_in)
			src.imp_in.gib()

	// What does the implant do upon injection?
	// return FALSE if the implant fails (ex. Revhead and loyalty implant.)
	// return TRUE  if the implant succeeds (ex. Nonrevhead and loyalty implant.)
	proc/implanted(var/mob/living/source, var/obj/item/organ/external/affected)
		forceMove(source)
		imp_in = source
		implanted = TRUE
		if(affected)
			affected.implants += src
			part = affected
			BITSET(source.hud_updateflag, IMPLOYAL_HUD)
		on_implanted(source, affected)
		return TRUE

	proc/on_implanted(var/mob/living/source, var/obj/item/organ/external/E)

	proc/get_data()
		return "No information available"

	proc/hear(message, mob/living/source)

	proc/islegal()
		return FALSE

	proc/meltdown()	//breaks it down, making implant unrecongizible
		imp_in << SPAN_WARN("You feel something melting inside [part ? "your [part.name]" : "you"]!")
		if (part)
			part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
		else
			var/mob/living/M = imp_in
			M.apply_damage(15,BURN)
		name = "melted implant"
		desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
		icon_state = "implant_melted"
		malfunction = MALFUNCTION_PERMANENT

	Destroy()
		if(part)
			part.implants.Remove(src)
		..()

/obj/item/weapon/implant/defibrillators
	name = "defibrillators"
	desc = "Tries to defibrillate owner."
	var/uses = 3
	var/verbPresent = 0

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> SolarTek Self-Defibrillator Unit<BR>
<b>Important Notes:</b> <font color='red'>Army Grade</font><BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant would be defibrillated in case of death.<BR>
<b>Function:</b> Contains electrical capacitor to stimulate heart in case of death.<BR>
<b>Integrity:</b> Implant can only be used [uses] times before running out of charge."}
		return dat

	process()
		if (!implanted) return
		var/mob/living/carbon/C = imp_in

		if(isnull(C) || !istype(C)) // If the mob got gibbed
			processing_objects.Remove(src)
			spawn(0) del(src)
		else if(verbPresent && (uses < 0 || !C.stat))
			verbs -= /obj/item/weapon/implant/defibrillators/proc/Shock
			verbPresent = 0
		else if(!verbPresent && uses>0 && C.stat)
			verbs += /obj/item/weapon/implant/defibrillators/proc/Shock
			verbPresent = 1

	proc/Shock()
		set name = "Defibrillate"
		set desc = "Activates defibrillators."
		set category = "Implant"

		if (!implanted || uses<1) return

		var/mob/living/carbon/C = imp_in

		uses--
		spawn(4800)
			uses++

		C.apply_effect(10, STUTTER, 0)
		if(C.jitteriness<=100)
			C.make_jittery(150)
		else
			C.make_jittery(50)
		C.losebreath = -15
		if(C.health<=config.health_threshold_crit)
			var/suff = min(C.getOxyLoss(), 50)
			C.adjustOxyLoss(-suff)
			C.updatehealth()
			if(C.stat == DEAD && C.health>config.health_threshold_dead)
				C.stat = UNCONSCIOUS
		else if(C.stat == DEAD)
			C.stat = CONSCIOUS

		C.visible_message("\red %knownface:1% shudders suddenly!", "You hear electricity zaps flesh.", actors=list(C))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, C)
		s.start()

		if(C.reagents)
			var/amnt = C.reagents.get_reagent_amount("oxycodone")
			if(amnt<2.5)
				C.reagents.add_reagent("oxycodone",2.5-amnt)
			amnt = C.reagents.get_reagent_amount("synaptizine")
			if(amnt<2.5)
				C.reagents.add_reagent("synaptizine",2.5-amnt)
			amnt = C.reagents.get_reagent_amount("bicaridine")
			if(amnt<2.5)
				C.reagents.add_reagent("bicaridine",2.5-amnt)
			amnt = C.reagents.get_reagent_amount("dermaline")
			if(amnt<2.5)
				C.reagents.add_reagent("dermaline",2.5-amnt)
			amnt = C.reagents.get_reagent_amount("anti_toxin")
			if(amnt<2.5)
				C.reagents.add_reagent("anti_toxin",2.5-amnt)

	implanted(mob/source)
		processing_objects.Add(src)
		return 1


