import sys, copy
from ParmaWallet.classes.FieldElement import FieldElement
from ParmaWallet.classes.point import Point
from ParmaWallet.functions.PW_functions import Print_point, Find_order
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

