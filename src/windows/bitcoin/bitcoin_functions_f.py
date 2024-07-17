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
            return False
        elif choice in {"m", "M"}:
            back2main()
        elif choice in {"e", "E"}:
            drive_bitcoin = "external" #global var
            pco.add("drive_bitcoin=external")
            return True
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal" #global var
            pco.add("drive_bitcoin=internal")
            if not choose_drive2(): return False
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
    while True:
        set_terminal()
        print(f"""
######################################################################################## 

    You have chosen to use the{green} Internal drive{orange} for the Bitcoin Timechain. 
    
    The data will be kept at{cyan} 

        {default_bitcoin_data_dir}{orange}

    Hit{green} <enter>{orange} to continue
    
    or
    
    Type {red}x{orange} to choose a custom path to where you want the data to go, and Parmanode 
    will create a symlink from the above folder to your preferred target folder. 
    This will "trick" Bitcoin to download to your preferred location even though it 
    thinks it's downloading to the above default location. It's ok, it's ethical and 
    no coins will be harmed. 
   
    Most people will just keep it at the default location.
    Hit{green} <enter>{orange} alone for that.
    
########################################################################################
""")
        choice = input()

        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()
        elif choice == "":
            return True
        elif choice.upper() == "X":
            result = get_custom_directory("bitcoin")
            if result == "try again": continue
            else: return result
        else:
            invalid()

        
def get_custom_directory(app="bitcoin"):
    example_dir = Path.home() / "some_folder"
    while True:
        print(f"""
########################################################################################

    Please type in the path where you want the Bitcoin data to be stored. Be careful,
    and make sure you type the correct path EXACTLY. If the folder you type
    does not exist, it will be created. Don't mess this up.
    
    You can abort if you want, otherwise, type it in and hit{cyan} <enter>{orange}

    Example: 
    {cyan} 
        {example_dir}{orange}    

########################################################################################
""")
        choice = choose()
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()
        elif choice == "":
            return True 
        elif choice.upper().startswith('C:\\'):
            confirm = bitcoin_folder_choice_confirm(choice) 
            if confirm == "try again": continue
            return confirm #bool
        else:
            set_terminal()
            announce("""    Drive C:\ expected in your path. Try again.""", ec_text="try again")
            continue
            

def bitcoin_folder_choice_confirm(choice):
    folder = choice
    while True:
        set_terminal()    
        print(f"""
########################################################################################

    You have chosen the following for the Bitcoin data folder. The Timechain will
    be downloaded inside this folder: 
{cyan}
        {folder} {orange}
    
    Is this correct?
   {green} 
                     y)        Yes, let's do this
        {red}             
                     n)        No, I'll try again.
{orange}
########################################################################################
""")
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()
        elif choice.upper() == "Y":
            return True 
        elif choice.upper() == "N":
            return "try again"

