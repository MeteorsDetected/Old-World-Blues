/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydrosecure"
	icon_opened = "hydrosecureopen"

/obj/structure/closet/secure_closet/hydroponics/willContatin()
	. = list(
		/obj/item/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/device/radio/headset/service,
		/obj/item/clothing/head/greenbandana,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/hatchet,
		/obj/item/weapon/wirecutters/clippers,
		/obj/item/weapon/reagent_containers/spray/plantbgone,
//		/obj/item/weapon/bee_net, //No more bees, March 2014
	)
	. += pick(\
		/obj/item/clothing/suit/apron,
		/obj/item/clothing/suit/apron/overalls,
	)

