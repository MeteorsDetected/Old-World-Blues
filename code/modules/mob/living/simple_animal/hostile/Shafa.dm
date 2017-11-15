/mob/living/simple_animal/hostile/shafra
	name = "Shafra"
	desc = "A huge creature, with a dozen eyes and clearly evil intentions. It seems that it came here from Hell."
	icon = 'icons/mob/Shafra.dmi'
	icon_state = "shafra"
	icon_living = "shafra"
	icon_dead = "shafra_dead"
	icon_gib = "v6"
	speak_chance = 1
	turns_per_move = 0
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_harm = "hits the"
	speed = 2
	maxHealth = 1000
	health = 200
	harm_intent_damage = 50
	melee_damage_lower = 35
	melee_damage_upper = 35
	attacktext = "bitten"
	attack_sound = 'sound/weapons/slice.ogg'


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