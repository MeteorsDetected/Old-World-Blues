/obj/item/weapon/implant/nanoaug
	name = "nanoaug"
	desc = "A nano-robotic biological augmentation implant."
	var/augmentation
	var/augment_text = "You feel strange..."
	var/activation_emote = "fart"

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Cybersun Industries Nano-Robotic Biological Augmentation Suite<BR>
<b>Life:</b> Infinite. WARNING: Biological changes are irreversable.<BR>
<b>Important Notes:</b> <font color='red'>Illegal</font>. Subjects exposed to nanorobotic agent are considered dangerous.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Implant contains colony of pre-programmed nanorobots. Subject will experience radical changes in their body, amplifying and improving certain bodily characteristics.<BR>
<b>Special Features:</b> Will grant subject superhuman powers.<BR>
<b>Integrity:</b> Nanoaugmentation is permanent. Once the process is complete, the nanorobots disassemble and are dissolved by the blood stream."}
		return dat


	implanted(mob/M)
		if(!istype(M, /mob/living/carbon/human))	return 0
		M.augmentations.Add(augmentation) // give them the mutation
		M << "\blue [augment_text]"

		return 1

/obj/item/weapon/implant/nanoaug/radar
	name = "Short-range Psionic Radar"
	augmentation = RADAR
	augment_text = "You begin to sense the presence or lack of presence of others around you."

	implanted(mob/M)
		if(..())
			M << "<font color='#FF0000'>Red</font color> blips on the map are Security."
			M << "White blips are civlians."
			M << "<font color='#3E710B'>Monochrome Green</font color> blips are cyborgs and AIs."
			M << "<font color='#238989'>Light blue</font color> blips are heads of staff."
			M << "<font color='#663366'>Purple</font color> blips are unidentified organisms."
			M << "Dead biologicals will not display on the radar."
			spawn()
				var/mob/living/carbon/human/H = M
				H.start_radar()
			return 1
		return 0

/obj/item/weapon/implant/nanoaug/rebreather
	name = "Bioelectric Rebreather"
	augmentation = REBREATHER
	augment_text = "You begin to lose your breath. Just as you are about to pass out, you suddenly lose the urge to breath. Breathing is no longer a necessity for you."

/obj/item/weapon/implant/nanoaug/dermalarmor
	name = "Skin-intergrated Dermal Armor"
	augmentation = DERMALARMOR
	augment_text = "The skin throughout your body grows tense and tight, and you become slightly stiff. Your bones and skin feel a lot stronger."

/obj/item/weapon/implant/nanoaug/reflexes
	name = "Combat Reflexes"
	augmentation = REFLEXES
	augment_text = "Your mind suddenly is able to identify threats before you are aware of them. You become more aware of your surroundings."

/obj/item/weapon/implant/nanoaug/nanoregen
	name = "Regenerative Nanobots"
	augmentation = NANOREGEN
	augment_text = "You feel a very faint vibration in your body. You instantly feel much younger."


/obj/item/weapon/implanter/nanoaug
	name = "Nanoaugmentation Implanter (Empty)"
	icon_state = "nanoimplant"


/obj/item/weapon/implanter/nanoaug/radar
	name = "Nanoaugmentation Implaner (Short-range Psionic Radar)"

/obj/item/weapon/implanter/nanoaug/radar/New()
	src.imp = new /obj/item/weapon/implant/nanoaug/radar( src )
	..()
	update_icon()

/obj/item/weapon/implanter/nanoaug/rebreather
	name = "Nanoaugmentation Implaner (Bioelectric Rebreather)"

/obj/item/weapon/implanter/nanoaug/rebreather/New()
	src.imp = new /obj/item/weapon/implant/nanoaug/rebreather( src )
	..()
	update_icon()

/obj/item/weapon/implanter/nanoaug/dermalarmor
	name = "Nanoaugmentation Implaner (Skin-intergrated Dermal Armor)"

/obj/item/weapon/implanter/nanoaug/dermalarmor/New()
	src.imp = new /obj/item/weapon/implant/nanoaug/dermalarmor( src )
	..()
	update_icon()

/obj/item/weapon/implanter/nanoaug/reflexes
	name = "Nanoaugmentation Implaner (Combat Reflexes)"

/obj/item/weapon/implanter/nanoaug/reflexes/New()
	src.imp = new /obj/item/weapon/implant/nanoaug/reflexes( src )
	..()
	update_icon()

/obj/item/weapon/implanter/nanoaug/nanoregen
	name = "Nanoaugmentation Implaner (Regenerative Nanobots)"

/obj/item/weapon/implanter/nanoaug/nanoregen/New()
	src.imp = new /obj/item/weapon/implant/nanoaug/nanoregen( src )
	..()
	update_icon()


