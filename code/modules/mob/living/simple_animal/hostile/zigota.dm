/mob/living/simple_animal/hostile/zigota
	name = "Something"
	desc = "What the fuck is that!?"
	icon = 'icons/mob/animal.dmi'
	icon_state = "zigota_full"
	icon_living = "zigota_full"
	icon_dead = "zigota_dead"
	icon_gib = "v6"
	speak_chance = 1
	turns_per_move = 0
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_harm = "hits the"
	speed = 6
	maxHealth = 40
	health = 30
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/effects/blobattack.ogg'


	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	/mob/living/simple_animal/hostile/zigota/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
