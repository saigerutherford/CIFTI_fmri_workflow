#!/bin/bash

START=$1
STOP=$2
TASK=$3

SUBLIST=/scratch/sripada_root/sripada/shared_data/workflow/data/cursubs
SCRIPTDIR=/scratch/sripada_root/sripada/shared_data/workflow
LOG_DIR=${SCRIPTDIR}/logs/${TASK}/

for IDX in `seq ${START} ${STOP}`
do
    SUB=`sed "${IDX}q;d" ${SUBLIST}`
    SESSION=baselineYear1Arm1
    mkdir -p ${LOG_DIR}/${SUB}/${SESSION}
    export SUB
    export SESSION
    export TASK
    echo sbatch --job-name ${SUB}_${TASK} \
	--output=${LOG_DIR}/${SUB}/${SESSION}/slurm_%j.log \
	${SCRIPTDIR}/task.master
    sbatch --job-name ${SUB}_${TASK} \
        --output=${LOG_DIR}/${SUB}/${SESSION}/slurm_%j.log \
	${SCRIPTDIR}/task.master
done
