#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

idSet = set([])

for line in sys.stdin:
    rec = line.strip().split("\t")
    id = rec[0]
    idSet.add(id)

for id in idSet:
	print id + "\t0\t" + str(len(idSet))
