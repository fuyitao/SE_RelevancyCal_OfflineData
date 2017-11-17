#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

dlDict_List = []

for line in sys.stdin:
	rec = line.strip().split("\t")
	id = rec[0]

	j = 0
	for i in range(5, len(rec), 4):
		dl = int(rec[i])
		if len(dlDict_List) > j: dlDict_List[j][id] = dl
		else:
			dlDict = {}
			dlDict[id] = dl
			dlDict_List.append(dlDict)
		j += 1

avgdlList = []
for i in range(len(dlDict_List)):
	avgdl = float(sum(dlDict_List[i].values())) / len(dlDict_List[i])
	avgdlList.append(avgdl)

for id in dlDict_List[0]:
	result = id + "\t0"
	for i in range(len(dlDict_List)): result += "\t" + str(avgdlList[i])
	print result
