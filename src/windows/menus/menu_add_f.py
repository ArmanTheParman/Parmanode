from config.variables_f import *
from tools.screen_f import *
from bitcoin.install_bitcoin_f import *
def menu_add():
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
#                  {green} (b){orange}            Bitcoin Core                                        #
#                                                                                      #
#                                                                                      #
#                                                                                      #
#                                   {red}          ... more programs soon {orange}                  #
#                                                                                      #
########################################################################################
""")
           choice = choose(xpmq)
           if choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
               quit()
           elif choice in {"p", "P"}:
               return 0
           elif choice in {"m", "M"}:
               back2main()
           elif choice in {"b", "B", "Bitcoin", "bitcoin"}:
               install_bitcoin()
               return 0
           else:
               invalid()
