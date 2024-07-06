import os

version="0.0.1"

#directories
dp=os.path.expanduser("~/.parmanode")
os.makedirs(dp, exist_ok=True)

pp=os.path.expanduser("~/parman_programs")
os.makedirs(pp, exist_ok=True )

pn=os.path.expanduser("~/parman_programs/parmanode")
os.makedirs(pn, exist_ok=True )

pn=os.path.expanduser("~/parman_programs/parmanode")
os.makedirs(pn, exist_ok=True )

#path
os.environ['PYTHONPATH'] = os.path.expanduser("~/.parmanode") + os.pathsep + os.environ.get('PYTHONPATH', '')

