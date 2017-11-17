#!/usr/bin/env python
# coding=utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf8')

weightList = [0.6, 0.4]

def cal_weight(freq, dl, avgdl):
	K = 1.2
	B = 0.75
	rightSide = (freq * (K + 1)) / (freq + (K * (1 - B + (B * (dl / avgdl)))))
	return rightSide

lastid = ""
result = ""

for line in sys.stdin:
	rec = line.decode('utf-8').strip().split("\t")
	id        = rec[0]
	term      = rec[1]
	totalDocs = int(rec[len(rec)-1])
	docLength = 0.0
	avgLength = 0.0
	
	for i in range(3, len(rec), 5): docLength += float(rec[i])
	for i in range(4, len(rec), 5): avgLength += float(rec[i])
	epsilon = 1.0 / (totalDocs*avgLength)

	sum = 0.0
	j = 0
	for i in range(1, len(rec)-1, 5):
		freq  = int(rec[i+1])
		idf   = float(rec[i+4])

		if idf < 0.0: idf = epsilon
		rightSide = cal_weight(freq, docLength, avgLength)
#		rightSide += 1.0

		sum += (idf * rightSide) * weightList[j]

		j+=1

	if lastid == id: result += "\t" + term + " " + str(sum)
	else:
		if result != "": print result
		result = id + "\t" + term + " " + str(sum)
		lastid = id

if result != "": print result
