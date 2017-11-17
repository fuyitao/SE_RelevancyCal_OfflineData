#!/usr/bin/env python
#-*- coding: utf-8 -*-

import sys

for line in sys.stdin:
	rec = line.strip().split("\t")
	id   = rec[0]
	word = rec[2]

	print word + "\t" + id
