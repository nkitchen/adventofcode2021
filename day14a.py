#!/usr/bin/env python3

import fileinput
from collections import Counter
from pprint import pprint

def main():
    inp = fileinput.input()

    template = next(inp).rstrip()
    next(inp)

    rule = {}
    for line in inp:
        pair, ins = line.rstrip().split(' -> ')
        rule[pair] = ins

    pairCount = Counter()
    pairCount['.' + template[0]] = 1
    pairCount[template[-1] + '.'] = 1
    pairCount.update(template[i:i+2] for i in range(len(template) - 1))

    for step in range(10):
        newCount = Counter()
        for pair, n in pairCount.items():
            ins = rule.get(pair)
            if ins is None:
                assert '.' in pair
                newCount[pair] = n
            else:
                q = pair[0] + ins
                r = ins + pair[1]
                newCount[q] += n
                newCount[r] += n
        pairCount = newCount

    quant = Counter()
    for p, n in pairCount.items():
        elem = p[0]
        if elem != '.':
            quant[elem] += n

    print(sum(quant.values()))
    print(max(quant.values()) - min(quant.values()))

main()
