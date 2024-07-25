from config.variables_f import *
from tools.screen_f import *
from bitcoin.install_bitcoin_f import *

def menu_add():
    if not ico.grep("bitcoin-end"):
        add_bitcoin = f"#                  {green} (b){orange}            Bitcoin Core                                        #"
        bitcoinmenu = True
    else: 
        add_bitcoin ="#                                                                                      #"
        bitcoinmenu = False

    while True:
        set_terminal()
        print(f"""
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu -->{cyan} Install Menu {orange}                                 #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#                                                                                      #
{add_bitcoin}
#                                                                                      #
#                                                                                      #
#                                                                                      #
#                                   {red}          ... more programs soon {orange}                  #
#                                                                                      #
########################################################################################
""")
        choice = choose("xpmq")
        if choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
            quit()
        elif choice in {"p", "P"}:
            return True
        elif choice in {"m", "M"}:
            return True 
        elif choice in {"b", "B", "Bitcoin", "bitcoin"}:
            if bitcoinmenu == False : continue
            if not install_bitcoin(): return False
            return True
        else:
            invalid()
