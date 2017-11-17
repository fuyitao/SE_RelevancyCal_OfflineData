#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys, math

def calIDF(cid_num, word_num):
	if word_num == '0': return 0.0
	denominator = float(cid_num) - float(word_num) + 0.5
	numerator   = float(word_num) + 0.5
	
	IDF = math.log(denominator / numerator)
	return IDF

cid_num = 0
idfList = []
lastId = ""
lastWord = ""

for line in sys.stdin:
	rec = line.strip().split("\t")
	id   = rec[0]
	flag = rec[1]
	if flag == "0":
		cid_num = rec[2]
		if lastId != "":
			result = lastId + "\t1"
			for tmp_idf in idfList: result += "\t" + lastWord + "\t0\t" + str(tmp_idf)
			result += "\t" + cid_num
			print result
		lastId   = ""
		lastWord = ""
	else:
		word = rec[2]
		if lastWord != word:
			if lastWord != "":
				result = lastId + "\t1"
				for tmp_idf in idfList: result += "\t" + lastWord + "\t0\t" + str(tmp_idf)
				result += "\t" + cid_num
				print result
				idfList = []
			lastId   = id
			lastWord = word

		word_num = rec[4]
		idf = calIDF(cid_num, word_num)
		idfList.append(idf)

result = lastId + "\t1"
for tmp_idf in idfList: result += "\t" + lastWord + "\t0\t" + str(tmp_idf)
result += "\t" + cid_num
print result
