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


//OBJECT LEVEL
#define isobj(A) istype(A, /obj)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define ismaterial(A) istype(A, /obj/item/stack/material)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define istool(O) is_type_in_list(O, common_tools)
//---------------------------------------------------

#define iswrench(O) istype(O, /obj/item/weapon/wrench)

#define iswelder(O) istype(O, /obj/item/weapon/weldingtool)

#define iscoil(O) istype(O, /obj/item/stack/cable_coil)

#define iswirecutter(O) istype(O, /obj/item/weapon/wirecutters)

#define isscrewdriver(O) istype(O, /obj/item/weapon/screwdriver)

#define ismultitool(O) istype(O, /obj/item/device/multitool)

#define iscrowbar(O) istype(O, /obj/item/weapon/crowbar)

#define iswire(O) istype(O, /obj/item/stack/cable_coil)