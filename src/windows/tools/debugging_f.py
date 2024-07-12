from config.variables_f import *
from tools.screen_f import *

def debug(text=None, some_function=None):
    if D == True:
        if some_function is not None:
            some_function()
            return 0
        if text is None:
            print("Pausing for debugging")
            print(text)
            enter_continue()
            return 0
        else:
            print("DEBUG point")
            print(text)
            enter_continue()
            return 0
    else:
        return 0

def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")
    print(f"{orange}green {reset}\"green\"")
    print(f"{bright_blue}green {reset}\"green\"")
    