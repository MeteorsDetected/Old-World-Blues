/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon_state = "wallet"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL //Don't worry, see can_hold[]
	max_storage_space = 8
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable/cigarette,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/flame/match,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/stamp)
	slot_flags = SLOT_ID
	var/obj/item/weapon/card/id/front_id = null

/obj/item/storage/wallet/handle_item_insertion(obj/item/weapon/card/id/W, prevent_warning)
	. = ..()
	if(. && !front_id && istype(W))
		front_id = W

/obj/item/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(istype(W, /obj/item/weapon/card/id))
			if(W == front_id)
				front_id = null
			update_icon()

/obj/item/storage/wallet/update_icon()

	if(front_id)
		switch(front_id.icon_state)
			if("id")
				icon_state = "walletid"
				return
			if("silver")
				icon_state = "walletid_silver"
				return
			if("gold")
				icon_state = "walletid_gold"
				return
			if("centcom")
				icon_state = "walletid_centcom"
				return
	icon_state = "wallet"


/obj/item/storage/wallet/GetIdCard()
	return front_id

/obj/item/storage/wallet/GetAccess()
	return front_id && front_id.access

/obj/item/storage/wallet/random/populateContents()
	..()
	var/spawn_path = pick(\
		/obj/item/weapon/spacecash/c10,
		/obj/item/weapon/spacecash/c100,
		/obj/item/weapon/spacecash/c1000,
		/obj/item/weapon/spacecash/c20,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c50,
		/obj/item/weapon/spacecash/c500)
	new spawn_path (src)

	if(prob(50))
		spawn_path = pick(\
			/obj/item/weapon/spacecash/c10,
			/obj/item/weapon/spacecash/c100,
			/obj/item/weapon/spacecash/c1000,
			/obj/item/weapon/spacecash/c20,
			/obj/item/weapon/spacecash/c200,
			/obj/item/weapon/spacecash/c50,
			/obj/item/weapon/spacecash/c500)
		new spawn_path (src)

	spawn_path = pick(\
		/obj/item/weapon/coin/silver,
		/obj/item/weapon/coin/silver,
		/obj/item/weapon/coin/gold,
		/obj/item/weapon/coin/iron,
		/obj/item/weapon/coin/iron,
		/obj/item/weapon/coin/iron)
	new spawn_path (src)

