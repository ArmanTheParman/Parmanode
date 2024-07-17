from config.variables_f import *
from tools.screen_f import *
from tools.files_f import *
from tools.system_f import *
from tools.drive_f import *

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
            format_choice("bitcoin")
            pco.add("drive_bitcoin=external")
            return True
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal" #global var
            pco.add("drive_bitcoin=internal")
            if not choose_drive2(): return False 
            else: return True
        else:
            invalid()

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
            if type(result) == bool: return result
            else: return False
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
            pco.add(f"bitcoin_dir={folder}")
            if not Path(choice).exists(): Path(choice).mkdir(parents=True, exist_ok=True)
            return True 
        elif choice.upper() == "N":
            return "try again"

def format_choice(app="bitcoin"):
    while True:
        set_terminal()
        print(f"""
########################################################################################

    You have chosen to use an{cyan} external drive{orange}.
              
    You have choices:
{green}    
              1)    Set up a new drive{orange} (Will be formatted and initialised)
{red}
              2)    Bring in a used drive{orange} 
                          ... Parmanode will need to change the label to 'parmanode'
                          ... You can select a directory with a pre-existing copy
                              of the timechain.

########################################################################################
""")
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()   
        elif choice == "1":
            if format_disk(): 
                pco.add("format_disk=True")
                return True 
            return False
        elif choice == "2":
            if used_disk(): return True 
            return False
        else:
            invalid()

def used_disk():
    while True:
        set_terminal()
        print(f"""
########################################################################################

    You have chosen to sync Bitcoin to a previously used disk.
    
    Please type the path to the folder on the drive exactly, including the drive
    letter. If the directory does not exist, Parmanode will create it. Eg:
    {cyan} 
        D:\\bitcoin {orange}
    
########################################################################################
""")    
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()   
        elif choice[1] == ":":
            confirm = bitcoin_folder_choice_confirm(choice) #directory will be created
            if confirm == "try again": continue
            if confirm == False: return False
            drive_letter = choice[0].upper()
            if label_disk(drive_letter): return True
            else: return False
        else:
            invalid()

def label_disk(drive_letter, new_label="parmanode"):

    try:
        subprocess.run(['label', f'{drive_letter}:', new_label], check=True)
        return True

    except subprocess.CalledProcessError as e:
        print(f"Failed to label the disk: {e}")
        enter_continue()
        return False

    