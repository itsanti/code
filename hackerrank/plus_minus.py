#!/bin/python3

import math
import os
import random
import re
import sys


def plusMinus(arr):
    pos_neg_zero = [0, 0, 0]
    for el in arr:
        if el < 0:
            pos_neg_zero[1] += 1
        elif el == 0:
            pos_neg_zero[2] += 1
        else:
            pos_neg_zero[0] += 1
    result = list(map(lambda x: round(x / len(arr), 6), pos_neg_zero))
    print(*result, sep='\n')
    
    

if __name__ == '__main__':
    n = int(input().strip())

    arr = list(map(int, input().rstrip().split()))

    plusMinus(arr)

