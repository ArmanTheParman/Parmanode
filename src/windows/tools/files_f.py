from pathlib import Path
from config.variables import *
from tools.debugging_f import *

def searchin(the_string, the_file: Path) -> bool:

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
        f.write(the_string + '\n')

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
    