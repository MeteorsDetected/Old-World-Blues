//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.
#define NEST_RESIST_TIME 1200

/obj/structure/alien_nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/alien.dmi'
	icon_state = "nest"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = RIGHT
	mob_offset_y = 3
	var/health = 100

/obj/structure/alien_nest/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(
					SPAN_NOTE("[user.name] pulls [buckled_mob.name] free from the sticky nest!"),
					SPAN_NOTE("[user.name] pulls you free from the gelatinous resin."),
					SPAN_NOTE("You hear squelching...")
				)
				buckled_mob.pixel_y = 0
				buckled_mob.old_y = 0
				unbuckle_mob()
			else
				if(world.time <= buckled_mob.last_special+NEST_RESIST_TIME)
					return
				buckled_mob.last_special = world.time
				buckled_mob.visible_message(
					SPAN_WARN("[buckled_mob.name] struggles to break free of the gelatinous resin..."),
					SPAN_WARN("You struggle to break free from the gelatinous resin..."),
					SPAN_NOTE("You hear squelching..."))
				spawn(NEST_RESIST_TIME)
					if(user && buckled_mob && user.buckled == src)
						buckled_mob.last_special = world.time
						buckled_mob.pixel_y = 0
						buckled_mob.old_y = 0
						unbuckle_mob()
			src.add_fingerprint(user)

/obj/structure/alien_nest/user_buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || ispAI(user) )
		return

	unbuckle_mob()

	var/mob/living/carbon/xenos = user
	var/mob/living/carbon/victim = M

	if(istype(victim) && locate(/obj/item/organ/internal/xenos/hivenode) in victim.internal_organs)
		return

	if(istype(xenos) && !(locate(/obj/item/organ/internal/xenos/hivenode) in xenos.internal_organs))
		return

	if(M == usr)
		return
	else
		M.visible_message(
			SPAN_NOTE("[user.name] secretes a thick vile goo, securing [M.name] into [src]!"),
			SPAN_WARN("[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!"),
			SPAN_NOTE("You hear squelching...")
		)
	M.buckled = src
	M.loc = src.loc
	M.set_dir(src.dir)
	M.update_canmove()
	M.pixel_y = 6
	M.old_y = 6
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/alien_nest/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	visible_message(SPAN_WARN("[user] hits [src] with [W]!"))
	healthcheck()

/obj/structure/alien_nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)