/**
  * StonedMC
  *
  * Designed to properly split up a given tick among subsystems
  * Note: if you read parts of this code and think "why is it doing it that way"
  * Odds are, there is a reason
  *
 **/

//This is the ABSOLUTE ONLY THING that should init globally like this
GLOBAL_REAL(Master, /datum/controller/master) = new

//THIS IS THE INIT ORDER
//Master -> SSPreInit -> GLOB -> world -> config -> SSInit -> Failsafe
//GOT IT MEMORIZED?

/datum/controller/master
	name = "Master"

	// Are we processing (higher values increase the processing delay by n ticks)
	var/processing = TRUE
	// How many times have we ran
	var/iteration = 0

	// world.time of last fire, for tracking lag outside of the mc
	var/last_run

	// List of subsystems to process().
	var/list/subsystems

	// Vars for keeping track of tick drift.
	var/init_timeofday
	var/init_time
	var/tickdrift = 0

	var/sleep_delta = 1

	var/make_runtime = 0

	var/initializations_finished_with_no_players_logged_in	//I wonder what this could be?

	// The type of the last subsystem to be process()'d.
	var/last_type_processed

	var/datum/controller/subsystem/queue_head //Start of queue linked list
	var/datum/controller/subsystem/queue_tail //End of queue linked list (used for appending to the list)
	var/queue_priority_count = 0 //Running total so that we don't have to loop thru the queue each run to split up the tick
	var/queue_priority_count_bg = 0 //Same, but for background subsystems
	var/map_loading = FALSE	//Are we loading in a new map?

	var/current_runlevel	//for scheduling different subsystems for different stages of the round
	var/sleep_offline_after_initializations = TRUE

	var/static/restart_clear = 0
	var/static/restart_timeout = 0
	var/static/restart_count = 0

	var/static/random_seed

	//current tick limit, assigned before running a subsystem.
	//used by CHECK_TICK as well so that the procs subsystems call can obey that SS's tick limits
	var/static/current_ticklimit = TICK_LIMIT_RUNNING

/datum/controller/master/New()
	if(!config)
		config = new
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.

	if(!random_seed)
		random_seed = (TEST_RUN_PARAMETER in world.params) ? 29051994 : rand(1, 1e9)
		rand_seed(random_seed)

	var/list/_subsystems = list()
	subsystems = _subsystems
	if (Master != src)
		if (istype(Master))
			Recover()
			qdel(Master)
		else
			var/list/subsytem_types = subtypesof(/datum/controller/subsystem)
			sortTim(subsytem_types, /proc/cmp_subsystem_init)
			for(var/I in subsytem_types)
				_subsystems += new I
		Master = src

	if(!GLOB)
		new /datum/controller/global_vars

/datum/controller/master/Destroy()
	..()
	// Tell qdel() to Del() this object.
	return QDEL_HINT_HARDDEL_NOW

