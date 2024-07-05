function send_event {
source $nk
content="$1"
sec_bytes_file=$nkd/nsec_bytes.bin

#get Relay choice, otherwise default unhostedwallet.com
unset url

python3<<EOF
import sys, copy, os
sys.path.append("$pn/src/ParmaWallet")
from classes import *
from functions import *
from functions2 import *
from variables import *
from nostr import *
import unicodedata, hashlib, binascii, hmac

connect_to_relay($url)

the_event=Event($pub, kind=1, $content, sec=$priv_hex)

EOF
}