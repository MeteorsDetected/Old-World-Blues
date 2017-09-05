//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/obj/structure/ladder/target

	Destroy()
		if(target && icon_state == "ladder01")
			qdel(target)
		return ..()

	attackby(obj/item/C as obj, mob/user as mob)
		. = ..()
		attack_hand(user)
		return

	attack_hand(var/mob/M)
		if(!target || !istype(target.loc, /turf))
			M << SPAN_NOTE("\The [src] is incomplete and can't be climbed.")
			return

		var/turf/T = target.loc
		for(var/atom/A in T)
			if(A.density)
				M << SPAN_NOTE("\A [A] is blocking \the [src].")
				return

		M.visible_message(
			SPAN_NOTE("\A [M] climbs [icon_state == "ladderup" ? "up" : "down"] \a [src]!"),
			"You climb [icon_state == "ladderup"  ? "up" : "down"] \the [src]!",
			"You hear the grunting and clanging of a metal ladder being used."
		)
		M.Move(T)

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density