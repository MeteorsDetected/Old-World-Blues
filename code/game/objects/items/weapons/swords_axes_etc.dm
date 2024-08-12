/* Weapons
 * Contains:
 *		Banhammer
 *		Sword
 *		Classic Baton
 */

/*
 * Banhammer
 */
/obj/item/weapon/banhammer/attack(mob/M as mob, mob/user as mob)
	M << "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>"
	user << "<font color='red'> You have <b>BANNED</b> [M]</font>"

/*
 * Classic Baton
 */
/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	slot_flags = SLOT_BELT
	force = 10

/obj/item/weapon/melee/classic_baton/attack(mob/living/M, mob/living/user)
	//TODO: DNA3 clown_block
/*
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You club yourself over the head."
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return
*/
	if (user.a_intent == I_HURT)
		if(!..()) return
		//playsound(src.loc, "swing_hit", 50, 1, -1)

		if (M.stuttering < 8)
			M.stuttering = 8
		M.Stun(8)
		M.Weaken(8)
		M.visible_message(
			SPAN_DANGER("[M] has been beaten with \the [src] by [user]!"),
			SPAN_DANGER("You has been beaten with \the [src] by [user]!"),
			SPAN_WARN("You hear someone fall")
		)
	else
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1, -1)
		M.Stun(5)
		M.Weaken(5)
		admin_attack_log(user, M,
			"Used the [src.name] to attack [key_name(M)]",
			"Has been attacked with [src.name] by [key_name(user)]",
			"used [src.name] to attack"
		)
		src.add_fingerprint(user)

		M.visible_message(
			SPAN_DANGER("[M] has been stunned with \the [src] by [user]!"),
			SPAN_DANGER("You has been stunned with \the [src] by [user]!"),
			SPAN_WARN("You hear someone fall")
		)

//Telescopic baton
/obj/item/weapon/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 3
	var/on = 0


/obj/item/weapon/melee/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(
			"<span class='warning'>With a flick of their wrist, [user] extends their telescopic baton.</span>",
			"<span class='warning'>You extend the baton.</span>",
			"You hear an ominous click."
		)
		icon_state = "telebaton_1"
		w_class = ITEM_SIZE_NORMAL
		force = 15//quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message(
			SPAN_NOTE("\The [user] collapses their telescopic baton."),\
			SPAN_NOTE("You collapse the baton."),\
			"You hear a click."
		)
		icon_state = "telebaton_0"
		w_class = ITEM_SIZE_SMALL
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	update_held_icon()

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)

	if(blood_overlay && blood_DNA && (blood_DNA.len >= 1)) //updates blood overlay, if any
		overlays.Cut()//this might delete other item overlays as well but eeeeeeeh

		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY)
		blood_overlay = I

		overlays += blood_overlay

	return

/obj/item/weapon/melee/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		//TODO: DNA3 clown_block
/*
		if ((CLUMSY in user.mutations) && prob(50))
			user << "\red You club yourself over the head."
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, BP_HEAD)
			else
				user.take_organ_damage(2*force)
			return
*/
		if(..())
			//playsound(src.loc, "swing_hit", 50, 1, -1)
			return
	else
		return ..()
