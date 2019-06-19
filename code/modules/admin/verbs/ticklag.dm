//Merged Doohl's and the existing ticklag as they both had good elements about them ~Carn

/client/proc/set_fps()
	set category = "Debug"
	set name = "Set FPS"
	set desc = "Sets a new fps"

	if(!check_rights(R_DEBUG))
		return

	var/newfps = input("Sets a new fps","Frame per second", world.fps) as num|null
	//I've used ticks of 2 before to help with serious singulo lags
	if(newfps && newfps <= 100 && newfps > 14)
		log_admin("[key_name(src)] has modified world.fps to [newfps]")
		world.fps = newfps
	else
		src << SPAN_WARN("Error: set_fps(): Invalid world.fps value. No changes made.")


