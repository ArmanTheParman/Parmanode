from pathlib import Path
from config.variables import *

import os

def debug(text=None, some_function=None):
    if D == True:
        if some_function is not None:
            some_function()
            return 0
        if text is None:
            print("Pausing for debugging")
            print(text)
            input(f"{green}<enter>{orange} to continue")
            return 0
        else:
            print("DEBUG point")
            print(text)
            input(f"{green}<enter>{orange} to continue")
            return 0
    else:
        return 0

def searchin(the_string, the_file) -> bool:

    if not the_file.is_file():
        return 1 

    with the_file.open() as f:
        contents = f.read()

    return the_string in contents

def addline(the_string, the_file):
    if not isinstance(the_file, Path):
        debug(f"the file {the_file} needs to be a Path object")
        return 1
    if not the_file.is_file():
        debug(f"addline function - file, f{the_file} does not exist")
        return 1
    with the_file.open('a') as f:
        f.write(the_string)

def deleteline(the_string, the_file):
    
    if not isinstance(the_file, Path):
        debug(f"the file {the_file} needs to be a Path object")
        return 1

    if not the_file.is_file():
        debug(f"addline function - file, f{the_file} does not exist")
        return 1

    try:
        with the_file.open('r') as f_in, tmp.open('w') as f_out:
            for line in f_in.readlines():
                if the_string not in line:
                    f_out.write(line)
        tmp.replace(the_file)
        return 0

    except Exception as e:
        debug(f"Exception when doing deleteline - {e}")
        return 1
    
        
            
def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")
    print(f"{orange}green {reset}\"green\"")
    print(f"{bright_blue}green {reset}\"green\"")
    
def set_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')
