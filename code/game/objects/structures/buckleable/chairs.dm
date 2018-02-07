/obj/structure/material/chair
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "chair_preview"
	color = "#666666"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = 0
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	mob_offset_y = 0
	base_icon = "chair"
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/material/chair/initialize()
	..()
	update_layer()

/obj/structure/material/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			user << SPAN_NOTE("\The [SK] is not ready to be attached!")
			return
		user.unEquip(SK)
		var/obj/structure/material/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/material/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()

/obj/structure/material/chair/post_buckle_mob()
	update_icon()

/obj/structure/material/chair/update_icon()
	..()
	if(padding_material && buckled_mob)
		var/armrest_key = "[base_icon]-armrest-[padding_material.name]"
		if(isnull(stool_cache[armrest_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = MOB_LAYER + 0.1
			I.color = padding_material.icon_colour
			stool_cache[armrest_key] = I
		overlays |= stool_cache[armrest_key]


/obj/structure/material/chair/proc/update_layer()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/material/chair/set_dir()
	..()
	update_layer()
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/material/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.set_dir(turn(src.dir, 90))
		return
	else
		if(ismouse(usr))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.set_dir(turn(src.dir, 90))
		return

// Leaving this in for the sake of compilation.
/obj/structure/material/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"

/obj/structure/material/chair/comfy/brown
	padding_material = "leather"

/obj/structure/material/chair/comfy/red
	padding_material = "red"

/obj/structure/material/chair/comfy/teal
	padding_material = "teal"

/obj/structure/material/chair/comfy/black
	padding_material = "black"

/obj/structure/material/chair/comfy/green
	padding_material = "green"

/obj/structure/material/chair/comfy/purp
	padding_material = "purple"

/obj/structure/material/chair/comfy/blue
	padding_material = "blue"

/obj/structure/material/chair/comfy/beige
	padding_material = "beige"

/obj/structure/material/chair/comfy/lime
	padding_material = "lime"

/obj/structure/material/chair/office
	anchored = 0
	buckle_movable = 1

/obj/structure/material/chair/office/update_icon()
	return

/obj/structure/material/chair/office/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	..()

/obj/structure/material/chair/office/Move()
	..()
	if(buckled_mob)
		var/mob/living/occupant = buckled_mob
		occupant.buckled = null
		occupant.Move(src.loc)
		occupant.buckled = src
		if (occupant && (src.loc != occupant.loc))
			if (propelled)
				for (var/mob/O in src.loc)
					if (O != occupant)
						Bump(O)
			else
				unbuckle_mob()

/obj/structure/material/chair/office/Bump(atom/A)
	..()
	if(!buckled_mob)	return

	if(propelled)
		var/mob/living/occupant = unbuckle_mob()

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, blocked)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(isliving(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, blocked)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/material/chair/office/light
	icon_state = "officechair_white"

/obj/structure/material/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/material/chair/office/bridge
	name = "command chair"
	desc = "It exudes authority... and looks about as comfortable as a brick."
	icon_state = "bridge"

// Chair types
/obj/structure/material/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	material = MATERIAL_WOOD

/obj/structure/material/chair/wood/update_icon()
	return

/obj/structure/material/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	..()

/obj/structure/material/chair/wood/wings
	icon_state = "wooden_chair_wings"


/obj/structure/material/chair/plastic/shuttle
	name = "shuttle chair"
	icon_state = "schair"
	base_icon = "schair"
	material = MATERIAL_PLASTIC
	padding_material = MATERIAL_PLASTIC
