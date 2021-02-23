#define LIGHTFLOOR_ON_BIT 4

#define LIGHTFLOOR_STATE_OK 0
#define LIGHTFLOOR_STATE_FLICKER 1
#define LIGHTFLOOR_STATE_BREAKING 2
#define LIGHTFLOOR_STATE_BROKEN 3
#define LIGHTFLOOR_STATE_BITS 3

//PROCS
/turf/simulated/floor
	var/lightfloor_state // for light floors, this is the state of the tile. 0-7, 0x4 is on-bit - use the helper procs below

/turf/simulated/floor/proc/get_lightfloor_state()
	return lightfloor_state & LIGHTFLOOR_STATE_BITS

/turf/simulated/floor/proc/get_lightfloor_on()
	return lightfloor_state & LIGHTFLOOR_ON_BIT

/turf/simulated/floor/proc/set_lightfloor_state(n)
	lightfloor_state = get_lightfloor_on() | (n & LIGHTFLOOR_STATE_BITS)

/turf/simulated/floor/proc/set_lightfloor_on(n)
	if(n)
		lightfloor_state |= LIGHTFLOOR_ON_BIT
	else
		lightfloor_state &= ~LIGHTFLOOR_ON_BIT

/turf/simulated/floor/proc/toggle_lightfloor_on()
	lightfloor_state ^= LIGHTFLOOR_ON_BIT

/turf/simulated/floor/proc/update_lightfloor_icon()
	if(get_lightfloor_on())
		switch(get_lightfloor_state())
			if(LIGHTFLOOR_STATE_OK)
				icon_state = "light_on"
				set_light(5)
			if(LIGHTFLOOR_STATE_FLICKER)
				var/num = pick("1","2","3","4")
				icon_state = "light_on_flicker[num]"
				set_light(5)
			if(LIGHTFLOOR_STATE_BREAKING)
				icon_state = "light_on_broken"
				set_light(5)
			if(LIGHTFLOOR_STATE_BROKEN)
				icon_state = "light_off"
				set_light(0)
	else
		set_light(0)
		icon_state = "light_off"

/turf/simulated/floor/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return

	if(is_light_floor())
		if(user.canmove && !user.restrained())
			toggle_lightfloor_on()
			update_icon()
			return 1
	return 0

#undef LIGHTFLOOR_ON_BIT

#undef LIGHTFLOOR_STATE_OK
#undef LIGHTFLOOR_STATE_FLICKER
#undef LIGHTFLOOR_STATE_BREAKING
#undef LIGHTFLOOR_STATE_BROKEN
#undef LIGHTFLOOR_STATE_BITS
