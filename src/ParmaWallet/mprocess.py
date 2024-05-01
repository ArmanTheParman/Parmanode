import multiprocessing
import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from recovery_words import *

def worker1(): 
    dosearch(0, 200)   

worker1()