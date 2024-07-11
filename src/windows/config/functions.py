from pathlib import Path
import requests, time
from config.variables import *
from functions.text_functions import *
import atexit

def counter(type):
    if type == "rp":
        with rp_counter.open('r') as f:
            rpcount = f.read().strip()
            newcount = int(rpcount) + 1
        with rp_counter.open('w') as f:
            f.write(str(newcount) + '\n')
        return 0
    if type == "motd":
        with motd_counter.open('r') as f:
            motdcount = f.read().strip()
            newcount = int(motdcount) + 1
        with motd_counter.open('w') as f:
            f.write(str(newcount) + '\n')


def check_updates(compiled_version):
    if searchin("update_reminder=1", hm):
        return 0
    url = "https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf" 
    params = {'_': int(time.time())}  # Adding a unique timestamp parameter
    try:
        response = requests.get(url, params=params).text.split('\n')
        latest_winMajor = int(response[5].split("=")[1])
        latest_winMinor = int(response[6].split("=")[1])
        latest_winPatch = int(response[7].split("=")[1])
        print(latest_winPatch)  

        if (latest_winMajor, latest_winMinor, latest_winPatch) > (compiled_version):
            return "outdated"
        else:
            return "uptodate"

    except Exception as e:
        print(f"error when checking update, {e}")
        return "error"

def cleanup():
    """Will execute when Parmanode quits"""
    print(f"{reset}")
    tmp.unlink() #deletes the file

atexit.register(cleanup) 


class config:
    def __init__(self, path: Path):
        if path.exists() == False:
           path.touch() 

        self.file = path
        self.data = set()
        with self.file.open('r') as f:
            for line in f.readlines():
                self.data.add(line.strip() + '\n')
      
      #members:
          # file 
          # data - one line entries

    def __repr__(self):
        return f"Config {str(self.file)}: \n {self.data}"
          
    def read(self) -> set:
        return self.data    
    
    def write(self):
        with self.file.open('w') as f:
            for line in self.data:
                f.write(line)

    def add(self, toadd: str):
        self.data.add(toadd + '\n')
        self.write()
    
    def remove(self, toremove: str):
        temp = self.data.copy()
        for line in self.data:
            if toremove in line:
                temp.remove(line) 
        self.data = temp
        self.write()

    def grep(self, checkstring: str) -> bool:
        for line in self.data:
            if checkstring in line:
                return True
        return False
