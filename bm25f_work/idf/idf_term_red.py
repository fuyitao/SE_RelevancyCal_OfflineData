#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

curTerm = ""
idDict = {}

for line in sys.stdin:
	rec = line.strip().split("\t")
	word   = rec[0]
	cateid = rec[1]
	freq   = int(rec[2])

	if curTerm == word:
		idDict[cateid] = freq
	else:
		docnum  = sum(idDict.values())
		for id in idDict:
			term = curTerm[: len(curTerm)-2]
			flag = curTerm[len(curTerm)-1]
			if idDict[id] == 0: num = 0
			else: num = docnum
			print id + "\t1\t" + term + "\t" + flag + "\t" + str(num)
		curTerm = word
		idDict.clear()
		idDict[cateid] = freq

docnum = sum(idDict.values())
for id in idDict:
	term = curTerm[: len(curTerm)-2]
	flag = curTerm[len(curTerm)-1]
	if idDict[id] == 0: num = 0
	else: num = docnum
	print id + "\t1\t" + term + "\t" + flag + "\t" + str(num)
