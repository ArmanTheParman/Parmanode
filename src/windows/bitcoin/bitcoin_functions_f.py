from config.variables_f import *
from tools.screen_f import *
from tools.files_f import *
from tools.system_f import *


def choose_drive():
    set_terminal()
    while True:
        print(f"""{orange}
########################################################################################


    You have the option to use an{green} external{orange} or {cyan}internal{orange} hard drive for the 
    data.


    Please choose an option:



{green}                (e){orange}     Use an EXTERNAL drive (choice to format) 

{cyan}                (i){orange}     Use an INTERNAL drive 



########################################################################################""")

        choice = choose("xpmq")
        if choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
            quit()
        elif choice in {"p", "P"}:
            return 1
        elif choice in {"m", "M"}:
            back2main()
        elif choice in {"e", "E"}:
            drive_bitcoin = "external"
            pco.add("drive_bitcoin=external")
            return 0
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal"
            pco.add("drive_bitcoin=internal")
            return 0
        else:
            invalid()

def download_bitcoin():
    try:
        url = "https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-win64.zip"
        please_wait(f"{green}Downloading Bitcoin{orange}")
        download(url, str(bitcoinpath))
        zippath = bitcoinpath / "bitcoin-27.1-win64.zip"
        please_wait(f"{green}Unzipping Bitcoin{orange}")
        unzip_file(str(zippath), directory_destination=str(bitcoinpath)) 
        download_bitcoin_finished = True
    except:
        pass 

    return download_bitcoin_finished 
