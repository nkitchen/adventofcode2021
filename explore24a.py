#!/usr/bin/env python3

import numpy as np
from cpmpy import *
from collections import namedtuple

Param = namedtuple('Param', 'zd c a')
params = [
    Param(False, 14, 7),
    Param(False, 12, 4),
    Param(False, 11, 8),
    Param(True, -4, 1),
    Param(False, 10, 5),
    Param(False, 10, 14),
    Param(False, 15, 12),
    Param(True, -9, 10),
    Param(True, -9, 5),
    Param(False, 12, 7),
    Param(True, -15, 6),
    Param(True, -7, 8),
    Param(True, -10, 4),
    Param(True, 0, 6),
]
n = len(params)

# add z y     z_1 = (w_0 == z_0 % 26 + 14) ? z_0 : w_0 + 7 + 26*z_0

w = intvar(1, 9, shape=(n,), name="w")
zq = intvar(-100000000000, 100000000000, shape=(n,), name="zq")
zr = intvar(0, 25, shape=(n,), name="zr")
z = 26 * zq + zr

model = Model()

sel = []
for i, p in enumerate(params):
    if i == 0:
        zq_p = 0
        zr_p = 0
        z_p = 0
    else:
        zq_p = zq[i - 1]
        zr_p = zr[i - 1]
        z_p = z[i - 1]

    if p.zd:
        model += ((w[i] != zr_p + p.c) | (z[i] == zq_p))
        model += ((w[i] == zr_p + p.c) | (z[i] == w[i] + p.a + 26 * zq_p))
    else:
        model += ((w[i] != zr_p + p.c) | (z[i] == z_p))
        model += ((w[i] == zr_p + p.c) | (z[i] == w[i] + p.a + 26 * z_p))
    sel.append(w[i] == zr_p + p.c)

model += (z[-1] == 0)

obj = 0
for i in range(n):
    obj = 10 * obj + w[i]
model.maximize(obj)

if model.solve():
    print(w.value())
    print(z.value())

    for i in range(n):
        print(sel[i].value())

else:
    print("fail")

# 0.9s
