//Experimental thing. Careful with that

//TODO:
//	Add forest random generation. Perlin noise or based on equator lines
//	Add river generation. A* of course
//	Add rocks generation. I think, bresenham only can handle this
//	Polish all the stuff

proc/snowyMapGeneration()

	//borders making
	for(var/y=1, world.maxy >= y, y++)
		for(var/x=1, world.maxx >= x, x++)
			if((y < 2 || y > world.maxy-1) || (x < 2 || x > world.maxx-1))
				var/turf/Border = locate(x, y, 1)
				Border.ChangeTurf(/turf/unsimulated/snow)
				new /obj/structure/flora/tree/dead(Border)

	snowyChunkInsert() //Insert chunks


	//Here will be rivers rocks random generation

	//forest generation. Temporary. Need to make through perlin noise
	for(var/y=1, world.maxy > y, y++)
		for(var/x=1, world.maxx > x, x++)
			var/turf/T = locate(x, y, 1)
			if(istype(T, /turf/simulated/floor/plating/snow/light_forest))
				var/turf/simulated/floor/plating/snow/light_forest/LF = T
				LF.forest_gen(25, list(/obj/structure/flora/snowytree), 10,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), rand(10, 20), rand(20, 60),
								list(/obj/structure/lootable/mushroom_hideout), 30,
								list(/obj/item/weapon/branches = 20, /obj/structure/rock = 3, /obj/structure/lootable/chunk = 2, /obj/structure/butcherable = "very rare"))




//there we insert our chunks into the map randomly
//i think rectangle packing algorithm is not needed here. So there's a simple version
//Looks stable and works fine with small maps

proc/snowyChunkInsert()
	var/list/usable_turfs = list()
	for(var/y=1, world.maxy > y, y++)
		for(var/x=1, world.maxx > x, x++)
			var/turf/T = locate(x, y, 1)
			if(istype(T, /turf/simulated/floor/plating/snow))
				if(T.contents.len == 0)
					usable_turfs.Add(T)

	usable_turfs = shuffle(usable_turfs)


	var/S = pick(snowy_map_templates)
	var/list/template_list = snowy_map_templates[S]

	var/chunk_placement_count = 0
	for(var/t in template_list)
		var/datum/snowy_template/ST = new t
		for(var/turf/start_point in usable_turfs) //This one can be slow, but reliable
			var/can_generate = 1
			var/startX = start_point.x
			var/startY = start_point.y
			var/turf/end_point = locate(startX+ST.sizeW, startY+ST.sizeH, 1)
			var/list/used_turfs = list()
			if(end_point in usable_turfs)
				for(var/y=startY, startY+ST.sizeH+1 >= y, y++) //this part can be slower, but checks existed objects too, that created by hands
					for(var/x=startX, startX+ST.sizeW+1 >= x, x++)
						var/turf/T = locate(x, y, 1)
						used_turfs.Add(T) //memorized used turfs
						if(!(istype(T, /turf/simulated/floor/plating/snow)) || !(T.contents.len == 0))
							can_generate = 0
			else
				can_generate = 0
			if(can_generate)
				for(var/turf/T in used_turfs) // now remove used turfs from general pool
					usable_turfs.Remove(T)
				snowyLoadChunk(ST.map_file, startX, startY, 1)
				chunk_placement_count++
				break
	spawn(30)
		world << SPAN_NOTE("First step done! [chunk_placement_count]/[template_list.len] chunks placed.")
		world << SPAN_NOTE("<BIG>Current scenario: <b>[S]</b></BIG>")


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