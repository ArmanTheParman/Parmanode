from colorama import Fore, Style, init #init need to toggle autoreset on/off
import sys
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

#path

sys.path.append(str(dp))

########################################################################################
#files
########################################################################################

tmp = dp / "for_copying-can_delete.tmp"
pc = dp / "parmanode.conf"
rp_counter = dp / "rp_counter.conf"
motd_counter = dp / "motd_counter.conf"

if not tmp.exists():
    tmp.touch()

if not pc.exists():
    pc.touch()

pco = config(pc) #parmanode conf object

if not rp_counter.exists():
    with rp_counter.open('w') as f:
        f.write("0" + '\n')

if not motd_counter.exists():
    with motd_counter.open('w') as f:
        f.write("0" + '\n')

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

