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
            return True
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal"
            pco.add("drive_bitcoin=internal")
            return True
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

def choose_drive2():
    example_dir = Path.home() / "some_directory"
    print(f"""
######################################################################################## 

    You have chosen to use the{green} Internal drive{orange} for the Bitcoin Timechain. 
    
    The data will be kept at{cyan} 

        {default_bitcoin_data_dir}{orange}

    Hit{green} <enter>{orange} to continue, or
    
    Type a full path to where you want the data to go, and Parmanode will create a
    symlink from the above directory to your preferred target directory. This will
    "trick" Bitcoin to download to your preferred location even though it thinks it's
    downloading to the above default location. It's ok, it's ethical and no coins will
    be harmed. 
    
    Example:
    {cyan} 
    {example_dir}{orange}

    Most people will just keep it at the default location.
    Hit{green} <enter>{orange} alone for that.
    
########################################################################################
""")
    choice = input()

    if choice.upper() in {"Q", "EXIT"}: 
        quit()
    elif choice.upper() == "P":
        return True
    elif choice.upper() == "M":
        back2main()
    elif choice == "":
        return True
    else:
        invalid()