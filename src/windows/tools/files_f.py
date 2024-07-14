from pathlib import Path
from config.variables_f import *
from tools.debugging_f import *
import requests, zipfile, subprocess, os
import urllib.request

def searchin(the_string, the_file: Path) -> bool:

    if not the_file.is_file():
        return False 

    with the_file.open() as f:
        contents = f.read()

    return the_string in contents

def addline(the_string, the_file):
    if not isinstance(the_file, Path):
        debug(f"the file {the_file} needs to be a Path object")
        return False
    if not the_file.is_file():
        debug(f"addline function - file, f{the_file} does not exist")
        return False
    with the_file.open('a') as f:
        f.write(the_string + '\n')

def deleteline(the_string, the_file):
    
    if not isinstance(the_file, Path):
        debug(f"the file {the_file} needs to be a Path object")
        return False

    if not the_file.is_file():
        debug(f"addline function - file, f{the_file} does not exist")
        return False

    try:
        with the_file.open('r') as f_in, tmp.open('w') as f_out:
            for line in f_in.readlines():
                if the_string not in line:
                    f_out.write(line)
        tmp.replace(the_file)
        return True

    except Exception as e:
        debug(f"Exception when doing deleteline - {e}")
        return False

def download(url, dir):
    try:
        os.getcwd()
        os.chdir(dir)
        subprocess.run(['curl', '-LO', url], check=True)  # other options: stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return True
    except:
        return False

def unzip_file(zippath: str, directory_destination: str):
    try:
        with zipfile.ZipFile(zippath, 'r') as z:
            z.extractall(directory_destination) 
        return True
    except:
        return False