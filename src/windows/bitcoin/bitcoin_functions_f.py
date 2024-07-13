from config.variables_f import *
from tools.screen_f import *
def choose_drive():
    while True:
        print(f"""
########################################################################################


    You have the option to use an{green} external{orange} or {cyan}internal{orange} hard drive for the 
    data.


    Please choose an option:



{green}                (e){orange}     Use an EXTERNAL drive (choice to format) 

{green}                (i){orange}     Use an INTERNAL drive 



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



