#define SPAN_NOTE(text) "<span class='notice'>[text]</span>"
#define SPAN_WARN(text) "<span class='warning'>[text]</span>"
#define SPAN_DANG(text) "<span class='danger'>[text]</span>"

#define LIST_OF_CONSONANT list(\
	"b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z",\
	"á","â","ã","ä","æ","ç","é","ê","ë","ì","í","ï","ð","ñ","ò","ô","õ","ö","÷","ø","ù"\
)

#define T_BOARD(name)	"circuit board (" + (name) + ")"

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 12288
#define MAX_BOOK_MESSAGE_LEN  36864
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          52

