from config.variables_f import *
from tools.screen_f import *
from bitcoin.uninstall_bitcoin_f import *

def menu_remove():
    if ico.grep("bitcoin-"): 
        rem_bitcoin = f"#                  {green} (b){orange}            Bitcoin Core                                        #"
    else: 
        rem_bitcoin ="#                                                                                      #"

    while True:
        set_terminal()
        print(f"""
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu -->{cyan} Remove Menu {orange}                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
{rem_bitcoin}
#                                                                                      #
#                                                                                      #
########################################################################################
""")
        choice = choose("xpmq")
        if choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
            quit()
        elif choice in {"p", "P"}:
            return True
        elif choice in {"m", "M"}:
            back2main()
        elif choice in {"b", "B", "Bitcoin", "bitcoin"}:
            if not uninstall_bitcoin(): return False
            return True
        else:
            invalid()