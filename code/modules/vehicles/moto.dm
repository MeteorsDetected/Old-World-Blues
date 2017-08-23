/obj/motorcycle
	can_buckle = TRUE
	density = FALSE
	name = "mining motorcycle"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "motorcycle"
	mob_offset_y = 3
	var/move_break
	var/move_delay = 1
	var/obj/structure/trailer/trailer = null
	var/light_on = 6
	var/engine_on = FALSE

/obj/motorcycle/New()
	..()
	move_break = world.time
	update_icon()

/obj/motorcycle/update_icon()
	overlays.Cut()
	var/image/I = image(icon,src,"[icon_state]_over",MOB_LAYER+0.1)
	overlays += I


/obj/motorcycle/relaymove(var/mob/user, direction)
	if(user != buckled_mob)
		return
	if((move_break + move_delay) > world.time)
		return

	if(!engine_on)
		in_use = TRUE
		engine_on = TRUE
		set_light(light_on)
		playsound(src.loc, 'sound/effects/engine_start.ogg', 50, 1)
		move_break = world.time + 15
		return

	move_break = world.time
	if(dir == direction)
		Move(get_step(src, direction))
	else if(dir == turn(direction, 180))
		Move(get_step(src, direction))
		move_break += 4
	else
		if(Move(get_step(src, dir)))
			Move(get_step(src, direction))
			set_dir(direction)

/obj/motorcycle/set_dir(new_dir)
	. = ..()
	if(. && buckled_mob)
		buckled_mob.set_dir(dir)


/obj/motorcycle/Move()
	if(trailer)
		if(!trailer.can_move())
			if(buckled_mob)
				buckled_mob << SPAN_WARN("[trailer] holds you!")
			return FALSE
	. = ..()
	if(. && buckled_mob)
		buckled_mob.forceMove(src.loc)

/*
/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)
*/

/obj/structure/trailer/proc/can_move()
	return TRUE
