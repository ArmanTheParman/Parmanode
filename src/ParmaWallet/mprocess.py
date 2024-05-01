import multiprocessing
import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from recovery_words import *

def worker1(): 
    dosearch("/home/parman/Desktop/resultworker1.txt", 0, 1)   

def worker2(): 
    dosearch("/home/parman/Desktop/resultworker2.txt", 1, 2)   

def worker3(): 
    dosearch("/home/parman/Desktop/resultworker3.txt", 2, 3)   

def worker4(): 
    dosearch("/home/parman/Desktop/resultworker4.txt", 3, 4)   

def worker5(): 
    dosearch("/home/parman/Desktop/resultworker5.txt", 4, 5)   

def worker6(): 
    dosearch("/home/parman/Desktop/resultworker6.txt", 5, 6)   

def worker7(): 
    dosearch("/home/parman/Desktop/resultworker7.txt", 6, 7)   
    
def worker8(): 
    dosearch("/home/parman/Desktop/resultworker8.txt", 7, 8)   

def worker9(): 
    dosearch("/home/parman/Desktop/resultworker9.txt", 8, 9)   

def worker10(): 
    dosearch("/home/parman/Desktop/resultworker10.txt", 9, 10)   
    
def worker11(): 
    dosearch("/home/parman/Desktop/resultworker11.txt", 10, 11)   

def worker12(): 
    dosearch("/home/parman/Desktop/resultworker12.txt", 11, 12)   

def worker13(): 
    dosearch("/home/parman/Desktop/resultworker13.txt", 12, 13)   

def worker14(): 
    dosearch("/home/parman/Desktop/resultworker14.txt", 13, 14)   

def worker15(): 
    dosearch("/home/parman/Desktop/resultworker15.txt", 14, 15)   


process1 = multiprocessing.Process(target=worker1)
process1.start()  
process2 = multiprocessing.Process(target=worker2)
process2.start()  
process3 = multiprocessing.Process(target=worker3)
process3.start()  
process4 = multiprocessing.Process(target=worker4)
process4.start()  
process5 = multiprocessing.Process(target=worker5)
process5.start()  
process6 = multiprocessing.Process(target=worker6)
process6.start()  
process7 = multiprocessing.Process(target=worker7)
process7.start()  
process8 = multiprocessing.Process(target=worker8)
process8.start()  
process9 = multiprocessing.Process(target=worker9)
process9.start()  
process10 = multiprocessing.Process(target=worker10)
process10.start()  
process11 = multiprocessing.Process(target=worker11)
process11.start()  
process12 = multiprocessing.Process(target=worker12)
process12.start()  
process13 = multiprocessing.Process(target=worker13)
process13.start()  
process14 = multiprocessing.Process(target=worker14)
process14.start()  
process15 = multiprocessing.Process(target=worker15)
process15.start()  




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