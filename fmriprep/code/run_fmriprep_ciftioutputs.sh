#!/bin/bash

module load singularity

FMRIPREP=/sw/examples/singularity/fmriprep-20.0.4.simg
SURF_LICENSE=${SCRIPTDIR}/data/fs_license.txt

BIDS_DIR=/tmp/workflow_${SUB}/BIDS
OUTPUT_DIR=/tmp/workflow_${SUB}/derivatives
WORK_DIR=/tmp/workflow_${SUB}/work

# /home and /tmp are automatically available in the container
# -B host_dir:container_dir
# For example, -B /nfs/tarazlee/james:/data
# would make the data in /nfs/tarazlee/james visible at /data
# Do not mount over any standard directories within the container,
# e.g., never -B /usr/local:/usr/local

singularity run --cleanenv $FMRIPREP                                             \
    $BIDS_DIR $OUTPUT_DIR participant                                            \
    --nthreads ${NTHREADS}                                                       \
    --mem-mb ${MEMMB}                                                            \
    --fs-license-file=$SURF_LICENSE                                              \
    --participant-label=sub-${SUB}                                               \
    --fs-subjects-dir ${OUTPUT_DIR}/freesurfer/                                  \
    -w $WORK_DIR                                                                 \
    --ignore slicetiming                                                         \
    --cifti-output                                                               \
    --use-aroma                                                                  \
    --aroma-melodic-dimensionality -100                                          \
    --output-spaces anat fsaverage
