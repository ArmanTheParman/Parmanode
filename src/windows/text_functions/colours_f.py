from colorama import Fore, Style, init

init(autoreset=True)

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

def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")