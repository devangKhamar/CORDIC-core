# -*- coding: utf-8 -*-
"""
Created on Tue Feb  5 09:16:16 2019

@author: Devang Khamar
"""
import math
from statistics import mean, variance
import decimal as d
from matplotlib import pyplot as plt

def cordic(theta, precision, iters):
    d.getcontext().prec = precision
    x = d.Decimal(0.6072529365169705)
    y = d.Decimal(0)
    z = d.Decimal.from_float(theta);
    gain = d.Decimal(1)
    for i in range(iters):
        angle = d.Decimal.from_float(math.atan(1/2**(i)))
        #print(hex(int(angle*2**15)))
        tx,ty = x,y
        if(z < 0):
            x = tx + ty/2**i
            y = ty - tx/2**i
            z = z + angle 
        else:
            x = tx - ty/2**i
            y = ty + tx/2**i
            z = z - angle
        gain = gain*d.Decimal(math.sqrt(1 + 2**(-2*i)))
    #print(f'Python cos(a): {math.cos(theta)} ')
    return [tx,ty, gain]

def printTable():
    #Table values
    k = [ math.atan(1/2**i) for i in range(0,14)]
    k = [ round(i*2**14) for i in k]
    for i in k:
        print(hex(i))
        
def printAngle(num, computed):
    print((180/math.pi)*(num/2**14))
    print((180/math.pi)*(math.asin(computed/2**14)))


iters = 2**16
widths = [i for i  in range(8,24,2)]

def genVecs():
    vecs = [0 for i in range(iters)]
    out_vec_cos = [0 for i in range(iters)]
    out_vec_sin = [0 for i in range(iters)]
    print("Generating vectors")
    for i in range(iters):
        theta = (math.pi/2)*(i/iters);        
        [cosv, sinv, gain] = cordic(theta, 14, 14)
        vecs[i] = (int(theta*2**14))
        if vecs[i] < 0 :
            vecs[i] = ~vecs[i] + 1
        out_vec_cos[i] = (int(cosv*2**14))
        out_vec_sin[i] = (int(sinv*2**14))
        if out_vec_sin[i] < 0 :
            out_vec_sin[i] = ~out_vec_sin[i] + 1
        
    print("Vectors Generated, Writing to file")
    with open("vecs.txt", 'w') as f:
        for i in range(len(vecs)):
            f.write(f'{vecs[i]}:{out_vec_cos[i]}:{out_vec_sin[i]}\n')
            #print(f'{vecs[i]}:{out_vec_cos[i]}:{out_vec_sin[i]}\n')
    print("Vectors written")

#genVecs()            
            

for p in widths:
    error = []
    for it in widths:
        accErr = []
        for i in range(iters):
            theta = (math.pi/2)*(i/iters);
            [cosv, sinv, gain] = cordic(theta, p, it)
            inter1 = abs(math.cos(theta) - float(cosv))
            inter2 = abs(math.sin(theta) - float(sinv))
            accErr.append(abs(math.sqrt(inter1**2 + inter2**2)))
        print(f'Precision: {p}, iters: {it}, Gain: {1/gain}')
        print(f'Error: {mean(accErr)*100}%  Varr: {variance(accErr)*100}%')
        error.append(mean(accErr)*100)
    print(f'Min error for {p} precision at : {widths[error.index(min(error))]}')
    plt.plot(widths,error)
plt.xlabel("Stages of Cordic")
plt.ylabel("Error %")
plt.legend(widths)
plt.title(" Cordic-Stages vs Error Trade-off")
'''
num = 0x6488
#num = (num/2**14)
print(num)
k = cordic(num,14, 14)
printAngle(num, 0x3fff)
'''