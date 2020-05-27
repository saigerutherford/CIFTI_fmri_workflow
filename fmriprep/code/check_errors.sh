#!/bin/bash

#need to check for presence of error in any log files for this subject

count=`grep -i -l error ${LOG_DIR}/${SUB}/${SESSION}/0*.log  | wc -l`

if [ ${count} -gt 0 ]; then
    exit 1
fi
exit 0


