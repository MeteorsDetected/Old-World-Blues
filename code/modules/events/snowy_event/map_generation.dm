//Experimental thing. Careful with that

//TODO:
//	Polish all the stuff
//	Add options to templates sets. And base it on map size
//	Split forest onto biomes
//	Add cave generation?

proc/snowyMapGeneration()
	var/S = pick(scenarios)
	var/datum/snowy_scenario/Scenario = new S

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

	var/chasm_counts = 0
	for(var/list/C in Scenario.options)
		if(C["chasm"])
			chasm_counts = chasmAndRocksGeneration(C["type"], C["length"], C["min_radius"], C["max_radius"]) //chasms
	if(chasm_counts)
		spawn(30)
			world << SPAN_NOTE("<BIG>Dreadful chasm created. Beware! <b>[chasm_counts]<b> turfs.</BIG>")
	else
		spawn(30)
			world << SPAN_WARN("<BIG>There's no chasms! Relax.</BIG>")


	usable_turfs = snowyChunkInsert(usable_turfs, Scenario) //Insert chunks

	var/rocks_counts = 0
	var/river_count = 0
	for(var/list/R in Scenario.options)
		if(R["rocks"])
			rocks_counts = chasmAndRocksGeneration(R["type"], R["length"], R["min_radius"], R["max_radius"]) //rocks
		else if(R["river"])
			river_count = riverGeneration(R["length"], R["distortion"], R["type"], R["outfalls"])

	if(rocks_counts)
		spawn(30)
			world << SPAN_NOTE("<BIG>Tall rocks added. Tons of minerals or no luck? <b>[rocks_counts]<b> turfs.</BIG>")
	else
		spawn(30)
			world << SPAN_WARN("<BIG>There's no rocks! A big problem.</BIG>")

	spawn(30)
		if(river_count)
			world << SPAN_NOTE("<BIG>Water pool created. <b>[river_count]<b> turfs.</BIG>")
		else
			world << SPAN_WARN("<BIG>There's no rivers!</BIG>")



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

	new /datum/random_map(null,1,1,1,world.maxx,world.maxy)
	new /datum/random_map/ore(null,1,1,1,world.maxx,world.maxy)




//there we insert our chunks into the map randomly
//i think rectangle packing algorithm is not needed here. So there's a simple version
//Looks stable and works fine with small maps

proc/snowyChunkInsert(var/list/usables = list(), var/datum/snowy_scenario/Scenario)


	var/chunk_placement_count = 0
	for(var/t in Scenario.templates)
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
						if((!(istype(T, /turf/simulated/floor/plating/snow)) && !(istype(T, /turf/simulated/floor/plating/ice)) && !(istype(T, /turf/unsimulated/mask)) && !(istype(T, /turf/simulated/floor/plating/chasm))) || !(T.contents.len == 0))
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
		world << SPAN_NOTE("Chunks loaded! [chunk_placement_count]/[Scenario.templates.len] chunks placed.")
		world << SPAN_NOTE("<BIG>Current scenario: <b>[Scenario.name]</b></BIG>")

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
proc/riverGeneration(var/min_length = 30, var/distortion_radius = 10, var/river_type = "thin", var/outfalls = 0, var/turf/start = null, var/turf/end = null)
	if((min_length >= world.maxx-10) || (min_length >= world.maxy-10)) //length is too big
		min_length = (world.maxx+world.maxy)/2-20

	var/list/usables = getPossiblePoints(min_length)
	usables = shuffle(usables)

	if(!end)
		for(var/turf/T in usables)
			if(!start)
				start = T
			if((T != start) && (getDistance(start, T) >= min_length) && istype(T, /turf/simulated/floor/plating/snow))
				end = T
				break
		if(end == null)
			return  //no river for you :(  (Map too small or just no luck

	var/list/path = getline(start, end) //creating raw stuff, a simple line
	var/list/distorted_path = list()
	var/dis_count = 2
	var/dis_target = 3
	var/midpoint_target = 2

	if(min_length >= 30)
		dis_target = dis_target*2
		dis_count = dis_target-1
		midpoint_target = midpoint_target*2

	for(var/turf/cross_point in path) //takes every third or nine point
		dis_count++
		if(dis_count == dis_target)
			distorted_path.Add(cross_point)
			dis_count = 0
	var/midpoint_count = 1
	var/list/temPath = list()
	for(var/turf/distorted in distorted_path) //distort the midpoint(every second)
		midpoint_count++
		if(midpoint_count == midpoint_target)
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
	for(var/turf/Point in path) //path is ready, now create points from list and smooth corners
		if(istype(Point, /turf/simulated/floor/plating/snow))
			Point.ChangeTurf(/turf/simulated/floor/plating/ice)
			riverCount++
			var/next = 0 //small loop controller. If we reach needed condition, we just skip all of that to next point in path
			if(river_type == "thin")
				for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
					if(next)
						break
					var/turf/S = get_step(Point, D)
					if(istype(S, /turf/simulated/floor/plating/ice))
						for(var/c in cardinal) //maybe we have ice here? Let's check it
							var/turf/I = get_step(Point, c)
							if(istype(I, /turf/simulated/floor/plating/ice))
								next = 1
								break
						if(!next)
							var/list/A = getAdjacentDir(D) // no ice, smooth the corner
							if((A != null) && (A.len > 0))
								for(var/t in A)
									var/turf/P = get_step(Point, t)
									if(istype(P, /turf/simulated/floor/plating/snow))
										P.ChangeTurf(/turf/simulated/floor/plating/ice)
										riverCount++
										break
			else if(river_type == "big")
				for(var/d in alldirs)
					if(prob(90))
						var/turf/S = get_step(Point, d)
						if((S != null) && (istype(S, /turf/simulated/floor/plating/snow)))
							S.ChangeTurf(/turf/simulated/floor/plating/ice)
							riverCount++

	//now add the outfalls of river
	if(outfalls > 0)
		for(var/i=1, outfalls >= i, i++)
			var/turf/start_point = pick(temPath)
			var/turf/end_point = null
			for(var/d in alldirs)
				var/turf/T = get_step(start_point, d)
				if(istype(T, /turf/simulated/floor/plating/ice))
					var/angle = dir2angle(d)
					if(prob(50))
						angle += 30
					else
						angle += -30
					if(prob(50))
						angle += 90
					else
						angle += -90
					var/target_dir = angle2dir(angle)
					end_point = get_ranged_target_turf(start_point, target_dir, rand(Floor(min_length/3), Floor(min_length/2)))
					if(end_point && istype(end_point, /turf/simulated/floor/plating/snow))
						break

			var/rcount = riverGeneration(min_length/2, distortion_radius/2, "thin", 0, pick(temPath), end_point)
			riverCount += rcount

	return riverCount


