import subprocess

def check_chocolatey():
    try:
        subprocess.run(["choco", "--version"], check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def install_chocolatey():
    try:
        command = (
            r'Set-ExecutionPolicy Bypass -Scope Process -Force; '
            r'[System.Net.ServicePointManager]::SecurityProtocol = '
            r'[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; '
            r'iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))'
        )
        subprocess.run(["powershell", "-Command", command], check=True)
        print("Chocolatey installed successfully.")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to install Chocolatey: {e.stderr}")

def check_curl():
    try:
        subprocess.run(["curl", "--version"], check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def install_curl_with_chocolatey():
    try:
        subprocess.run(["choco", "install", "curl", "-y"], check=True)
        print("curl installed successfully.")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to install curl with Chocolatey: {e.stderr}")

def main():
    try:
        # Check if Chocolatey is installed
        if check_chocolatey():
            print("Chocolatey is already installed.")
        else:
            print("Chocolatey is not installed. Installing Chocolatey...")
            install_chocolatey()

        # Check if curl is installed
        if check_curl():
            print("curl is already installed.")
        else:
            print("curl is not installed. Installing curl with Chocolatey...")
            install_curl_with_chocolatey()

        # Additional logic for downloading and installing Bitcoin Core can be added here

    except Exception as e:
        print(f"An error occurred: {e}")

# Run the main function
if __name__ == "__main__":
    main()
