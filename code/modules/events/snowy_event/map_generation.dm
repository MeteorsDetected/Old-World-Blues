//Experimental thing. Careful with that

//TODO:
//	Add forest random generation. Perlin noise or based on equator lines
//	Polish all the stuff

proc/snowyMapGeneration()

	var/list/usable_turfs = list()

	//borders making
	for(var/y=1, world.maxy >= y, y++)
		for(var/x=1, world.maxx >= x, x++)
			if((y < 2 || y > world.maxy-1) || (x < 2 || x > world.maxx-1))
				var/turf/Border = locate(x, y, 1)
				Border.ChangeTurf(/turf/unsimulated/snow)
				new /obj/structure/flora/tree/dead(Border)
			else
				var/turf/T = locate(x, y, 1)
				if(istype(T, /turf/simulated/floor/plating/snow))
					if(T.contents.len == 0)
						usable_turfs.Add(T)
	usable_turfs = shuffle(usable_turfs)


	//Here will be rivers rocks random generation
	var/river_count = riverGeneration(usable_turfs, 40, 10, "big", 5)
	spawn(30)
		world << SPAN_NOTE("<BIG>Water pool created. <b>[river_count]<b> turfs.</BIG>")

	var/chasm_counts = chasmAndRocksGeneration(usable_turfs, 0, 20, 2, 3) //chasms
	spawn(30)
		world << SPAN_NOTE("<BIG>Dreadful chasm created. Beware! <b>[chasm_counts]<b> turfs.</BIG>")

	var/rocks_counts = chasmAndRocksGeneration(usable_turfs, 1, 20, 2, 7) //rocks
	spawn(30)
		world << SPAN_NOTE("<BIG>Tall rocks added. Tons of minerals or no luck? <b>[rocks_counts]<b> turfs.</BIG>")

	usable_turfs = snowyChunkInsert(usable_turfs) //Insert chunks



	//forest generation. Temporary. Need to make through perlin noise
	var/biome_equator_num = Floor(world.maxx/3)
	for(var/i=1, 3 >= i, i++)
		for(var/y=biome_equator_num*i-biome_equator_num, biome_equator_num*i > y, y++)
			for(var/x=1, world.maxx > x, x++)
				var/turf/T = locate(x, y, 1)
				if(istype(T, /turf/simulated/floor/plating/snow/light_forest))
					var/turf/simulated/floor/plating/snow/light_forest/LF = T
					switch(i)
						if(1)
							LF.forest_gen(25, list(/obj/structure/flora/snowytree), 10,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), rand(10, 20), rand(20, 60),
								list(/obj/structure/lootable/mushroom_hideout), 30,
								list(/obj/item/weapon/branches = 20, /obj/structure/rock = 3, /obj/structure/lootable/chunk = 2, /obj/structure/butcherable = "very rare"))
						if(2)
							LF.forest_gen(20, list(/obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 40,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), 10, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable/chunk = 2, /obj/structure/butcherable = "very rare"))
						if(3)
							LF.forest_gen(40, list(/obj/structure/flora/snowytree/high, /obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 35,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable/chunk = 2, /obj/structure/butcherable = "very rare"))




//there we insert our chunks into the map randomly
//i think rectangle packing algorithm is not needed here. So there's a simple version
//Looks stable and works fine with small maps

proc/snowyChunkInsert(var/list/usables = list())


	var/S = pick(snowy_map_templates)
	var/list/template_list = snowy_map_templates[S]

	var/chunk_placement_count = 0
	for(var/t in template_list)
		var/datum/snowy_template/ST = new t
		for(var/turf/start_point in usables) //This one can be slow, but reliable
			var/can_generate = 1
			var/startX = start_point.x
			var/startY = start_point.y
			var/turf/end_point = locate(startX+ST.sizeW, startY+ST.sizeH, 1)
			var/list/used_turfs = list()
			if(end_point in usables)
				for(var/y=startY, startY+ST.sizeH+1 >= y, y++) //this part can be slower, but checks existed objects too, that created by hands
					for(var/x=startX, startX+ST.sizeW+1 >= x, x++)
						var/turf/T = locate(x, y, 1)
						used_turfs.Add(T) //memorized used turfs
						if((!(istype(T, /turf/simulated/floor/plating/snow)) && !(istype(T, /turf/simulated/floor/plating/ice)) && !(istype(T, /turf/simulated/rock)) && !(istype(T, /turf/simulated/floor/plating/chasm))) || !(T.contents.len == 0))
							can_generate = 0
			else
				can_generate = 0
			if(can_generate)
				for(var/turf/T in used_turfs) // now remove used turfs from general pool
					usables.Remove(T)
				snowyLoadChunk(ST.map_file, startX, startY, 1)
				chunk_placement_count++
				break
	spawn(30)
		world << SPAN_NOTE("Chunks loaded! [chunk_placement_count]/[template_list.len] chunks placed.")
		world << SPAN_NOTE("<BIG>Current scenario: <b>[S]</b></BIG>")

	return usables


