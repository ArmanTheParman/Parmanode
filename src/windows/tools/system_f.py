from config.variables_f import *
import requests, time, atexit, platform, sys, ctypes, psutil

def counter(type):
    if type == "rp":
        with rp_counter.open('r') as f:
            rpcount = f.read().strip()
            newcount = int(rpcount) + 1
        with rp_counter.open('w') as f:
            f.write(str(newcount) + '\n')
        return True
    if type == "motd":
        with motd_counter.open('r') as f:
            motdcount = f.read().strip()
            newcount = int(motdcount) + 1
        with motd_counter.open('w') as f:
            f.write(str(newcount) + '\n')


def check_updates(compiled_version):
    if pco.grep("update_reminders_off"):
        return True

    if pco.grep(f"{date}"): return True #check updates only once a day to save loading time checking url
    
    pco.remove("last_used=")
    pco.add(f"last_used={date}")

    url = "https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf" 
    params = {'_': int(time.time())}  # Adding a unique timestamp parameter
    try:
        response = requests.get(url, params=params).text.split('\n')
        latest_winMajor = int(response[5].split("=")[1])
        latest_winMinor = int(response[6].split("=")[1])
        latest_winPatch = int(response[7].split("=")[1])

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
    #tmp.unlink() #deletes the file

atexit.register(cleanup) 

def os_is():
    """Windows, Darwin, or Linux is returned"""
    return platform.system()


def run_as_admin(command, params=""):
    try:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", command, params, None, 1)
    except Exception as e:
        input(f"Error: {e}")


def is_process_running(process_name):
    # Iterate over all running processes
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            # Check if process name matches
            if process_name.lower() in proc.info['name'].lower():
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return False
