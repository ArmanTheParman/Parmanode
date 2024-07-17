from config.variables_f import *
from tools.screen_f import *
from tools.files_f import *

def debug(text=None, some_function=None):
    if D == True:
        if some_function is not None:
            some_function()
            return True
        if text is None:
            print("Pausing for debugging")
            print(text)
            enter_continue()
            return True
        else:
            print("DEBUG point")
            print(text)
            enter_continue()
            return True
    else:
        return True

def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")
    print(f"{orange}green {reset}\"green\"")
    print(f"{bright_blue}green {reset}\"green\"")
    