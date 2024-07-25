from pathlib import Path
from config.variables_f import *
from tools.debugging_f import *
from tools.screen_f import *
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
        try:
            subprocess.run(['curl', '-LO', url], check=True)  # other options: stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except Exception as e:
            announce("download failed")
            return False
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

def delete_directory_contents(path_given):

    if isinstance(path_given, str):
        try: path = Path(path_given)
        except Exception as e: input(e) ; return False
        print(type(path))

    if isinstance(path_given, Path):
        try: path = Path(path_given)
        except Exception as e: input(e) ; return False


    if isinstance(path, Path): 

        if not path.exists(): return True

        for item in path.iterdir(): 

            if item.is_dir(): 
                delete_directory(item)  # Recursively delete contents of subdirectories
                if item.exists(): item.rmdir()            # Remove the now-empty SUBdirectory

            else:
                if item.exists(): item.unlink()  # Remove the file
        return True
    else:
        raise ValueError(f"""unexpect type in delete_directory_contents()""")


def delete_directory(path_given):

    if isinstance(path_given, str):
        try: path = Path(path_given)
        except Exception as e: input(e) ; return False

    if isinstance(path_given, Path): 
        try: path = Path(path_given) 
        except Exception as e: input(e) ; return False

    if not isinstance(path, Path):
        raise Exception ("Error with Path object")

    if path.is_symlink():
        path.unlink()  # Remove symbolic link
        return True

    if not path.exists():
        return True 

    if not path.is_dir():
        raise Exception(f"{path} passed to delete_directory, but it is not a dir, nor symlink") 

    for item in path.iterdir(): #for a non-empty directory

        if item.is_dir(): 
            delete_directory(item)  # Recursively delete contents of subdirectories
            if item.exists(): item.rmdir()            # Remove the now-empty SUBdirectory

        else:
            if item.exists(): item.unlink()  # Remove the file

    if path.exists(): path.rmdir()  # Path directory should be empty now, can delete
    
    return True
       

def get_directory_size(directory, units="MB"):

    if isinstance(directory, str):
        directory = Path(directory)

    if isinstance(directory, Path):

        if not directory.exists(): announce(f"""{directory} does not exist.""") ; return False

        try: size_bytes = sum(f.stat().st_size for f in directory.rglob('*') if f.is_file()) 
        except Exception as e: announce(e) ; return False

        if units == "MB": 
            size_bytes_MB = size_bytes / (1024 * 1024) 
            return round(size_bytes_MB, 2) #round to two decimal places, MB

        elif units == "GB": 
            size_bytes_GB = size_bytes / (1024 * 1024 * 2014) 
            return round(size_bytes_GB, 2) #round to two decimal places, MB
        
        elif units =="raw":
            size_bytes_raw = size_bytes 
            return round(size_bytes_raw, 2) #round to two decimal places, MB
    
    return False

def get_directory_items(directory):
    
    if isinstance(directory, str):
        directory = Path(directory)
    
    if not directory.exists(): announce (f"""{directory} does not exist.""") ; return False

    directory_sorted = sorted(directory.iterdir())
    pages = int(len(directory_sorted) / 30 )
    if pages % 1 > 0: pages += 1
    
    set_terminal()
    
    print(f"""
######################################################################################## 

    Contents of {directory}
{cyan}
""")

    count = 0
    for i in range(pages+1):
        if count != 0: #means j loop has gone through at least once
            print(f"""{orange}
########################################################################################

     Page {i + 1}
 {cyan}
 """)
        count = 0
        for j in directory_sorted:
            count +=  1
            min = i * 30 #when i is 0, min is 0, when is 1 min is 30
            max = min + 30
            if count > min and count < max:
                print(f"    {j}")
        if i == pages: break
        print(f""""
    {orange}Hit <enter> for next page{cyan}
              """, pages, "count: ", count, "i is: ", i)
        input()
        set_terminal()

    print(f"""{orange}

########################################################################################
""")
    enter_continue()