proc/chasmAndRocksGeneration(var/spawn_type = 1, var/min_length = 30, var/min_radius = 1, var/max_radius = 1)
	var/counter = 0
	if((min_length >= world.maxx-10) || (min_length >= world.maxy-10))
		min_length = (world.maxx+world.maxy)/2-20

	var/list/usables = getPossiblePoints(min_length)
	usables = shuffle(usables)
	var/turf/start = null
	var/turf/end = null
	for(var/turf/T in usables)
		if(istype(T, /turf/simulated/floor/plating/snow))
			if(!start)
				start = T
			if((getDistance(start, T) >= min_length) && (T != start) && (T != null))
				end = T
	if((end == null) || (start == null))
		return

	var/list/path = getline(start, end)

	for(var/i=1, path.len >= i, i++)
		var/turf/T = path[i]
		if(prob(25))
			continue
		var/radius = rand(min_radius, max_radius)+1
		if(radius < 1)
			radius = 1
		var/list/circle_turfs = circlerange(T, radius)
		for(var/turf/Here in circle_turfs)
			if(Here != null)
				if(spawn_type)
					if(istype(Here, /turf/simulated/floor/plating/snow))
						Here.ChangeTurf(/turf/unsimulated/mask)
						counter++
				else
					Here.ChangeTurf(/turf/simulated/floor/plating/chasm)
					counter++
	return counter


//helper
//takes dir and return adjacent directions
//didn't find this proc, so write my own
proc/getAdjacentDir(var/dir)
	var/list/dirs_by_rotate = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
	for(var/i=1, dirs_by_rotate.len >= i, i++)
		if(dir == dirs_by_rotate[i])
			var/first
			var/second
			if(i == 1)
				first = dirs_by_rotate[dirs_by_rotate.len]
			else if(i == dirs_by_rotate.len)
				second = dirs_by_rotate[1]
			if(!first)
				first = dirs_by_rotate[i-1]
			if(!second)
				second = dirs_by_rotate[i+1]
			return list(first, second)


proc/getPossiblePoints(var/length)
	var/list/points = list()
	for(var/y=2, world.maxy-2 >= y, y++)
		for(var/x=2, world.maxx-2 >= x, x++)
			if((y < length || y > world.maxy-length) || (x < length || x > world.maxx-length))
				var/turf/T = locate(x, y, 1)
				points.Add(T)
	return points

//Default get_dist have cap at 127
//So i write here my own. Didn't found another. Maybe just failed my search
proc/getDistance(var/turf/S, var/turf/E)
	if(S && E)
		return sqrt((S.x-E.x)*(S.x-E.x) + (S.y-E.y)*(S.y-E.y))


///////////////>>>TEMPLATES<<<\\\\\\\\\\\\\\\
//Urgent templates place in scenario set first
//Make sure that sizes of template and datum has match

var/list/scenarios = list(/datum/snowy_scenario, /datum/snowy_scenario/silent_trees)

/datum/snowy_scenario
	var/name = "Old lake"
	var/list/templates = list(/datum/snowy_template/oldvillage, /datum/snowy_template, /datum/snowy_template)
	var/list/options = list(	list("river" = 1, "length" = 95, "distortion" = 15, "type" = "big", "outfalls" = 4),
								list("river" = 1, "length" = 120, "distortion" = 10, "type" = "big", "outfalls" = 7),
								list("rocks" = 1, "type" = 1, "length" = 195, "min_radius" = 1, "max_radius" = 15),
								list("chasm" = 1, "type" = 0, "length" = 135, "min_radius" = 1, "max_radius" = 9)
							)

/datum/snowy_scenario/silent_trees
	name = "Silent trees"
	templates = list(/datum/snowy_template, /datum/snowy_template, /datum/snowy_template,
					/datum/snowy_template, /datum/snowy_template, /datum/snowy_template)
	options = list(		list("river" = 1, "length" = 95, "distortion" = 15, "type" = "big", "outfalls" = 4),
						list("river" = 1, "length" = 120, "distortion" = 10, "type" = "big", "outfalls" = 7),
						list("rocks" = 1, "type" = 1, "length" = 195, "min_radius" = 1, "max_radius" = 15),
						list("chasm" = 1, "type" = 0, "length" = 135, "min_radius" = 1, "max_radius" = 9)
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