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
if len(os.listdir("/home/parman/parmanode/parmabox")) == 0:
    input("No wallet file detected in ParmaBox directory. Hit <enter>. Exiting.")
    sys.exit(0)

#set walletpath if there is only one file there.
try:
    if len(os.listdir("/home/parman/parmanode/parmabox")) == 1 : 
        walletpath=f"/home/parman/parmanode/parmabox/{os.listdir("/home/parman/parmanode/parmabox")[0]}"
except Exception as e: 
    input(e)
    sys.exit(1)

input("pause. hit enter")

while len(os.listdir("/home/parman/parmanode/parmabox")) != 1 :
    clear()
    print(f"""
########################################################################################      

    Please type the name of the wallet file to crack. The file needs to be moved or
    copied to the Parmabox directory for the script to find the file.

    q or Q will exit.

    Current files in ParmaBox directory:
    """)
    
    for file in os.listdir("/home/parman/parmanode/parmabox"): print("    " , file)

input("pause")
    walletpath = input(f""" 
########################################################################################
""")
    if walletpath.lower() == "q": sys.exit(0)
    if walletpath == "": 
        input("""Hit <enter> to try again""")
        clear()
        continue
    walletpath = f"/home/parman/parmanode/parmabox/{walletpath}"
    break
input("pause")

try:
    wallet_object = WalletStorage(walletpath)
except Exception as e:
    input(e)
    sys.exit(1)


if not wallet_object.file_exists():
    input("Does not seem to be an Electrum Wallet. Hit <enter>. Exiting.")
    sys.exit(0)

if not wallet_object.is_encrypted():
    input("Good news, this wallet isn't encrypted. Hit <enter>. Exiting.")
    sys.exit(0)

clear()
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

clear()
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

while True:
    clear()
    combinations = input("""
######################################################################################## 

    How many combination positions would you like to try (1 to 9).
    
    Enter a value and hit <enter>

    Or q and <enter> to quit.
    
######################################################################################## 
""")
    if combinations.upper() == 'Q': sys.exit(0)
    if len(combinations) != 1:
        input("One digit only. Try again. Hit <enter>")
        continue
    if not combinations.isdigit():
        input("Must be a single digit. Try again. Hit <enter>")
        continue
    break

clear()
combinations = int(combinations)
print(f"combinations = {combinations}")
input("Hit <enter> to start search.")
clear()

for i in p_list:

    try:
        print(f"{i}")
        wallet_object.decrypt(i) #exception thrown if password wrong
        with open("cracked_password.txt", 'w') as f:
            f.write(i + '\n')
        input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
        sys.exit(0)

    except Exception as e:
        if combinations == 1: continue
        pass 

    for i in p_list:

        for j in p_list:

            try:
                print(f"{i+j}")
                wallet_object.decrypt(i+j) #exception thrown if password wrong
                with open("cracked_password.txt", 'w') as f:
                    f.write(i + '\n')
                input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                sys.exit(0)

            except Exception as e:
                if combinations == 2: continue
                pass
            
            for k in p_list:

                try:
                    print(f"{i+j+k}")
                    wallet_object.decrypt(i+j+k) #exception thrown if password wrong
                    with open("cracked_password.txt", 'w') as f:
                        f.write(i + '\n')
                    input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                    sys.exit(0)

                except Exception as e:
                    if combinations == 3: continue
                    pass

                for l in p_list:

                    try:
                        print(f"{i+j+k+l}")
                        wallet_object.decrypt(i+j+k+l) #exception thrown if password wrong
                        with open("cracked_password.txt", 'w') as f:
                            f.write(i + '\n')
                        input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                        sys.exit(0)

                    except Exception as e:
                        if combinations == 4: continue
                        pass

                    for m in p_list:

                        try:
                            print(f"{i+j+k+l+m}")
                            wallet_object.decrypt(i+j+k+l+m) #exception thrown if password wrong
                            with open("cracked_password.txt", 'w') as f:
                                f.write(i + '\n')
                            input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                            sys.exit(0)

                        except Exception as e:
                            if combinations == 5: continue
                            pass 

                        for n in p_list:

                            try:
                                print(f"{i+j+k+l+m+n}")
                                wallet_object.decrypt(i+j+k+l+m+n) #exception thrown if password wrong
                                with open("cracked_password.txt", 'w') as f:
                                    f.write(i + '\n')
                                input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                                sys.exit(0)

                            except Exception as e:
                                if combinations == 6: continue
                                pass 

                            for o in p_list:

                                try:
                                    print(f"{i+j+k+l+m+n+o}")
                                    wallet_object.decrypt(i+j+k+l+m+n+o) #exception thrown if password wrong
                                    with open("cracked_password.txt", 'w') as f:
                                        f.write(i + '\n')
                                    input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                                    sys.exit(0)

                                except Exception as e:
                                    if combinations == 7: continue
                                    pass 

                                for p in p_list:

                                    try:
                                        print(f"{i+j+k+l+m+n+o+p}")
                                        wallet_object.decrypt(i+j+k+l+m+n+o+p) #exception thrown if password wrong
                                        with open("cracked_password.txt", 'w') as f:
                                            f.write(i + '\n')
                                        input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                                        sys.exit(0)

                                    except Exception as e:
                                        if combinations == 8: continue
                                        pass 

                                    for q in p_list:

                                        try:
                                            print(f"{i+j+k+l+m+n+o+p+q}")
                                            wallet_object.decrypt(i+j+k+l+m+n+o+p+q) #exception thrown if password wrong
                                            with open("cracked_password.txt", 'w') as f:
                                                f.write(i + '\n')
                                            input("Wallet decrypted. Password written to 'cracked_password.txt'. Hit <enter> to exit.")
                                            sys.exit(0)

                                        except Exception as e:
                                            continue
                                    
        


input(f"""Password not found.""")
sys.exit(0)    

#iterate password options...

#decrypt with each option...
#wallet_object.decrypt(password) #exception thrown if password wrong



##unfinished

#Variables
    #wallet_path
    #wallet_object
    #automate=m or a
    #password (if automate = m)
    #possibilities (commaa separated string)
    #p_list (list of possibilites)
    #dictionary_path --> then appended to p_list