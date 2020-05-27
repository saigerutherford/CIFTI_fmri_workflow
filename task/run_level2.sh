#!/bin/bash

export HCPPIPEDIR=/net/pepper/ivy_data/workflow/workflow/HCPpipelines
export CARET7DIR=/net/pepper/ivy_data/workflow/workflow/bin/workbench/bin_rh_linux64
export OPENBLAS_NUM_THREADS=1

Subject=$1
FinalSmoothingFWHM=$2
TemporalFilter=$3
TASK=$4
Task="task-${TASK}"

echo ${Subject} ${FinalSmoothinFWHM} ${TemporalFilter} ${Task}

#FreesurferFolder="/tmp/workflow_${SUB}/freesurfer/${Subject}/surf"
#OrigConfoundFile="/tmp/workflow_${SUB}/${Subject}/${Session}/func/${Subject}_${Session}_${Task}_${Run}_desc-confounds_regressors"

ResultsFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func"
ROIsFolder="${HCPPIPEDIR}/global/templates/standard_mesh_atlases"
LowResMesh="32"
DownSampleFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/fsaverage_LR${LowResMesh}k"
#LevelOnefMRIName="${Task}_${Run}_space-T1w_desc-preproc_bold"
#LevelOnefsfName="${Task}_${Run}"
GraordinatesResolution="2"
#OriginalSmoothingFWHM="0"
#Confound="${Task}_${Run}_confound.txt"
#OutConfoundFile="${ResultsFolder}/${Subject}_${Session}_${Confound}"
VolumeBasedProcessing="NONE"
RegName="NONE"
Parcellation="NONE"
ParcellationFile="NONE"


LevelOnefMRINames="${Task}_run-01@${Task}_run-02@${Task}_run-03@${Task}_run-04@${Task}_run-05@${Task}_run-06@"
LevelOnefsfNames="${Task}_run-01@${Task}_run-02@${Task}_run-03@${Task}_run-04@${Task}_run-05@${Task}_run-06@"
LevelTwofsfName="${Task}"
LevelTwofMRIName="${Task}_level2"
/net/pepper/ivy_data/workflow/workflow/code/TaskfMRILevel2.sh ${Subject} ${ResultsFolder} ${DownSampleFolder} ${LevelOnefMRINames} ${LevelOnefsfNames} ${LevelTwofMRIName} ${LevelTwofsfName} ${LowResMesh} ${FinalSmoothingFWHM} ${TemporalFilter} ${VolumeBasedProcessing} ${RegName} ${Parcellation} 
