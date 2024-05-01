import sys, copy
from classes.FieldElement import * 
from classes.point import * 
from functions.old_functions import *
prime=223
x=15
y=86
x2=36
y2=111

f1 = FieldElement(x, prime)
f2 = FieldElement(y, prime)
f3 = FieldElement(x2, prime)
f4 = FieldElement(y2, prime)
a = FieldElement(0, prime)
b = FieldElement(7, prime)

xxx=Point(f1, f2, a, b)

