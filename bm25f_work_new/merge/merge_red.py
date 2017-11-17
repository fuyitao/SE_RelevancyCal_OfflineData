#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

avgdlList = []
totalDocs = ""
totalIdf  = ""
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
		result = id + "\t" + totalDocs + "\t" + totalIdf
		if count % 2 == 0:
			j = 0
			for i in range(2, len(rec)):
				if (i-3) % 4 == 0: continue
				result += "\t" + rec[i]
				if (i-5) % 4 == 0:
					result += "\t" + avgdlList[j]
					j += 1
			print result
		else:
			totalIdf  = rec[len(rec)-2]
			totalDocs = rec[len(rec)-1]

		count += 1
