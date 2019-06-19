//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

var/global/atomInstantInitialize = FALSE

/datum/controller/game_controller
	var/list/late_loaders

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(master_controller))
			qdel(master_controller)
		master_controller = src

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		admin_notice("<span class='danger'>Job setup complete</span>", R_DEBUG)

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

/datum/controller/game_controller/proc/setup()
	world.fps = config.fps

	spawn(20)
		createRandomZlevel()

	setup_objects()
	SetupXenoarch()

	transfer_controller = new


/datum/controller/game_controller/proc/setup_objects()
	sleep(-1)
	initializeAtoms()

	admin_notice("<span class='danger'>Initializing areas</span>", R_DEBUG)
	sleep(-1)
	for(var/area/area in all_areas)
		area.initialize()

	admin_notice("<span class='danger'>Initializing pipe networks</span>", R_DEBUG)
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

	admin_notice("<span class='danger'>Initializing atmos machinery.</span>", R_DEBUG)
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	sleep(-1)
	// Create the mining ore distribution map.
	if(config.generate_asteroid)
		for(var/level in maps_data.asteroid_leves)
			new /datum/random_map(null,13,32,level,217,223)
			new /datum/random_map/ore(null,13,32,level,217,223)

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	admin_notice("<span class='danger'>Initializations complete.</span>", R_DEBUG)
	sleep(-1)

/datum/controller/game_controller/proc/initializeAtoms()
	admin_notice("<span class='danger'>Initializing objects</span>", R_DEBUG)
	var/list/atoms = world.contents.Copy()
	atomInstantInitialize = TRUE

	var/count = 0
	for(var/atom/movable/A in atoms)
		initAtom(A, TRUE)
		++count
	admin_notice(SPAN_DANG("Initialized [count] atoms"), R_DEBUG)

	if(late_loaders && late_loaders.len)
		for(var/I in late_loaders)
			var/atom/movable/A = I
			A.lateInitialize(TRUE)
		admin_notice(SPAN_DANG("Late initialized [late_loaders.len] atoms"), R_DEBUG)
		late_loaders.Cut()

/datum/controller/game_controller/proc/initAtom(atom/movable/A, maploaded)
	var/result = A.initialize(maploaded)

//	if(result != INITIALIZE_HINT_NORMAL)
	if(result)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(maploaded)
					if(!late_loaders)
						late_loaders = new
					late_loaders += A
				else
					A.lateInitialize(FALSE)
			if(INITIALIZE_HINT_QDEL)
				qdel(A)

