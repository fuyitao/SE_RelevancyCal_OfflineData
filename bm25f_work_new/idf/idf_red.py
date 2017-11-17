#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys, math

def calIDF(cid_num, word_num):
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

	if flag == "0": cid_num = rec[2]
	else:
		word = rec[2]
		word_num = rec[3]
		idf = calIDF(cid_num, word_num)
		print id + "\t1\t" + word + "\t0\t" + str(idf) + "\t" + str(cid_num)
