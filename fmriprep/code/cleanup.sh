#!/bin/bash

time cp -r /tmp/workflow_${SUB}/derivatives/fmriprep  ${OUTPUTDIR}/results/${SUB}
time cp -r /tmp/workflow_${SUB}/derivatives/freesurfer ${OUTPUTDIR}/results/${SUB}/ && rm -rf /tmp/workflow_${SUB}

