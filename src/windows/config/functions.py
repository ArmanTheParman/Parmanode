from pathlib import Path
import requests, time
from config.variables import *
from functions.text_functions import *

def counter():
    with rp_counter.open('r') as f:
        rpcount = f.read().strip()
        print(rpcount)
        newcount = int(rpcount) + 1
    with rp_counter.open('w') as f:
        f.write(str(newcount) + '\n')
    return 0

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
        
   
