#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

curTerm = ""
idSet   = set([])

for line in sys.stdin:
	rec = line.strip().split("\t")
	term = rec[0]
	id   = rec[1]

	if curTerm == term:
		idSet.add(id)
	else:
		for tmpid in idSet: print tmpid + "\t1\t" + curTerm + "\t" + str(len(idSet))
		curTerm = term
		idSet.clear()
		idSet.add(id)

for tmpid in idSet: print tmpid + "\t1\t" + curTerm + "\t" + str(len(idSet))
