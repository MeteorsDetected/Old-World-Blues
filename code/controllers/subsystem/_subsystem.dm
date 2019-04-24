/datum/controller/subsystem
	// Metadata; you should define these.
	name = "fire coderbus" //name of the subsystem
	var/init_order = INIT_ORDER_DEFAULT		//order of initialization. Higher numbers are initialized first, lower numbers later. Use defines in __DEFINES/subsystems.dm for easy understanding of order.
	var/wait = 20			//time to wait (in deciseconds) between each call to fire(). Must be a positive integer.
	var/priority = FIRE_PRIORITY_DEFAULT	//When mutiple subsystems need to run in the same tick, higher priority subsystems will run first and be given a higher share of the tick before MC_TICK_CHECK triggers a sleep

	var/flags = 0			//see MC.dm in __DEFINES Most flags must be set on world start to take full effect. (You can also restart the mc to force them to process again)
