#!/bin/bash

export HCPPIPEDIR=/net/pepper/ivy_data/workflow/workflow/HCPpipelines
export CARET7DIR=/net/pepper/ivy_data/workflow/workflow/bin/workbench/bin_rh_linux64
export OPENBLAS_NUM_THREADS=1


Subject=${1}
TASK=${2}

Task="task-${TASK}"
FreesurferFolder="/net/pepper/ivy_data/workflow/results/${Subject}/freesurfer/${Subject}"

ResultsFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func"
ROIsFolder="${HCPPIPEDIR}/global/templates/standard_mesh_atlases/"
LowResMesh="32"
DownSampleFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/fsaverage_LR${LowResMesh}k"


for i in task-gaze_run-01_hp200_s2_level1.feat task-gaze_run-02_hp200_s2_level1.feat task-gaze_run-03_hp200_s2_level1.feat task-gaze_run-04_hp200_s2_level1.feat task-gaze_run-05_hp200_s2_level1.feat task-gaze_run-06_hp200_s2_level1.feat
do
if [[ -e ${ResultsFolder}/${i}/L_SurfaceStats/ && -e ${ResultsFolder}/${i}/R_SurfaceStats/ && -e ${ResultsFolder}/${i}/SubcorticalVolumeStats/ ]]
then
FEATDir="${ResultsFolder}/${i}"
for Subcortical in ${FEATDir}/SubcorticalVolumeStats/*nii.gz ; do
File=$( basename $Subcortical .nii.gz );
${CARET7DIR}/wb_command -cifti-create-dense-timeseries ${FEATDir}/GrayordinatesStats/${File}.dtseries.nii -volume $Subcortical $ROIsFolder/Atlas_ROIs_LPI.2.nii.gz -left-metric ${FEATDir}/L_SurfaceStats/${File}.func.gii -roi-left ${ROIsFolder}/L.atlasroi.${LowResMesh}k_fs_LR.shape.gii -right-metric ${FEATDir}/R_SurfaceStats/${File}.func.gii -roi-right ${ROIsFolder}/R.atlasroi.${LowResMesh}k_fs_LR.shape.gii
done
fi
done
