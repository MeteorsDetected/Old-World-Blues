//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A comfortable voidsuit helmet with cranial armor and eight-channel surround sound."
	icon_state = "rig0-sec"
	item_state = "sec_helm"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/security
	icon_state = "sec-void"
	item_state = "sec-void"
	name = "security voidsuit"
	desc = "A somewhat clumsy voidsuit layered with impact and laser-resistant armor plating. Specially designed to dissipate minor electrical charges."
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	allowed = list(
		/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/melee/baton
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/void/security/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/security
	boots = new /obj/item/clothing/shoes/magboots


//Surplus Voidsuits
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "riot security voidsuit helmet"
	desc = "A somewhat tacky voidsuit helmet, a fact mitigated by heavy armor plating."
	icon_state = "rig0-secalt"
	item_state = "secalt_helm"
	armor = list(melee = 70, bullet = 20, laser = 30, energy = 5, bomb = 35, bio = 100, rad = 10)

/obj/item/clothing/suit/space/void/security/alt
	icon_state = "secalt-void"
	name = "riot security voidsuit"
	desc = "A heavily armored voidsuit, designed to intimidate people who find black intimidating. Surprisingly slimming."
	armor = list(melee = 70, bullet = 20, laser = 30, energy = 5, bomb = 35, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

/obj/item/clothing/suit/space/void/security/alt/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/security/alt
	boots = new /obj/item/clothing/shoes/magboots

