#!/bin/bash

export HCPPIPEDIR=/net/pepper/ivy_data/workflow/workflow/HCPpipelines
export CARET7DIR=/net/pepper/ivy_data/workflow/workflow/bin/workbench/bin_rh_linux64
export OPENBLAS_NUM_THREADS=1

Subject=${1}
TASK=${2}
FinalSmoothingFWHM=${3}
TemporalFilter=${4}
includeMotion=${5}
includeCompCor=${6}
includeCensor=${7}
includeCosine=${8}
includeAROMA=${9}
FDthresh=${10}
NPC=${11}
Trim=${12}

Task="task-${TASK}"

echo ${Subject} ${FinalSmoothinFWHM} ${TemporalFilter} ${Task}

#FreesurferFolder="/tmp/workflow_${SUB}/${Subject}/${Session}/func/"
FreesurferFolder="/net/pepper/ivy_data/workflow/results/${Subject}/freesurfer/${Subject}"
#OrigConfoundFile="/tmp/workflow_${SUB}/${Subject}/${Session}/func/${Subject}_${Session}_${Task}_${Run}_desc-confounds_regressors"

ResultsFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func"
ROIsFolder="${HCPPIPEDIR}/global/templates/standard_mesh_atlases"
LowResMesh="32"
DownSampleFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/fsaverage_LR${LowResMesh}k"
LevelOnefMRIName="${Task}_${Run}_space-fsLR_den-91k_bold"
LevelOnefsfName="${Task}_${Run}"
GrayordinatesResolution="2"
OriginalSmoothingFWHM="0"
#Confound="${Task}_${Run}_confound.txt"
#OutConfoundFile="${ResultsFolder}/${Subject}_${Session}_${Confound}"
VolumeBasedProcessing="NONE"
RegName="NONE"
Parcellation="NONE"
ParcellationFile="NONE"

mkdir -p ${DownSampleFolder}

#cp ${SCRIPTDIR}/temp/${SUB}/${SESSION}/${TASK}/* ${ResultsFolder}/
#cp ${SCRIPTDIR}/data/task-${TASK}*.fsf ${ResultsFolder}/

#need to first generate surface gii images
for hemi in l r
do
    HEMI=${hemi^^}
    ${CARET7DIR}/wb_shortcuts -freesurfer-resample-prep ${FreesurferFolder}/surf/${hemi}h.white ${FreesurferFolder}/surf/${hemi}h.pial ${FreesurferFolder}/surf/${hemi}h.sphere.reg ${ROIsFolder}/resample_fsaverage/fs_LR-deformed_to-fsaverage.${HEMI}.sphere.32k_fs_LR.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.midthickness.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.midthickness.${LowResMesh}k_fs_LR.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.sphere.reg.surf.gii
done

for Run in run-01 run-02 run-03 run-04 run-05 run-06
do
    OrigConfoundFile="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func/${Subject}_${Task}_${Run}_desc-confounds_regressors"
    LevelOnefMRIName="${Task}_${Run}_space-fsLR_den-91k_bold"
    LevelOnefsfName="${Task}_${Run}"
    Confound="${Task}_${Run}_confound.txt"
    OutConfoundFile="${ResultsFolder}/${Subject}_${Confound}"

    #figure out time to trim
    npts=`${CARET7DIR}/wb_command -file-information ${ResultsFolder}/${Subject}_${LevelOnefMRIName}.dtseries.nii -no-map-info -only-number-of-maps`
    Trim=0
    echo "/net/pepper/ivy_data/workflow/workflow/code/BuildConfound.R ${OrigConfoundFile} ${OutConfoundFile} ${Trim} ${includeMotion} ${includeCompCor} ${includeCensor} ${includeCosine} ${includeAROMA} ${FDthresh} ${NPC}"

    /net/pepper/ivy_data/workflow/workflow/code/BuildConfound.R ${OrigConfoundFile} ${OutConfoundFile} ${Trim} ${includeMotion} ${includeCompCor} ${includeCensor} ${includeCosine} ${includeAROMA} ${FDthresh} ${NPC}
	chmod +x ${Subject}_${Task}_${Run}_confound.txt

    /net/pepper/ivy_data/workflow/TaskfMRILevel1.sh ${Subject} ${ResultsFolder} ${ROIsFolder} ${DownSampleFolder} ${LevelOnefMRIName} ${LevelOnefsfName} ${LowResMesh} ${GrayordinatesResolution} ${OriginalSmoothingFWHM} ${Confound} ${FinalSmoothingFWHM} ${TemporalFilter} ${VolumeBasedProcessing} ${RegName} ${Parcellation} ${ParcellationFile}
done


