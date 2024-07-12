from config.variables import *
import os

def set_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')


def choose(type=None):
    if type == "xpqm":
        print(f"{yellow}Type your{cyan}choice{yellow} from above options, or:{pink} (p){yellow} for previous,{green} (m){yellow} for main,{red} (q){yellow} to quit.")
    if type == "xeq":
        print(f"{yellow}Type your{cyan}choice{yellow}, or{green} <enter>{yellow} to continue, or {red}(q){yellow} to quit.")

    choice = input()
    return choice 

def enter_continue():
    print(f"{yellow}Hit{cyan} <enter>{yellow} to continue...")
    return input()
   