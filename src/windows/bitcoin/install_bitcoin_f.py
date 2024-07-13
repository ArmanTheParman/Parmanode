from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *

def install_bitcoin():

    set_terminal()
    
    bitcoinpath = pp / "bitcoin"
    zippath = bitcoinpath / "bitcoin-27.1-win64.zip"

    if not bitcoinpath.exists():
        bitcoinpath.mkdir()

    url = "https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-win64.zip"

    please_wait(f"{green}Downloading Bitcoin{orange}")
    download(url, str(zippath))

    unzip_file(str(zippath), directory_destination=str(bitcoinpath)) 
