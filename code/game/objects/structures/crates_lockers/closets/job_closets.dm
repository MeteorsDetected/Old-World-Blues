/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_state = "black"

/obj/structure/closet/gmcloset/New()
	return list(
		/obj/item/clothing/head/that = 2,
		/obj/item/device/radio/headset/service = 2,
		/obj/item/clothing/head/hairflower,
		/obj/item/clothing/under/sl_suit = 2,
		/obj/item/clothing/under/rank/bartender = 2,
		/obj/item/clothing/under/dress/saloon,
		/obj/item/clothing/shoes/black = 2,
	)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	icon_state = "black"

/obj/structure/closet/chefcloset/willContatin()
	return list(
		/obj/item/clothing/under/dress/sundress,
		/obj/item/clothing/under/waiter = 2,
		/obj/item/device/radio/headset/service = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/head/chefhat,
	)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_state = "mixed"

/obj/structure/closet/jcloset/willContatin()
	return list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/device/radio/headset/service,
		/obj/item/weapon/cartridge/janitor,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/head/beret/jan,
		/obj/item/device/flashlight,
		/obj/item/weapon/caution = 4,
		/obj/item/device/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/storage/belt/janitor,
		/obj/item/clothing/shoes/galoshes,
	)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_state = "blue"

/obj/structure/closet/lawcloset/willContatin()
	return list(
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/bluesuit = 2,
		/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 2,
		/obj/item/clothing/under/lawyer/purpsuit = 2,
		/obj/item/clothing/suit/storage/lawyer/purpjacket,
		/obj/item/clothing/shoes/brown = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/glasses/sunglasses/big = 2,
		/obj/item/clothing/under/rank/internalaffairs,
		/obj/item/clothing/under/rank/internalaffairsdress,
	)

