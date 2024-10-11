import sys, os
import getpass

def clear():
    if os.name == 'nt':  
        os.system('cls')
    else:  
        os.system('clear')

from electrum.storage import WalletStorage

##########
clear()
while True:
    walletpath = input(f"""
########################################################################################      

    Please type the path of your wallet file. If it is in the current directory, just
    type the file name beginning with './' , eg:

        ./filename
        
    Otherwise type the full path.

########################################################################################
""")

    if walletpath == "": 
        input("""Hit <enter> to try again""")
        clear()
        continue
    elif walletpath != '.' and walletpath != '/':
        input("""Path must begin with a '.' or '/'. Hit <enter> to try again""")
        clear()
        continue
    break

wallet_object = WalletStorage(walletpath)

if not wallet_object.file_exists():
    input("No wallet file at path!")
    sys.exit(0)

if not wallet_object.is_encrypted():
    input("Good new, this wallet isn't encrypted.")
    sys.exit(0)

automate = input(f"""
######################################################################################## 

    Would you like to manually guess the password/decryption_key, or automatic?
    
        m)    manual
        
        a)    automatic

########################################################################################
""")

while automate == 'm':
    clear() 
    password = getpass.getpass("Enter your wallet password:", stream=None)
    try:
        wallet_object.decrypt(password) #exception thrown if password wrong
        with open("cracked_password.txt", 'w') as f:
            f.write(password + '\n')
        input("Wallet decrypted. Hit <enter> to exit.")
        sys.exit(0)

    except Exception as e:
        clear()
        print("try again")
        continue

possibilities = input(f"""
########################################################################################

    If you don't wish to add any custom words or characters to the search, and just 
    use a text file of possible words instead, just hit <enter>. 

    Otherwise, please enter some words or characters you think might be in the
    password, separated with commas. If you think you might have commas in the
    password, you can add them later. Any whitespace you add will be included 
    intentionally so don't type any whitespace if your possible password doesn't have 
    any.

########################################################################################
""")

p_list = []
for i in possibilities.split(','):
    p_list.append(i) 

while True:
    clear()
    dictionary_path = input(f"""
######################################################################################## 

    Would you like to include a text file with a list of possible words in addition
    to any words you added manually?

    If so, type in the path of the file, then hit <enter>. 

    Note the file should have a word/character(s), one on each line. (Each new line
    character will be stripped).
    
    Otherwise, just hit <enter> alone if you don't wish to use a file.
      
########################################################################################
""")
    if dictionary_path == "": 
        break
    if dictionary_path[0] != '.' or dictionary_path[0] != '/':
        input("""File path should start with '.' or '/'. Hit <enter> to try again.""")
        continue
    try:
        with open(dictionary_path, 'r') as f:
            for line in f:
                p_list.append(line.rstrip('\n'))
        break
    except Exception as e:
        input(e)
        sys.exit(0)

#populated so far:
    #wallet_path
    #wallet_object
    #automate=m or a
    #password (if automate = m)
    #possibilities (commaa separated string)
    #p_list (list of possibilites)
    #dictionary_path

#iterate password options...

#decrypt with each option...
#wallet_object.decrypt(password) #exception thrown if password wrong



##unfinished
