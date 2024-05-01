import multiprocessing
import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from recovery_words import *

def worker1(): 
    dosearch("/home/parman/Desktop/resultworker1.txt" 0, 1)   

def worker2(): 
    dosearch("/home/parman/Desktop/resultworker2.txt" 1, 2)   

def worker3(): 
    dosearch("/home/parman/Desktop/resultworker3.txt" 2, 3)   

process1 = multiprocessing.Process(target=worker1)
process1.start()  # Start the process
process2 = multiprocessing.Process(target=worker2)
process2.start()  # Start the process
process3 = multiprocessing.Process(target=worker3)
process3.start()  # Start the process




# def worker1(): 
#     dosearch(0, 200)   
# def worker2(): 
#     dosearch(200, 400)   
# def worker3(): 
#     dosearch(400, 600)   
# def worker4(): 
#     dosearch(600, 800)   
# def worker5(): 
#     dosearch(800, 1000)   
# def worker6(): 
#     dosearch(1000, 1200)   
# def worker7(): 
#     dosearch(1200, 1400)   
# def worker8(): 
#     dosearch(1400, 1600)   
# def worker9(): 
#     dosearch(1600, 1800)   
# def worker10(): 
#     dosearch(1800, 2000)   
# def worker1(): 
#     dosearch(2000, 2048)   