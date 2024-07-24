import subprocess
from config.variables_f import *
from tools.screen_f import set_terminal

#should also test for installes done and then recommend restart Parmanode or reboot.

def check_chocolatey():
    if subprocess.run(["choco", "--version"], check=True):
        return True
    else: 
        return False

def install_chocolatey():
    try:
        command = (
            r'Set-ExecutionPolicy Bypass -Scope Process -Force; '
            r'[System.Net.ServicePointManager]::SecurityProtocol = '
            r'[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; '
            r'iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))'
        )
        if subprocess.run(["powershell", "-Command", command], check=True):
            print("Chocolatey installed successfully.")
            pco.add("need_restart=True")

    except subprocess.CalledProcessError as e:
        return False

    return True

def check_git():
    try:
        subprocess.run(["git", "--version"], check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def check_curl():
    try:
        subprocess.run(["curl", "--version"], check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False
    
def install_git_with_chocolatey():
    try:
        subprocess.run(["choco", "install", "git", "-y"], check=True)
        print("git installed successfully.")
        pco.add("need_restart=True")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to install git with Chocolatey: {e.stderr}")

    return True

def install_curl_with_chocolatey():
    try:
        subprocess.run(["choco", "install", "curl", "-y"], check=True)
        print("curl installed successfully.")
        pco.add("need_restart=True")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to install curl with Chocolatey: {e.stderr}")

    return True

def check_gpg():
    try:
        subprocess.run(["gpg", "--version"], check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False
    
def install_gpg_with_chocolatey():

    try:
        subprocess.run(["choco", "install", "gpg", "-y"], check=True)
        print("gpg installed successfully.")
        pco.add("need_restart=True")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to install gog with Chocolatey: {e.stderr}")

    return True

def dependency_check():
    try:
        # Check if Chocolatey is installed
        if check_chocolatey():
            pass
            """Chocolatey is already installed."""
        else:
            print("Chocolatey is not installed. Installing Chocolatey...")
            install_chocolatey()

        # Check if git is installed
        if check_git():
            """git is already installed."""
            pass
        else:
            print("git is not installed. Installing git with Chocolatey...")
            install_git_with_chocolatey()

        # Check if curl is installed
        if check_curl():
            """curl is already installed."""
            pass
        else:
            print("curl is not installed. Installing curl with Chocolatey...")
            install_curl_with_chocolatey()

        # Check if gpg is installed
        if check_gpg():
            """gpg is already installed."""
            pass
        else:
            print("gpg is not installed. Installing gpg with Chocolatey...")
            install_gpg_with_chocolatey()

        # Additional logic for downloading and installing Bitcoin Core can be added here
        
        if pco.grep("need_restart"):
            set_terminal()
            pco.remove("need_restart")
            print("Because a dependency was installed, please restart Parmanode.") 
            quit()
        
        return True
        
    except Exception as e:
        print(f"An error occurred: {e}")
