//Fishes from fishing here, take a look.

// dont use this
/obj/item/weapon/reagent_containers/food/snacks/fish
	name = "fish"
	desc = "dat fish"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "dat_fish"
	w_class = ITEM_SIZE_TINY
	var/size
	var/minSize = 80
	var/maxSize = 220
	var/sizeAdd = 40
	var/anomalySizeAdd = 40
	var/rarity		//1 - common, reagents *1/ 2 - big(100%), reagents *2/ 3 - rare(200%), reagents *3 / 4 - legend(300%), you know what you got
	var/list/liked_baits = list(	/obj/item/weapon/lipstick,
									/obj/item/weapon/pen
								)
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	New()
		..()
		size = rand(minSize, maxSize) + rand(sizeAdd)
		w_class = ITEM_SIZE_SMALL
		if(prob(20))
			size += anomalySizeAdd
			name = "anomaly sized [name]"
			w_class = ITEM_SIZE_NORMAL
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
		src.bitesize = 3*rarity

/obj/item/weapon/reagent_containers/food/snacks/fish/examine()
	.=..()
	if(size > 1000)
		usr << "\blue Weight of that fish is <B>[size/1000] kg</B>."
	else
		usr << "\blue Weight of that fish is <B>[size] gr</B>."
	switch(rarity)
		if(1) usr << "<B><font color='#808080'> Common fish </font></B>"
		if(2) usr << "<B><font color='#FF9900'> Big fish </font></B>"
		if(3) usr << "<B><font color='#A2819E'> Rare fish </font></B>"
		if(4) usr << "<B><font color='#FF00FF'> Legend fish </font></B>"

/obj/item/weapon/reagent_containers/food/snacks/fish/space_dolphin
	name = "space dolphin"
	desc = "Small fish with blue soft glistening scales. You can see how she smiles."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "space_dolphin"
	minSize = 40
	maxSize = 150
	sizeAdd = 20
	anomalySizeAdd = 70
	New()
		..()
		reagents.add_reagent("nutriment", 10*rarity)
		reagents.add_reagent("carpotoxin", 5*rarity)
		reagents.add_reagent("cryoxadone", 10*rarity)
		src.bitesize = 3*rarity


/obj/item/weapon/reagent_containers/food/snacks/fish/space_shellfish
	name = "space shellfish"
	desc = "Small fish with big head and some shells on her neck. She look little chubby."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "space_shellfish"
	minSize = 70
	maxSize = 220
	sizeAdd = 45
	anomalySizeAdd = 70
	New()
		..()
		reagents.add_reagent("nutriment", 15*rarity)
		reagents.add_reagent("carpotoxin", 5*rarity)
		reagents.add_reagent("radium", 10*rarity)
		src.bitesize = 2*rarity


/obj/item/weapon/reagent_containers/food/snacks/fish/space_torped_shark
	name = "space torped shark"
	desc = "Small fish with grumpy head and gray colors."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "space_torped_shark"
	minSize = 120
	maxSize = 340
	sizeAdd = 80
	anomalySizeAdd = 110
	New()
		..()
		reagents.add_reagent("nutriment", 5*rarity)
		reagents.add_reagent("carpotoxin", 10*rarity)
		reagents.add_reagent("iron", 15*rarity)
		src.bitesize = 3*rarity


/obj/item/weapon/reagent_containers/food/snacks/fish/space_catfish
	name = "space catfish"
	desc = "Small chubby fish with whiskers on head and silk like fur at belly."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "space_catfish"
	minSize = 80
	maxSize = 210
	sizeAdd = 60
	anomalySizeAdd = 60
	New()
		..()
		reagents.add_reagent("nutriment", 20*rarity)
		reagents.add_reagent("carpotoxin", 10*rarity)
		src.bitesize = 1*rarity

