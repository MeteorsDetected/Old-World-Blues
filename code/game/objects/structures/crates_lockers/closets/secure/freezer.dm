/obj/structure/closet/secure_closet/freezer
	icon_state = "fridge"
	icon_opened = "fridgeopen"

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/freezer/kitchen/willContatin()
	return list(
		/obj/item/weapon/reagent_containers/condiment/flour = 7,
		/obj/item/weapon/reagent_containers/condiment/sugar = 2,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey = 3
	)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()


/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"

/obj/structure/closet/secure_closet/freezer/meat/willContatin()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey = 4
	)


/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"

/obj/structure/closet/secure_closet/freezer/fridge/willContatin()
	return list(
		/obj/item/weapon/reagent_containers/glass/drinks/milk = 6,
		/obj/item/weapon/reagent_containers/glass/drinks/soymilk = 4,
		/obj/item/storage/fancy/egg_box = 2
	)


/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/willContatin()
	return list(
		/obj/item/weapon/spacecash/c1000 = 3,
		/obj/item/weapon/spacecash/c500  = 4,
		/obj/item/weapon/spacecash/c200  = 5
	)
