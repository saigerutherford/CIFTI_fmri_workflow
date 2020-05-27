#!/bin/bash

ScriptDir=/net/pepper/ivy_data/workflow

#HCPPIPEDIR
export HCPPIPEDIR=/net/pepper/ABCD/Scripts/slab/CIFTI_task_test/HCPpipelines
export CARET7DIR=/net/parasite/HCP/Scripts/slab/cifti/workbench/bin_linux64
export OPENBLAS_NUM_THREADS=1 #for some reason not doing this really slows down film_gls

Subject=$1
FinalSmoothingFWHM=$2
TemporalFilter=$3
Task=$4
Run=$5
#pass in run or loop over run?
echo ${Subject} ${FinalSmoothinFWHM} ${TemporalFilter} ${Task} ${Run}
LOG=${ScriptDir}/Logs/${Subject}_${Task}_${Run}.log

SUB=`echo ${Subject} | sed 's/sub-//'`
FreesurferFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/freesurfer/${Subject}/surf"
OrigConfoundFile="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func/${Subject}_${Task}_${Run}_desc-confounds_regressors"

ResultsFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/func/"
fsfFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/"
ROIsFolder="/net/pepper/ABCD/Scripts/slab/CIFTI_task_test/HCPpipelines/global/templates/standard_mesh_atlases"
DownSampleFolder="/net/pepper/ivy_data/workflow/results/${Subject}/${Subject}/freesurfer/${Subject}/surf"
LevelOnefMRIName="${Task}_${Run}_space-fsLR_den-91k_bold"
LevelOnefsfName="${Task}_${Run}"
LowResMesh="32"
GrayordinatesResolution="2"
OriginalSmoothingFWHM="0"
Confound="${Task}_${Run}_confound.txt"
OutConfoundFile="${ResultsFolder}/${Subject}_${Confound}"
VolumeBasedProcessing="NONE"
RegName="NONE"
Parcellation="NONE"
ParcellationFile="NONE"

#need to first generate surface gii images
for hemi in l r
do
    HEMI=${hemi^^}
    #add a check here in case they already exist to save time
    wb_shortcuts -freesurfer-resample-prep ${FreesurferFolder}/${hemi}h.white ${FreesurferFolder}/${hemi}h.pial ${FreesurferFolder}/${hemi}h.sphere.reg ${ROIsFolder}/resample_fsaverage/fs_LR-deformed_to-fsaverage.${HEMI}.sphere.32k_fs_LR.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.midthickness.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.midthickness.${LowResMesh}k_fs_LR.surf.gii ${DownSampleFolder}/${Subject}.${HEMI}.sphere.reg.surf.gii > ${LOG}
done

#need to get confounds as well
#maybe an r script to grab proper columns of confounds file?
#OrigConfoundFile -> Confound
${ScriptDir}/BuildConfound.R ${OrigConfoundFile} ${OutConfoundFile} 8 1 0 0 0 0.5 5 > ${LOG}

${ScriptDir}/TaskfMRILevel1.sh ${Subject} ${ResultsFolder} ${ROIsFolder} ${DownSampleFolder} ${LevelOnefMRIName} ${LevelOnefsfName} ${LowResMesh} ${GrayordinatesResolution} ${OriginalSmoothingFWHM} ${Confound} ${FinalSmoothingFWHM} ${TemporalFilter} ${VolumeBasedProcessing} ${RegName} ${Parcellation} ${ParcellationFile} ${Session} > ${LOG}
