from pathlib import Path
import sys, os

def debug(text="", some_function=None):
    if D == True:
        if some_function is not None:
            some_function()
        print("Pausing for debugging")
        print(text)
        input("<enter> to continue")
    else:
        return 0

def searchin(the_string, the_file) -> bool:

    if not the_file.is_file():
        return 1 

    with the_file.open() as f:
        contents = f.read()

    return the_string in contents

def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")

    
def set_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')
