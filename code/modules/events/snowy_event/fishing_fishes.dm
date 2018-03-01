//Fishes from fishing here, take a look.
//TODO-list:
//Add more fishes
//Add more bites
//Add medium and big fishes



/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish
	name = "fish"
	desc = "dat fish"
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "dat_fish"
	w_class = ITEM_SIZE_TINY
	var/size
	var/minSize = 80
	var/maxSize = 220
	var/sizeAdd = 40
	var/anomalySizeAdd = 40
	var/rarity		//1 - common, reagents *1/ 2 - big(100%), reagents *2/ 3 - rare(200%), reagents *3 / 4 - legend(300%), you know what you got
//	var/list/internals = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/fishmeat = 2) //bones, eyes and guts i make later
	center_of_mass = list("x"=17, "y"=13)
	reagents_to_vaporize = list("blood")
	feel_desc = "fibrous fish"


	New()
		..()
		size = rand(minSize, maxSize) + rand(sizeAdd)
		if(prob(20))
			size += anomalySizeAdd
			name = "anomaly sized [name]"
			w_class = ITEM_SIZE_SMALL
		var/K = (minSize + maxSize)/2
		if(size < K)
			rarity = 1
			return
		var/Prcnt = round((size*100)/K)
		if(Prcnt >= 300)
			rarity = 4
			name = "legend [name]"
		else if(Prcnt >= 200)
			rarity = 3
			name = "rare [name]"
		else if(Prcnt >= 100)
			rarity = 2
			name = "big [name]"
		bitesize = 12-(3*rarity)


/*/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(O.sharp)
		user << SPAN_NOTE("You swiftly slice fish open and bowel it.")
		var/adds = 0
		if(prob(10))
			adds = rand(1, rarity)
		for(var/obj/item/I in internals)
			for(var/i = 1, i<=internals[I]+adds, i++)
				new I(user.loc)
		qdel(src)*/
//Butchering of fishes i make later. And better than this sheeesh!


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/examine(mob/M as mob)
	..()
	if(size > 1000)
		M << SPAN_NOTE("Weight of that fish is <B>[size/1000] kg</B>.")
	else
		M << SPAN_NOTE("Weight of that fish is <B>[size] gr</B>.")
	switch(rarity)
		if(1) M << "<B><font color='#808080'> Common fish </font></B>"
		if(2) M << "<B><font color='#FF9900'> Big fish </font></B>"
		if(3) M << "<B><font color='#A2819E'> Rare fish </font></B>"
		if(4) M << "<B><font color='#FF00FF'> Legend fish </font></B>"


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander
	name = "sander"
	desc = "Tiny and famous fish. Almost useless. Too much bones and very bitter taste."
	icon_state = "sander"
	minSize = 40
	maxSize = 80
	sizeAdd = 20
	anomalySizeAdd = 40
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("blood", 3*rarity)



/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_dolphin
	name = "space dolphin"
	desc = "Small fish with blue soft glistening scales. You can see how she smiles."
	icon_state = "space_dolphin"
	minSize = 40
	maxSize = 150
	sizeAdd = 20
	anomalySizeAdd = 70
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("cryoxadone", 5*rarity)
		reagents.add_reagent("blood", 3*rarity)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_shellfish
	name = "space shellfish"
	desc = "Small fish with some kind of shell on her spine. But wait, that shell is living and not part of this fish."
	icon_state = "space_shellfish"
	minSize = 70
	maxSize = 220
	sizeAdd = 45
	anomalySizeAdd = 70
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("radium", 5*rarity)
		reagents.add_reagent("blood", 3*rarity)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_torped_shark
	name = "space torped shark"
	desc = "Small fish with grumpy head and gray colors."
	icon_state = "space_torped_shark"
	minSize = 120
	maxSize = 340
	sizeAdd = 80
	anomalySizeAdd = 110
	New()
		..()
		reagents.add_reagent("fish", 10*rarity)
		reagents.add_reagent("iron", 5*rarity)
		reagents.add_reagent("sulfur", 3*rarity)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_catfish
	name = "space catfish"
	desc = "Small chubby fish with whiskers on head and silk like fur at belly."
	icon_state = "space_catfish"
	minSize = 80
	maxSize = 210
	sizeAdd = 60
	anomalySizeAdd = 60
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("sugar", 5*rarity)
		reagents.add_reagent("blood", 3*rarity)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/iced_carp
	name = "iced carp"
	desc = "Small fish with six eyes and bloody cold skin."
	icon_state = "iced_carp"
	minSize = 40
	maxSize = 160
	sizeAdd = 35
	anomalySizeAdd = 20
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("frostoil", 5*rarity)
		reagents.add_reagent("blood", 3*rarity)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/bloodshell
	name = "bloodshell fish"
	desc = "Fish with some kind of soft shell on her back. Edges of this shell used for moving. This fish flowing above bottom."
	icon_state = "bloody_shell"
	minSize = 70
	maxSize = 310
	sizeAdd = 50
	anomalySizeAdd = 80
	New()
		..()
		reagents.add_reagent("fish", 5*rarity)
		reagents.add_reagent("blood", 10*rarity)





////////////////////______________]BAITS[_______________\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/reagent_containers/food/snacks/bug
	name = "Barksleeper"
	desc = "Small bug with hump on his back. You can try to eat that, but... Well.."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "barksleeper_bug"
	var/list/baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 80,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_dolphin = 40,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_catfish = 15)
	New()
		..()
		reagents.add_reagent("protein", 5)



/obj/item/weapon/reagent_containers/food/snacks/bug/firefly
	name = "Firefly"
	desc = "Small fly-like bug with glowing thorax. Feels hot. Looks like that thing are sleeping."
	icon_state = "firefly_bug"
	baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/iced_carp = 75,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 35)
	New()
		..()
		reagents.add_reagent("capsaicin", 5)



/obj/item/weapon/reagent_containers/food/snacks/bug/godeater
	name = "God eater"
	desc = "This medium-sized bug looks creepy with this strange skull. A bit heavyweight."
	icon_state = "godeater_bug"
	baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_torped_shark = 70,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 40)
	New()
		..()
		reagents.add_reagent("grapejuice", 10)



/obj/item/weapon/reagent_containers/food/snacks/bug/spore
	name = "Spore bug"
	desc = "This tiny bug actually is a spore. They living in the snow. You can see a red part, thermal plate that warm the bug even in the extreme cold."
	icon_state = "spore_bug"
	baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/bloodshell = 80,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 40)



/obj/item/weapon/reagent_containers/food/snacks/bug/snake
	name = "Snake"
	desc = "Green worm-like bug. Have three eyes and small mouth with tiny tooths that hard to see. Venomously."
	icon_state = "snake_bug"
	baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_shellfish = 80,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 40)
	New()
		..()
		reagents.add_reagent("cyanide", 10)



/obj/item/weapon/reagent_containers/food/snacks/bug/icespiderling
	name = "Ice spiderling"
	desc = "Tiny ice spider. They sets their webs into the bushes for hunting. Web of this creatures is very-very durable and strong enough."
	icon_state = "icespider_bug"
	baiting_fishes = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/sander = 60,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_catfish = 20)

/* //Later
/obj/item/weapon/reagent_containers/food/snacks/bug/byond
	name = "Byond bug"
	desc = "Woah. What kind of bug is it?"
	icon_state = "byond_bug"*/