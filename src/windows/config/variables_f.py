from colorama import Fore, Style, init #init need to toggle autoreset on/off
import sys, os 
from pathlib import Path
from config.classes_f import *

version="0.0.1"

########################################################################################
#Debugging
########################################################################################

if len(sys.argv) == 1:
    sys.argv.append("no_debug")
    D=False
elif sys.argv[1] in {"d", "debug"}:
    D=True
else:
    D=False

########################################################################################
#directories
########################################################################################

HOME=Path.home()

pp = HOME / "parman_programs"
if not pp.exists():
   pp.mkdir() 

dp = pp / "parmanode_config"
if not dp.exists():
    dp.mkdir()

bitcoinpath = pp / "bitcoin"
if not bitcoinpath.exists():
    bitcoinpath.mkdir()                

#path

sys.path.append(str(dp))

########################################################################################
#files
########################################################################################

global tmp, pc, ic, rp_counter, motd_counter, pco, ico, dbo, db, before, after, difference 

tmp = dp / "for_copying-can_delete.tmp"
pc = dp / "parmanode.conf"
ic = dp / "installed.conf"
db = dp / "debug.log"
rp_counter = dp / "rp_counter.conf"
motd_counter = dp / "motd_counter.conf"
before = dp / "before.log"
after = dp / "after.log"
difference = dp/ "difference.log"

if not tmp.exists():
    tmp.touch()

if not pc.exists():
    pc.touch()

if not ic.exists():
    ic.touch()

if not db.exists():
    db.touch()

if not rp_counter.exists():
    with rp_counter.open('w') as f:
        f.write("0" + '\n')

if not motd_counter.exists():
    with motd_counter.open('w') as f:
        f.write("0" + '\n')

if not before.exists():
    before.touch()

if not after.exists():
    after.touch()

if not difference.exists():
    difference.touch()

global pco, ico, dbo, tmpo, beforeo, aftero, differenceo 

pco = config(pc) #parmanode conf object

ico = config(ic) #installed conf object

dbo = config(db) #debug log object

tmpo = config(tmp) #temp config object - not config, but useful methods

beforeo = config(before)

aftero = config(after)

differenceo = config(difference)

#add parmanode config file to python path
sys.path.append(dp)

########################################################################################
#colours
########################################################################################
#if colour resets after print statment, enable this: 
#init(autoreset=True)

# Basic colors
black = Fore.BLACK
red = Fore.RED
green = Fore.GREEN
yellow = Fore.YELLOW
blue = Fore.BLUE
magenta = Fore.MAGENTA
cyan = Fore.CYAN
white = Fore.WHITE
reset = Style.RESET_ALL

# Additional colors
orange = '\033[1m\033[38;2;255;145;0m'  # Manual for colors not in colorama
pink = '\033[38;2;255;0;255m'
bright_black = '\033[90m'
grey = Fore.LIGHTBLACK_EX
bright_red = Fore.LIGHTRED_EX
bright_green = Fore.LIGHTGREEN_EX
bright_yellow = Fore.LIGHTYELLOW_EX
bright_blue = Fore.LIGHTBLUE_EX
bright_magenta = Fore.LIGHTMAGENTA_EX
bright_cyan = Fore.LIGHTCYAN_EX
bright_white = Fore.LIGHTWHITE_EX

# Blink effects
blinkon = '\033[5m'
blinkoff = Style.RESET_ALL

########################################################################################
#Bitcon variables
########################################################################################
global drive_bitcoin, default_bitcoin_data_dir

drive_bitcoin = None

# Default Windows Bitcoin data directory
default_bitcoin_data_dir = Path.home() / "AppData" / "Roaming" / "Bitcoin"

def get_IP(iptype="internal", print:bool=None):
    import socket 
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('8.8.8.8', 80))  
    ip_address = s.getsockname()[0]
    s.close()
    if print == True: input(f"The IP addres is: {ip_address}")
    return ip_address 