from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *
import threading, time


def install_bitcoin():

    set_terminal()
    print(f"{green}Bitcoin will be downloading in the background...")
    time.sleep(2.5)

    threading.Thread(target=download_bitcoin).start() #check download_bitcoin_finished global variable

    if not choose_drive():
        dbo.write("Bitcoin choose_drive failed.")
        return 1


