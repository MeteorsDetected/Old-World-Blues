/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armour = "bullet"
	sharp = 1
	edge = 1

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(isliving(target))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/living/M in range(10, src))
					if(!M.stat && !isAI(M))
						shake_camera(M, 3, 1)
				qdel(src)
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				if(prob(15))
					M.apply_effect((rand(30,80)),IRRADIATE)
					M.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
				if(prob(35))
				//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
				//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
					if(prob(80))
						randmutb(M)
					else
						randmutg(M)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("\red The radiation beam singes you!")
				//	for (var/mob/V in viewers(src))
				//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
		else if(istype(target, /mob/living/carbon/))
		//	for (var/mob/V in viewers(src))
		//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
			M.show_message(SPAN_NOTE("The radiation beam dissipates harmlessly through your body."))
		else
			return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				M.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message(SPAN_NOTE("The radiation beam dissipates harmlessly through your body."))
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.adjustBrainLoss(20)
			M.hallucination += 20

/*/obj/item/projectile/icarus/pointdefense/process()
	Icarus_FireLaser(get_turf(original))
	spawn
		qdel(src)

	return
*/

/obj/item/projectile/icarus/guns/process()
	Icarus_FireCannon(get_turf(original))
	spawn
		qdel(src)
	return

/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 15
	damage_type = BRUTE
	check_armour = "bomb"
	kill_count = 2

	var/pressure_decrease = 0.25
	var/turf_aoe = FALSE
	var/mob_aoe = 0
	var/list/hit_overlays = list()

/obj/item/projectile/kinetic/launch(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)
	if(istype(launcher, /obj/item/weapon/gun/energy/kinetic_accelerator))
		var/obj/item/weapon/gun/energy/kinetic_accelerator/KA = launcher
		for(var/A in KA.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			M.modify_projectile(src)
	..()

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	strike_thing(A)
	. = ..()

/obj/item/projectile/kinetic/proc/strike_thing(atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		target_turf = get_turf(src)
	var/datum/gas_mixture/environment = target_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure > 50)
		name = "weakened [name]"
		damage *= pressure_decrease
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.GetDrilled(1)
	var/obj/effect/overlay/temp/kinetic_blast/K = new /obj/effect/overlay/temp/kinetic_blast(target_turf)
	K.color = color
	for(var/type in hit_overlays)
		new type(target_turf)
	if(turf_aoe)
		for(var/T in orange(1, target_turf))
			if(istype(T, /turf/simulated/mineral))
				var/turf/simulated/mineral/M = T
				M.GetDrilled(1)
	if(mob_aoe)
		for(var/mob/living/L in range(1, target_turf) - firer - target)
			L.apply_damage(damage*mob_aoe, damage_type, def_zone, armor)
			L << "<span class='danger'>You're struck by a [name]!</span>"
