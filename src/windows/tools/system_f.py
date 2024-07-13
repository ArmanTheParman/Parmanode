from config.variables_f import *
import requests, time, atexit, platform, ctypes, os

def counter(type):
    if type == "rp":
        with rp_counter.open('r') as f:
            rpcount = f.read().strip()
            newcount = int(rpcount) + 1
        with rp_counter.open('w') as f:
            f.write(str(newcount) + '\n')
        return 0
    if type == "motd":
        with motd_counter.open('r') as f:
            motdcount = f.read().strip()
            newcount = int(motdcount) + 1
        with motd_counter.open('w') as f:
            f.write(str(newcount) + '\n')


def check_updates(compiled_version):
    if pco.grep("update_reminders_off"):
        return 0
    url = "https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf" 
    params = {'_': int(time.time())}  # Adding a unique timestamp parameter
    try:
        response = requests.get(url, params=params).text.split('\n')
        latest_winMajor = int(response[5].split("=")[1])
        latest_winMinor = int(response[6].split("=")[1])
        latest_winPatch = int(response[7].split("=")[1])
        print(latest_winPatch)  

        if (latest_winMajor, latest_winMinor, latest_winPatch) > (compiled_version):
            return "outdated"
        else:
            return "uptodate"

    except Exception as e:
        print(f"error when checking update, {e}")
        return "error"

def cleanup():
    """Will execute when Parmanode quits"""
    print(f"{reset}")
    tmp.unlink() #deletes the file

atexit.register(cleanup) 

def os_is():
    """Windows, Darwin, or Linux is returned"""
    return platform.system()

    
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def run_as_admin():
    # Re-launch the script with admin privileges
    script = os.path.abspath(sys.argv[0])
    params = ' '.join([script] + sys.argv[1:])
    try:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)
        sys.exit(0)
    except Exception as e:
        print(f"Failed to elevate: {e}")
        sys.exit(1)

def windows_version():
    return sys.getwindowsversion().major  #int