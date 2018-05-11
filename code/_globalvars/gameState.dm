var/global/datum/universal_state/universe = new

var/global/defer_powernet_rebuild = 0      // True if net rebuild will be called manually after an event.

var/going             = 1.0

var/gravity_is_on = 1

var/event       = 0
var/hadevent    = 0
var/blobevent   = 0

var/game_year      = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/datum/sun/sun                   = null

