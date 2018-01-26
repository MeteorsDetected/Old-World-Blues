// /mob/var/stat things.
#define CONSCIOUS   0
#define UNCONSCIOUS 1
#define DEAD        2

#define MESSAGE_VISIBLE  1
#define MESSAGE_HEARABLE 2


//FLAGS BITMASK

//Item flags!
#define PROXMOVE	1	// Will the code check us when we move or when something moves near us? Note that if the item doesn't have this flag, HasProximity() will never execute for it.
#define FPRINT		2	// takes a fingerprint
#define ON_BORDER	4	// item has priority to check when entering or leaving
#define INVULNERABLE 8
#define HEAR		16 // This flag is necessary to give an item (or mob) the ability to hear spoken messages! Mobs without a client still won't hear anything unless given HEAR_ALWAYS
#define HEAR_ALWAYS 32 // Assign a virtualhearer to the mob even when no client is controlling it. (technically not an item flag, but related to the above)

#define TWOHANDABLE	64
#define MUSTTWOHAND	128
#define SLOWDOWN_WHEN_CARRIED 256 //Apply slowdown when carried in hands, instead of only when worn

#define NOBLOODY	512	// used to items if they don't want to get a blood overlay

#define NO_ATTACK_MSG 	1024 // when an item has this it produces no "X has been hit by Y with Z" message with the default handler
#define NO_THROW_MSG 	2048 // produce no "X has thrown Y" message when somebody throws this item
#define NO_STORAGE_MSG 	4096 // produce no "X puts the Y into the backpack" message when somebody moves this item in their inventory

#define OPENCONTAINER	8192  // is an open container for chemistry purposes
#define	NOREACT 		16384 // Reagents don't react inside this container.

#define TIMELESS		32768 // Immune to time manipulation.

#define ALL ~0
#define NONE 0

// Bitflags defining which status effects could be or are inflicted on a mob.
#define CANSTUN     0x1
#define CANWEAKEN   0x2
#define CANPARALYSE 0x4
#define CANPUSH     0x8
#define LEAPING     0x10
#define PASSEMOTES  0x20    // Mob has a cortical borer or holders inside of it that need to see emotes.
#define SKELETON    0x40
#define HUSK        0x80
#define NOCLONE     0x100
#define GODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like changeling.changeling_fakedeath.
#define DISFIGURED  0x4000  // Set but never checked. Remove this sometime and replace occurences with the appropriate organ code
#define XENO_HOST   0x8000  // Tracks whether we're gonna be a baby alien's mummy.

// Grab levels.
#define GRAB_PASSIVE    1
#define GRAB_AGGRESSIVE 2
#define GRAB_NECK       3
#define GRAB_UPGRADING  4
#define GRAB_KILL       5

#define BORGMESON 0x1
#define BORGTHERM 0x2
#define BORGXRAY  0x4

#define HOSTILE_STANCE_IDLE      1
#define HOSTILE_STANCE_ALERT     2
#define HOSTILE_STANCE_ATTACK    3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED     5

#define LEFT  1
#define RIGHT 2

// Pulse levels, very simplified.
#define PULSE_NONE    0 // So !M.pulse checks would be possible.
#define PULSE_SLOW    1 // <60     bpm
#define PULSE_NORM    2 //  60-90  bpm
#define PULSE_FAST    3 //  90-120 bpm
#define PULSE_2FAST   4 // >120    bpm
#define PULSE_THREADY 5 // Occurs during hypovolemic shock
#define GETPULSE_HAND 0 // Less accurate. (hand)
#define GETPULSE_TOOL 1 // More accurate. (med scanner, sleeper, etc.)

//intent flags, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"harm"

//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Robot AI notifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4

// Appearance change flags
#define APPEARANCE_UPDATE_DNA  0x1
#define APPEARANCE_RACE       (0x2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_GENDER     (0x4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN        0x8
#define APPEARANCE_HAIR        0x10
#define APPEARANCE_HAIR_COLOR  0x20
#define APPEARANCE_FACIAL_HAIR 0x40
#define APPEARANCE_FACIAL_HAIR_COLOR 0x80
#define APPEARANCE_EYE_COLOR 0x100
#define APPEARANCE_ALL_HAIR (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL       0xFFFF

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for aggressive actions
#define DEFAULT_QUICK_COOLDOWN  4


#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

// NT's alignment towards the character
#define COMPANY_LOYAL 			"Loyal"
#define COMPANY_SUPPORTATIVE	"Supportive"
#define COMPANY_NEUTRAL 		"Neutral"
#define COMPANY_SKEPTICAL		"Skeptical"
#define COMPANY_OPPOSED			"Opposed"

#define COMPANY_ALIGNMENTS		list(COMPANY_LOYAL,COMPANY_SUPPORTATIVE,COMPANY_NEUTRAL,COMPANY_SKEPTICAL,COMPANY_OPPOSED)

#define SYNTH_BLOOD_COLOUR "#030303"
#define SYNTH_FLESH_COLOUR "#575757"

//carbon taste sensitivity defines, used in mob/living/carbon/proc/ingest
#define TASTE_HYPERSENSITIVE 3 //anything below 5%
#define TASTE_SENSITIVE 2 //anything below 7%
#define TASTE_NORMAL 1 //anything below 15%
#define TASTE_DULL 0.5 //anything below 30%
#define TASTE_NUMB 0.1 //anything below 150%

//Mob species flags (simple stuff mostly for simple_animals)
#define MOB_UNDEAD  1 //zombies, ghosts, skeletons
#define MOB_ROBOTIC 2 //robots
#define MOB_CONSTRUCT 4 //golems, animated armor, animated whatever (not mimics though)
#define MOB_SWARM 8 //swarm of mobs!
#define MOB_HOLOGRAPHIC 16 //holocarps
#define MOB_SUPERNATURAL 32
#define MOB_NO_PETRIFY 64 //can't get petrified