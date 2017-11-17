#!/bin/bash

###   配置文件   ###
time_start=`date +%s`
DATE=`date -d yesterday +%F`

work_file=""
logs_file=""
input=""
output=""
while read line
do
	if [[ "$line" =~ "work_file:" ]]; then work_file=${line:10}; fi
	if [[ "$line" =~ "logs_file:" ]]; then logs_file=${line:10}; fi
	if [[ "$line" =~ "input:" ]]; then input=${line:6}; fi
	if [[ "$line" =~ "output:" ]]; then output=${line:7}; fi
done < "config"

php_path="/home/rank/viw/drive/bin/php"
if [ "${work_file}" = "" ] || [ "${logs_file}" = "" ] || [ "${input}" = "" ] || [ "${output}" = "" ]; then
	ip="10.2.11.64"
	reason="xihuan_article相关性配置文件读取错误"
	${php_path} msg.php ${ip} ${reason}
	exit
fi
###################

HADOOP_BIN="/usr/local/webserver/hadoop/bin/hadoop"
STREAMING_JAR="/usr/local/webserver/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar"

PROJ_ROOT=`pwd`
cd ${PROJ_ROOT}

work=${work_file}
if [ -f '${work}.zip'   ]; then
    rm ${work}.zip
fi
zip -r ${work}.zip ${work}/

AUTHOR="fuyitao"
LOG_DIR="$PROJ_ROOT/${logs_file}"
CID_TERM_MODULE="cid_term"
IDF_TERM_MODULE="idf_term"
IDF_CID_MODULE="idf_cid"
IDF_MODULE="idf"
AVGDL_MODULE="avgdl"
MERGE_MODULE="merge"
BM25F_SCORE_MODULE="bm25f_score"

####################################
# hadoop path
INPUT="${input}/${DATE}"
HHOME="${output}"

# cid_term
CID_TERM_INPUT="$INPUT/part-*"
CID_TERM_OUTPUT="$HHOME/cid_term"
# idf_term
IDF_TERM_INPUT="$HHOME/cid_term/part-*"
IDF_TERM_OUTPUT="$HHOME/idf_term"
# idf_cid
IDF_CID_INPUT="$HHOME/cid_term/part-*"
IDF_CID_OUTPUT="$HHOME/idf_cid"
# idf
IDF_INPUT_TERM="$HHOME/idf_term/part-*"
IDF_INPUT_CID="$HHOME/idf_cid/part-*"
IDF_OUTPUT="$HHOME/idf"
# avgdl
AVGDL_INPUT="$HHOME/cid_term/part-*"
AVGDL_OUTPUT="$HHOME/avgdl"
# merge
MERGE_INPUT_CID_TERM="$HHOME/cid_term/part-*"
MERGE_INPUT_AVGDL="$HHOME/avgdl/part-*"
MERGE_INPUT_IDF="$HHOME/idf/part-*"
MERGE_OUTPUT="$HHOME/merge"
# bm25_score
BM25F_SCORE_INPUT="$HHOME/merge/part-*"
BM25F_SCORE_OUTPUT="$HHOME/bm25f_score"

# CID_TERM
#${HADOOP_BIN} fs -rm -r ${CID_TERM_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${CID_TERM_INPUT} \
#    -output ${CID_TERM_OUTPUT} \
#    -mapper cat \
#    -reducer ${work}/${work}/cid_term_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=997 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${CID_TERM_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${CID_TERM_MODULE}.msg 2>${LOG_DIR}/${CID_TERM_MODULE}.err
#
## IDF_TERM
#${HADOOP_BIN} fs -rm -r ${IDF_TERM_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${IDF_TERM_INPUT} \
#    -output ${IDF_TERM_OUTPUT} \
#    -mapper ${work}/${work}/idf/idf_term_map.py \
#    -reducer ${work}/${work}/idf/idf_term_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=997 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${IDF_TERM_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${IDF_TERM_MODULE}.msg 2>${LOG_DIR}/${IDF_TERM_MODULE}.err
#
## IDF_CID
#${HADOOP_BIN} fs -rm -r ${IDF_CID_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${IDF_CID_INPUT} \
#    -output ${IDF_CID_OUTPUT} \
#    -mapper cat \
#    -reducer ${work}/${work}/idf/idf_cid_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=1 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${IDF_CID_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${IDF_CID_MODULE}.msg 2>${LOG_DIR}/${IDF_CID_MODULE}.err
#
## IDF
#${HADOOP_BIN} fs -rm -r ${IDF_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${IDF_INPUT_TERM} \
#    -input ${IDF_INPUT_CID} \
#    -output ${IDF_OUTPUT} \
#    -mapper cat \
#	-reducer ${work}/${work}/idf/idf_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=997 \
#    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
#    -jobconf stream.num.map.output.key.fields=4 \
#    -jobconf num.key.fields.for.partition=1 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${IDF_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${IDF_MODULE}.msg 2>${LOG_DIR}/${IDF_MODULE}.err
#
## AVGDL
#${HADOOP_BIN} fs -rm -r ${AVGDL_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${AVGDL_INPUT} \
#    -output ${AVGDL_OUTPUT} \
#    -mapper cat \
#    -reducer ${work}/${work}/merge/avgdl_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=1 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${AVGDL_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${AVGDL_MODULE}.msg 2>${LOG_DIR}/${AVGDL_MODULE}.err
#
## MERGE
#${HADOOP_BIN} fs -rm -r ${MERGE_OUTPUT}
#
#${HADOOP_BIN} jar ${STREAMING_JAR} \
#    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
#    -input ${MERGE_INPUT_CID_TERM} \
#    -input ${MERGE_INPUT_AVGDL} \
#	-input ${MERGE_INPUT_IDF} \
#    -output ${MERGE_OUTPUT} \
#    -mapper cat \
#    -reducer ${work}/${work}/merge/merge_red.py \
#    -jobconf mapred.map.tasks=997 \
#    -jobconf mapred.reduce.tasks=997 \
#    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
#    -jobconf stream.num.map.output.key.fields=4 \
#    -jobconf num.key.fields.for.partition=1 \
#    -jobconf mapred.job.priority="NORMAL" \
#    -jobconf mapred.job.name="${MERGE_MODULE}_${AUTHOR}" \
#    1>${LOG_DIR}/${MERGE_MODULE}.msg 2>${LOG_DIR}/${MERGE_MODULE}.err

# BM25F_SCORE
${HADOOP_BIN} fs -rm -r ${BM25F_SCORE_OUTPUT}

${HADOOP_BIN} jar ${STREAMING_JAR} \
    -archives "${PROJ_ROOT}/${work}.zip#${work}" \
    -input ${BM25F_SCORE_INPUT} \
    -output ${BM25F_SCORE_OUTPUT} \
    -mapper cat \
    -reducer ${work}/${work}/cal_bm25f_score_red.py \
    -jobconf mapred.map.tasks=997 \
    -jobconf mapred.reduce.tasks=997 \
    -jobconf mapred.job.priority="NORMAL" \
    -jobconf mapred.job.name="${BM25F_SCORE_MODULE}_${AUTHOR}" \
    1>${LOG_DIR}/${BM25F_SCORE_MODULE}.msg 2>${LOG_DIR}/${BM25F_SCORE_MODULE}.err

time_finish=`date +%s`
diff_time=`expr $time_finish - $time_start`
echo "title_bm25score cost time: ${diff_time}s"
