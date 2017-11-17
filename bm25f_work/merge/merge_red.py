#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

avgdlList = []
idfList = []
totalDocs = ""
count = 1

for line in sys.stdin:
	rec = line.strip().split("\t")
	id   = rec[0]
	flag = rec[1]
	if flag == "0":
		avgdlList = []
		for i in range(2, len(rec)): avgdlList.append(rec[i])
		count = 1
	else:
		result = id
		if count % 2 == 0:
			j = 0
			for i in range(2, len(rec)):
				if (i-3) % 4 == 0: continue
				result += "\t" + rec[i]
				if (i-5) % 4 == 0:
					result += "\t" + avgdlList[j] + "\t" + idfList[j]
					j += 1
			result += "\t" + totalDocs
			print result
		else:
			idfList = []
			for i in range(4, len(rec), 3): idfList.append(rec[i])
			totalDocs = rec[len(rec)-1]

		count += 1