//Yes. This is a rude copy from dmm_suite. I just dont want to change the original proc, so i make it here
//This one takes the map chunk and place it on the map
//Not tested with z levels, so use this careful
//Dont forget, map starts from left lower corner!
//TO-DO: clean this part of code and remove unused lines

proc/snowyLoadChunk(var/dmm_file as file, var/startx as num, var/starty as num, var/z_level as num)
	if(!startx || !starty)
		return
	if(!z_level)
		z_level = 1

	var/quote = ascii2text(34)
	var/tfile = file2text(dmm_file)//the map file we're creating
	var/tfile_len = length(tfile)
	var/lpos = 1 // the models definition index

	///////////////////////////////////////////////////////////////////////////////////////
	//first let's map model keys (e.g "aa") to their contents (e.g /turf/space{variables})
	///////////////////////////////////////////////////////////////////////////////////////
	var/list/grid_models = list()
	var/key_len = length(copytext(tfile,2,findtext(tfile,quote,2,0)))//the length of the model key (e.g "aa" or "aba")

	//proceed line by line
	for(lpos=1; lpos<tfile_len; lpos=findtext(tfile,"\n",lpos,0)+1)
		var/tline = copytext(tfile,lpos,findtext(tfile,"\n",lpos,0))
		if(copytext(tline,1,2) != quote)//we reached the map "layout"
			break
		var/model_key = copytext(tline,2,2+key_len)
		var/model_contents = copytext(tline,findtext(tfile,"=")+3,length(tline))
		grid_models[model_key] = model_contents
		sleep(-1)

	///////////////////////////////////////////////////////////////////////////////////////
	//now let's fill the map with turf and objects using the constructed model map
	///////////////////////////////////////////////////////////////////////////////////////

	//position of the currently processed square
	var/ycrd = 0
	var/xcrd = 0

	for(var/zpos=findtext(tfile,"\n(1,1,",lpos,0);zpos!=0;zpos=findtext(tfile,"\n(1,1,",zpos+1,0))	//in case there's several maps to load


		var/zgrid = copytext(tfile,findtext(tfile,quote+"\n",zpos,0)+2,findtext(tfile,"\n"+quote,zpos,0)+1) //copy the whole map grid
		var/z_depth = length(zgrid)

		//if exceeding the world max x or y, increase it
		var/x_depth = length(copytext(zgrid,1,findtext(zgrid,"\n",2,0)))
		if(world.maxx<x_depth)
			world.maxx=x_depth

		var/y_depth = z_depth / (x_depth+1)//x_depth + 1 because we're counting the '\n' characters in z_depth
		if(world.maxy<y_depth)
			world.maxy=y_depth

		//then proceed it line by line, starting from top
		ycrd = y_depth+starty

		for(var/gpos=1;gpos!=0;gpos=findtext(zgrid,"\n",gpos,0)+1)
			var/grid_line = copytext(zgrid,gpos,findtext(zgrid,"\n",gpos,0))

			//fill the current square using the model map
			xcrd=startx
			if(xcrd > world.maxx || ycrd > world.maxy)
				return
			for(var/mpos=1;mpos<=x_depth;mpos+=key_len)
				xcrd++
				var/model_key = copytext(grid_line,mpos,mpos+key_len)
				maploader.parse_grid(grid_models[model_key],xcrd,ycrd,1)

			//reached end of current map
			if(gpos+x_depth+1>z_depth)
				break

			ycrd--

			sleep(-1)

		//reached End Of File
		if(findtext(tfile,quote+"}",zpos,0)+2==tfile_len)
			break
		sleep(-1)


