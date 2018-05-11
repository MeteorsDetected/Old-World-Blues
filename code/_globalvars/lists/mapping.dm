var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

//Spawnpoints.
var/list/latejoin         = list()
var/list/latejoin_gateway = list()
var/list/latejoin_cryo    = list()
var/list/latejoin_cyborg  = list()

var/list/wizardstart     = list()
var/list/ninjastart         = list()
var/list/newplayer_start = list()
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/blobstart          = list()

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
/var/list/tagger_locations = list()

	//away missions
var/list/awaydestinations = list()	//a list of landmarks that the warpgate can take you to.

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list("thunder","ERT","NUKE","Secret")

