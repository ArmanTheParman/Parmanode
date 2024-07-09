from pathlib import Path
import requests
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
   url = "https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf" 
   response = requests.get(url).text
   print(response.split('\n'))
   #latest_version = response.split('\n')[0].split("\"")[1].split("v")[1]

     