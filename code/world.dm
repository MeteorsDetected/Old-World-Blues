#if DM_VERSION < 511
#warn This compiler is out of date. You may experience issues with projectile animations.
#endif



//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"
	name = "Old World Blues"
	hub_password = "kMZy3U5jJHSiBQjr"

/world/proc/registrate_verbs()

