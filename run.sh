#!/bin/bash

curr_path=`pwd`
php_path="/home/rank/viw/drive/bin/php"
hadoop_path="/usr/local/webserver/hadoop/bin/hadoop"
hadoop_output="/user/rank/fuyitao/xihuan_article/xihuan_articleRelevancy"

outFile="bm25f_score"
result="xihuan_articleRelevancy"

####  run code  ####
sh -x mapred_relevancy_bm25f.sh
sleep 1s
####################

####  get data  ####
cd ${curr_path}/dict
${hadoop_path} fs -get ${hadoop_output}/${outFile}
if [ -f "${result}" ]; then
	mv ${result} ${result}_old
fi

cat ${outFile}/part-* > ${result}

if [ ! -f "${result}" ] || [ ! -s "${result}" ]; then
	cp -p ${result}_old ${result}
	ip="10.2.11.64"
	reason="相关性没有${result}数据"
	${php_path} ${curr_path}/msg.php ${ip} ${reason}
	if [ -d "${outFile}" ]; then
		rm -rf ${outFile}
	fi
	exit
fi
if [ -d "${outFile}" ]; then
	rm -rf ${outFile}
fi
####################

####  check数据  ####
cd ${curr_path}/dict
cidFile="idf_cid"
if [ -d "${cidFile}" ]; then
	rm -rf ${cidFile}
fi
${hadoop_path} fs -get ${hadoop_output}/${cidFile}
judge=`sh ${curr_path}/check.sh ${cidFile}/part-00000 ${result}`
if [ $judge == "false" ]; then
	ip="10.2.11.64"
	reason="${result}数据前后数量不一致"
	${php_path} ${curr_path}/msg.php ${ip} ${reason}
	exit
fi
#####################
