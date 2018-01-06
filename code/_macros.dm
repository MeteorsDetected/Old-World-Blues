#define subtypesof(type) (typesof(type) - type)

#define SPAN_NOTE(text) "<span class='notice'>[text]</span>"
#define SPAN_WARN(text) "<span class='warning'>[text]</span>"
#define SPAN_DANG(text) "<span class='danger'>[text]</span>"

#define Clamp(value, low, high) 	(value <= low ? low : (value >= high ? high : value))
#define CLAMP01(x) 		(Clamp(x, 0, 1))

#define get_turf(A) get_step(A,0)


//MOB LEVEL

#define ismob(A) istype(A, /mob) //istype\(([a-z0-9:._]+), ?/mob\)

#define isobserver(A) istype(A, /mob/observer/dead)

#define isEye(A) istype(A, /mob/observer/eye)

#define isnewplayer(A) istype(A, /mob/new_player)
//++++++++++++++++++++++++++++++++++++++++++++++

#define isliving(A) istype(A, /mob/living)
//---------------------------------------------------

#define iscarbon(A) istype(A, /mob/living/carbon)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define ishuman(A) istype(A, /mob/living/carbon/human)
//---------------------------------------------------

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isxeno(A) istype(A, /mob/living/simple_animal/xeno)
//---------------------------------------------------

#define issilicon(A) istype(A, /mob/living/silicon)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)
#define isweakref(A) istype(A, /weakref)

//---------------------------------------------------

//OBJECT LEVEL
#define isobj(A) istype(A, /obj)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define ismaterial(A) istype(A, /obj/item/stack/material)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

//--------------------------------------------------
#define to_chat(target, message)                            target << message
#define MAP_IMAGE_PATH "nano/images/"
#define map_image_file_name(z_level) "Aurora-[z_level].png"
#define to_world(message)                                   world << message
#define sound_to(target, sound)                             target << sound
#define to_file(file_entry, file_content)                   file_entry << file_content
#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
