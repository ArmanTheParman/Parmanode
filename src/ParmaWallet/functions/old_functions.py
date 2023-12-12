from ParmaWallet.classes.point import * 
from ParmaWallet.classes.FieldElement import * 
from ParmaWallet.classes.S256 import *
import copy, hashlib


def myhash(data, algorithm="256",digest="hex"):
    if algorithm=="256" and digest=="hex":
        return hashlib.sha256(data).hexdigest()
    if algorithm=="256" and digest=="byte":
        return hashlib.sha256(data).digest()
    raise ValueError ("Unsupported algorithm or digest")

def Print_point(xxx):
    print(xxx)

def Find_order(xxx):
    print("Finding the order...")
    infinity = Point(None,None,xxx.a,xxx.b)
    add=copy.copy(xxx)
    counter = 0

    while add != infinity:
        add += xxx
        counter += 1
        
    print(counter)