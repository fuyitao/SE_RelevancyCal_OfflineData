#!/bin/bash

sourceFile=$1
targetFile=$2

sourceNum=`wc -l ${sourceFile} | awk -F " " '{ print $1 }'`
targetNum=`wc -l ${targetFile} | awk -F " " '{ print $1 }'`

if [ $sourceNum == $targetNum ]; then
	echo "true"
else
	echo "false"
fi
