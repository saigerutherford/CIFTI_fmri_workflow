#!/bin/bash

START=$1
STOP=$2

SUBLIST=/scratch/ivytso_root/ivytso1/shared_data/SZG2/data/good_subs.txt
SCRIPTDIR=/scratch/ivytso_root/ivytso1/shared_data/SZG2
LOG_DIR=/scratch/ivytso_root/ivytso1/shared_data/SZG2/logs

for IDX in `seq ${START} ${STOP}`
do
    SUB=`sed "${IDX}q;d" ${SUBLIST}`
    mkdir -p ${LOG_DIR}/${SUB}/
    export SUB
    echo sbatch --job-name ${SUB}_fmriprep \
	--output=${LOG_DIR}/${SUB}/slurm_%j.log \
	${SCRIPTDIR}/fmriprep.master
    sbatch --job-name ${SUB}_fmriprep \
        --output=${LOG_DIR}/${SUB}/slurm_%j.log \
	${SCRIPTDIR}/fmriprep.master
done
