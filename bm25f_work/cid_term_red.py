#!/usr/bin/env python
# coding=utf-8

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

stopSet = set([])
with open("bm25f_work/bm25f_work/stopwords.txt") as f:
	for line in f: stopSet.add(line.strip())

for line in sys.stdin:
	rec = line.strip().split("\1\t")
	if len(rec) != 6: continue
	cateid = rec[0]
	title_seg = rec[1]
	content_seg = rec[3]

	# 统计数据
	termSet     = set([])
	titleDict   = {}
	contentDict = {}
	segrec = title_seg.split(" ")
	for term in segrec:
		if term == "" or term in stopSet: continue
		if term in titleDict: titleDict[term] += 1
		else: titleDict[term] = 1
		termSet.add(term)
	segrec = content_seg.split(" ")
	for term in segrec:
		if term == "" or term in stopSet: continue
		if term in contentDict: contentDict[term] += 1
		else: contentDict[term] = 1
		termSet.add(term)

	# 生成结果
	title_dl   = str(sum(titleDict.values()))
	content_dl = str(sum(contentDict.values()))
	for term in termSet:
		result = cateid + "\t1"
		title_freq   = (str(titleDict[term]) if term in titleDict else "0")
		content_freq = (str(contentDict[term]) if term in contentDict else "0")

		result += "\t" + term + "\t1\t" + title_freq + "\t" + title_dl
		result += "\t" + term + "\t1\t" + content_freq + "\t" + content_dl
		print result