//river generation
//Dirty and shitty. I don't use any algorithm, only leapfrog of lists and bresenham. I'm too lazy to write perlin noize here. So meeeh
//Interpolation not used too, i smooth corners with a simple method of fill and prob()
//Looks ugly, but it's ok. Maybe later i make a perlin noise here or find a good library and rewrite this, but for now - lazy and tons of tasks
proc/riverGeneration(var/list/usables = list(), var/min_length = 30, var/distortion_radius = 10, var/river_type = "big", var/outfalls = 0, var/turf/start = null)
	if(start == null)
		start = pick(usables)
	var/turf/end = null
	for(var/turf/T in usables)
		if(T != start && get_dist(start, T) > 30)
			end = T
			break
	if(end == null)
		return //no river for you :(  (That means there's a bug

	var/list/path = getline(start, end) //creating raw stuff, a simple line
	var/list/distorted_path = list()
	var/C = 2
	for(var/turf/cross_point in path) //takes every third point
		C++
		if(C == 3)
			distorted_path.Add(cross_point)
			C = 0
	var/midpoint_count = 1
	var/list/temPath = list()
	for(var/turf/distorted in distorted_path) //distort the midpoint(every second)
		midpoint_count++
		if(midpoint_count == 2)
			var/count = 1
			while(count < 30)
				var/randX = rand(distorted.x-distortion_radius, distorted.x+distortion_radius)
				var/randY = rand(distorted.y-distortion_radius, distorted.y+distortion_radius)
				var/turf/candidate = locate(randX, randY, 1)
				if(istype(candidate, /turf/simulated/floor/plating/snow))
					temPath.Add(candidate)
					break
				count++
			midpoint_count = 0
		else
			temPath.Add(distorted)
			continue

	path = list()
	for(var/i=1, temPath.len > i, i++) //going through the list with distorted points and make the another bresenham's line between them
		var/turf/first = temPath[i]
		var/turf/second = temPath[i+1]
		if(second == null)
			path.Add(first)
			break
		var/list/turfs = getline(first, second)
		for(var/turf/I in turfs)
			path.Add(I)


	var/riverCount = path.len
	for(var/turf/Point in path) //path is ready, now create points from list and smooth corner (this method is not a panacea)
		Point.ChangeTurf(/turf/simulated/floor/plating/ice)
		riverCount++
		if(river_type == "big") //well, i make better smoothing later maybe
			for(var/D in alldirs)
				var/turf/S = get_step(Point, D)
				if(istype(S, /turf/simulated/floor/plating/snow) && S.contents.len == 0)
					if(prob(70)) //a little randomize them
						S.ChangeTurf(/turf/simulated/floor/plating/ice)
						riverCount++

	//now add the outfalls of river
	if(outfalls > 0)
		for(var/i=1, outfalls >= i, i++)
			var/rcount = riverGeneration(usables, 15, 5, "thin", 0, pick(temPath))
			riverCount += rcount

	return riverCount


proc/chasmAndRocksGeneration(var/list/usables = list(), var/spawn_type = 1, var/min_length = 30, var/min_radius = 1, var/max_radius = 1)
	var/counter = 0

	var/turf/start = null
	var/turf/end = null
	for(var/turf/T in usables)
		if(!istype(T, /turf/simulated/floor/plating/chasm) && !istype(T, /turf/simulated/floor/plating/ice) && !istype(T, /turf/simulated/rock))
			if(!start)
				start = T
			if(get_dist(T, start) > min_length && (T != start) && (T != null))
				end = T
	if((end == null) || (start == null))
		return

	var/list/path = getline(start, end)

	for(var/turf/T in path)
		var/radius = rand(min_radius, max_radius)+1
		for(var/y=T.y-radius, T.y+radius >= y, y++)
			for(var/x=T.x-radius, T.x+radius >= x, x++)
				if((x >= world.maxx) || (y >= world.maxy) || (x <= 0) || (y <= 0))
					continue
				var/turf/Here = locate(x, y, 1)
				if(get_dist(T, Here) <= radius-1)
					if(spawn_type)
						if(!istype(Here, /turf/simulated/floor/plating/chasm) && !istype(Here, /turf/simulated/floor/plating/ice) && !istype(Here, /turf/simulated/rock))
							Here.ChangeTurf(/turf/simulated/rock)
							counter++
					else
						Here.ChangeTurf(/turf/simulated/floor/plating/chasm)
						counter++
	return counter

///////////////>>>TEMPLATES<<<\\\\\\\\\\\\\\\
//Urgent templates place in scenario set first
//Make sure that sizes of template and datum has match

var/list/snowy_map_templates = list(
	"Silent trees" = list(/datum/snowy_template/oldvillage, /datum/snowy_template, /datum/snowy_template),
	"Old lake" = list(/datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template, /datum/snowy_template),
	)


/datum/snowy_template
	var/name = "ruins"
	var/map_file = 'maps/snowy_templates/testbox.dmm'
	var/sizeW = 10
	var/sizeH = 10

/datum/snowy_template/oldvillage
	name = "old village"
	map_file = 'maps/snowy_templates/old_village.dmm'
	sizeW = 20
	sizeH = 30