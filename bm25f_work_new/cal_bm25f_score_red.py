#!/usr/bin/env python
# coding=utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf8')

weightList = [0.7, 0.3]
BList = [0.75, 0.2]
K = 1.2

def cal_freqWeight(freq, dl, avgdl, B):
	rightSide = freq / ((1-B) + (B*dl)/avgdl)
	return rightSide

lastid = ""
result = ""

for line in sys.stdin:
	rec = line.decode('utf-8').strip().split("\t")
	id        = rec[0]
	totalDocs = int(rec[1])
	totalIdf  = float(rec[2])
	term      = rec[3]

	avgLength = 0.0
	for i in range(6, len(rec), 4): avgLength += float(rec[i])
	epsilon = 1.0 / (totalDocs*avgLength)

	# idf
	idf = totalIdf if totalIdf > 0.0 else epsilon
	# freqSum
	j = 0
	freqSum = 0.0
	for i in range(4, len(rec), 4):
		freq  = float(rec[i])
		dl    = float(rec[i+1])
		avgdl = float(rec[i+2])

		freqSum += weightList[j] * cal_freqWeight(freq, dl, avgdl, BList[j])
		j += 1
	# weight
	weight = (idf * freqSum) / (K + freqSum)

	# result
	if lastid == id: result += "\t" + term + " " + str(weight)
	else:
		if result != "": print result
		result = id + "\t" + term + " " + str(weight)
		lastid = id

if result != "": print result
