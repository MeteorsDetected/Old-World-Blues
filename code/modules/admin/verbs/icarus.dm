ADMIN_VERB_ADD(/client/proc/FireCannons, R_SPAWN)
/client/proc/FireCannons()
	set name = "Fire the Icarus cannons"
	set desc = "Fires an explosive missile at your position.  You should only do this as a(n) (a)ghost."
	set category = "Fun"

	var/turf/target = get_turf(src.mob)
	log_and_message_admins("has fired the Icarus main gun projectile at [target.x]-[target.y]-[target.z]")
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	Icarus_FireCannon(target)


ADMIN_VERB_ADD(/client/proc/ChangeIcarusPosition, R_SPAWN)
/client/proc/ChangeIcarusPosition()
	set name = "Adjust Icarus Position"
	set desc = "Lets you chose the position of the Icarus in regards to the map."
	set category = "Fun"

	log_and_message_admins("is changing the Icarus position.")
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	Icarus_SetPosition(src)

var/icarus_position = SOUTH

proc/Icarus_FireCannon(var/turf/target)
	// Find the world edge to fire from.
	var/x = icarus_position & EAST ? world.maxx : icarus_position & WEST ? 1 : target.x
	var/y = icarus_position & NORTH ? world.maxy : icarus_position & SOUTH ? 1 : target.y
	var/x_off = x != target.x ? abs(target.x - x) : INFINITY
	var/y_off = y != target.y ? abs(target.y - y) : INFINITY
	// Get the minimum number of steps using the rise/run shit.
	var/iterations = round(min(x_off, y_off)) - 14 // We cannot fire straight from the edge since teleport thing.

	// Now we can get the location of the start.
	x = target.x + (icarus_position & EAST ? iterations : icarus_position & WEST ? -iterations : 0)
	y = target.y + (icarus_position & NORTH ? iterations : icarus_position & SOUTH ? -iterations : 0)

	var/turf/start = locate(x, y, target.z)

	// Now we find the corresponding turf on the other side of the level.
	// Yeah, yeah.  Overuse of the terinary operator.  So sue me.
	x = icarus_position & EAST ? 1 : icarus_position & WEST ? world.maxx : target.x
	y = icarus_position & NORTH ? 1 : icarus_position & SOUTH ? world.maxy : target.y
	x_off = x != target.x ? abs(target.x - x) : INFINITY
	y_off = y != target.y ? abs(target.y - y) : INFINITY
	iterations = round(min(x_off, y_off))
	x = target.x + (icarus_position & EAST ? -iterations : icarus_position & WEST ? iterations : 0)
	y = target.y + (icarus_position & NORTH ? -iterations : icarus_position & SOUTH ? iterations : 0)
	target = locate(x, y, target.z)

	// Finally fire the fucker.
	var/obj/effect/meteor/small/projectile = new (start)
	projectile.dest = target
	projectile.name = "main gun projectile" // stealthy
	projectile.hits = 6
	projectile.detonation_chance = 99 // it's a missile/cannon round thing!

	// Make sure it travels
	spawn(0)
		walk_towards(projectile, projectile.dest, 1)

proc/Icarus_SetPosition(var/user)
	var/global/list/directions = list("North" = 1, "North East" = 5, "East" = 4, "South East" = 6, "South" = 2, "South West" = 10, "West" = 8, "North West" = 9)
	var/direction = input(user, "Where should the Icarus fire from?", "Icarus Comms") as null|anything in directions
	if(!direction)
		return

	icarus_position = directions[direction]
