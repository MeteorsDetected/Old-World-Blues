// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)
var/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.

// MySQL configuration
var/sqladdress = "localhost"
var/sqlport    = "3306"
var/sqldb      = "tgstation"
var/sqllogin   = "root"
var/sqlpass    = ""

// Feedback gathering sql connection
var/sqlfdbkdb    = "test"
var/sqlfdbklogin = "root"
var/sqlfdbkpass  = ""
var/sqllogging   = 0 // Should we log deaths, population stats, etc.?

// Forum MySQL configuration. (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt file fail to read for whatever reason.
var/forumsqladdress = "localhost"
var/forumsqlport    = "3306"
var/forumsqldb      = "tgstation"
var/forumsqllogin   = "root"
var/forumsqlpass    = ""
var/forum_activated_group     = "2"
var/forum_authenticated_group = "10"

