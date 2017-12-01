//by Difilex, так что вы знаете на кого срать за списки.

//СПИСКИ*start*//
var/list/Dtools = list(/obj/item/weapon/wrench,/obj/item/weapon/screwdriver,/obj/item/weapon/wirecutters,
/obj/item/weapon/weldingtool,/obj/item/weapon/crowbar,/obj/item/stack/cable_coil,/obj/item/device/analyzer)
var/list/Dtrash = list(/obj/item/weapon/bikehorn,/obj/item/device/hailer,/obj/item/storage/fancy/candle_box,
/obj/item/weapon/soap/nanotrasen,/obj/item/weapon/spacecash/c200)
var/list/Dtoys = list(/obj/item/toy/nanotrasenballoon,/obj/item/toy/gun,/obj/item/toy/crossbow,/obj/item/toy/sword,
/obj/item/toy/plushie/mouse,/obj/item/toy/plushie/nymph,/obj/item/toy/plushie/kitten,/obj/item/toy/plushie/spider,
/obj/item/toy/plushie/man)
var/list/Dclothing = list(/obj/item/clothing/head/richard,/obj/item/clothing/head/kitty,/obj/item/clothing/gloves/black,
/obj/item/clothing/gloves/latex,/obj/item/clothing/gloves/black/batman,/obj/item/clothing/mask/scarf/ninja,/obj/item/clothing/mask/bandana/skull,
/obj/item/clothing/under/dress/saloon,/obj/item/clothing/under/sexyclown,/obj/item/clothing/under/overalls,/obj/item/clothing/under/pants/jeans)
//СПИСКИ*end*//

/obj/randomloot
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	New()
		spawn_stuff()
		qdel(src)

/obj/randomloot/proc/spawn_stuff()
//Рандом выбирает предмет из списка
	var/spawntools = pick(Dtools)
	var/spawntrash = pick(Dtrash)
	var/spawntoys = pick(Dtoys)
	var/spawnclothes = pick(Dclothing)
//Предмет спавнится
	new spawntools(src.loc)
	new spawntrash(src.loc)
	new spawntoys(src.loc)
	new spawnclothes(src.loc)
