//sewing


////////>RECIPES<\\\\\\\\


//To add stuff, just add another one object to list. Don't forget about semicolon
//target = final object to spawn
//required_items is items that required at craft
//first - display name that player will see then they examine the stuff
//second - path of object
//third, only - must be 1 or 0/null. If only is active, then required item MUST have this path. Otherwise, this path and child allowed
var/list/sewing_recipes = list(
"Deer hat" = list(target = /obj/item/clothing/head/deerhat, required_items = list(
										"tendons" = list(path = /obj/item/weapon/tendon, amount = 6),
										"leather stripes" = list(path = /obj/item/weapon/leatherstripes, amount = 2),
										"deer's head" = list(path = /obj/item/weapon/head, amount = 1, only = 1),
										"good skin" = list(path = /obj/item/weapon/skin, amount = 1, only = 1)
										)),
"Wolf mask" = list(target = /obj/item/clothing/mask/wolfmask, required_items = list(
										"tendons" = list(path = /obj/item/weapon/tendon, amount = 2),
										"leather stripes" = list(path = /obj/item/weapon/leatherstripes, amount = 6),
										"wolf's head" = list(path = /obj/item/weapon/head/wolf, amount = 1, only = 1),
										"good skin" = list(path = /obj/item/weapon/skin, amount = 1, only = 1)
										)),
"Fur cloak" = list(target = /obj/item/clothing/suit/storage/furcape, required_items = list(
										"tendons" = list(path = /obj/item/weapon/tendon, amount = 10),
										"leather stripes" = list(path = /obj/item/weapon/leatherstripes, amount = 9),
										"good skin" = list(path = /obj/item/weapon/skin, amount = 2, only = 1)
										)),
"Fur boots(high)" = list(target = /obj/item/clothing/shoes/jackboots/furboots, required_items = list(
										"tendons" = list(path = /obj/item/weapon/tendon, amount = 4),
										"leather stripes" = list(path = /obj/item/weapon/leatherstripes, amount = 6),
										"wood chunks" = list(path = /obj/item/weapon/snowy_woodchunks, amount = 2),
										"good skin" = list(path = /obj/item/weapon/skin, amount = 1, only = 1)
										)),
"Wild pouch" = list(target = /obj/item/storage/belt/wildpouch, required_items = list(
										"tendons" = list(path = /obj/item/weapon/tendon, amount = 4),
										"leather stripes" = list(path = /obj/item/weapon/leatherstripes, amount = 4),
										"branches" = list(path = /obj/item/weapon/branches, amount = 6),
										"good skin" = list(path = /obj/item/weapon/skin, amount = 1)
										))
										)





////////>ITEMS<\\\\\\\\


//skin's attackby. Maybe this is more efficient make such things through the after attack proc
/obj/item/weapon/skin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/needle) && src.type != /obj/item/weapon/skin/bad)
		var/obj/item/weapon/needle/N = W
		if (N.threads > 0)
			var/making_obj = input(user, "Make what?") in sewing_recipes
			var/obj/item/weapon/unfinishedfurs/U = new(get_turf(src))
			U.makeThings(making_obj)
			qdel(src)
		else
			user << SPAN_WARN("You need threads to start it.")
	if(W.sharp)
		for(var/i=1, i <= 3, i++)
			new /obj/item/weapon/leatherstripes(get_turf(src))
		user << SPAN_NOTE("You slice skin into the stripes of almost perfect leather.")
		qdel(src)


/obj/item/weapon/spindle
	name = "Spindle"
	desc = "Spindle with some threads. Take off your finger from it!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "spindle"
	w_class = ITEM_SIZE_TINY
	var/charges = 5


/obj/item/weapon/needle
	name = "bone needle"
	desc = "Looks sharp but crooked."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "bone_needle"
	w_class = ITEM_SIZE_TINY
	var/threads = 0


/obj/item/weapon/needle/update_icon()
	..()
	overlays.Cut()
	if(threads > 0)
		overlays += "needle_thread"


/obj/item/weapon/needle/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(threads > 0)
		user << SPAN_WARN("Threads are already here.")
		return
	if(istype(O, /obj/item/weapon/spindle))
		var/obj/item/weapon/spindle/S = O
		user << SPAN_NOTE("You put the thread through the needle eye.")
		if(S.charges > 0)
			threads = 3
			S.charges--
			update_icon()
			if(S.charges < 1)
				qdel(S)
				new /obj/item/weapon/stick(get_turf(src))


/obj/item/weapon/leatherstripes
	name = "Leather stripes"
	desc = "Inaccurate, but still useful. Looks like a bacon but this is not!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "leather_stripes"
	w_class = ITEM_SIZE_TINY


////////>MECHANICS<\\\\\\\\


/obj/item/weapon/unfinishedfurs
	name = "Unfinished"
	desc = "Fur, leather, threads. This is how it begins."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "fur_stuff"
	w_class = ITEM_SIZE_SMALL
	var/required_thread = 0
	var/target_path
	var/list/required_items = list()


/obj/item/weapon/unfinishedfurs/proc/makeThings(var/choosed_obj)
	var/list/O = sewing_recipes[choosed_obj]
	target_path = O["target"]
	var/list/R = O["required_items"]
	required_items = R.Copy()
	src.name = "[src.name] [choosed_obj]"


/obj/item/weapon/unfinishedfurs/examine(mob/user as mob)
	..()
	if(required_thread)
		user << SPAN_NOTE("Need to sew this.")
	else
		for(var/v in required_items)
			var/item = required_items[v]
			var/amount = item["amount"]
			var/prefix = "One [v]"
			if(amount > 1)
				prefix = "Some of [v]"
			if(amount > 3)
				prefix = "[amount] of [v]"
			var/postfix = pick("is required", "needed here", "will be better to add")
			user << SPAN_NOTE("[prefix] [postfix]")


/obj/item/weapon/unfinishedfurs/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(required_thread)
		if(istype(W, /obj/item/weapon/needle))
			var/obj/item/weapon/needle/N = W
			if(N.threads > 0)
				user.visible_message(
						SPAN_NOTE("[user] sews something with needle."),
						SPAN_NOTE("You sew the [name].")
					)
				N.threads--
				N.update_icon()
				required_thread = 0
				if(required_items.len == 0)
					new target_path(get_turf(src))
					qdel(src)
			else
				user << SPAN_WARN("You need threads.")
		else
			user << SPAN_WARN("You need to sew this first.")
	else
		for(var/obj in required_items)
			var/list/item = required_items[obj]
			if( (item["only"] && W.type == item["path"]) || (!item["only"] && istype(W, item["path"]) ) )
				item["amount"]--
				qdel(W)
				required_thread = 1
				user << SPAN_NOTE("You add [W].")
				if(item["amount"] < 1)
					required_items.Remove(obj)
					break