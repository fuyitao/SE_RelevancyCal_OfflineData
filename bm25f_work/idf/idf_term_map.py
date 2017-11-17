#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

for line in sys.stdin:
	rec = line.strip().split("\t")
	id   = rec[0]
	j = 0
	for i in range(2, len(rec), 4):
		word = rec[i] + "_" + str(j)
		freq = ("1" if rec[i+2] != "0" else "0")
		print word + "\t" + id + "\t" + freq
		j += 1
