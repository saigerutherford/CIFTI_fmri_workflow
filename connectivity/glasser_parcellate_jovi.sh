#!/bin/bash

while IFS=, read -r sub task run
do
wb_command -cifti-parcellate /net/pepper/ivy_data/workflow/results/${sub}/${sub}/func/${sub}_task-jovi_run-0${run}_space-fsLR_den-91k_bold.dtseries.nii /net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Glasser_et_al_2016_HCP_MMP1.0_RVVG/HCP_PhaseTwo/Q1-Q6_RelatedValidation210/MNINonLinear/fsaverage_LR32k/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR.dlabel.nii COLUMN /net/pepper/ivy_data/workflow/results/${sub}/${sub}/func/${sub}_task-jovi_run-0${run}_space-fsLR_glasser_den-91k_bold.ptseries.nii
echo "${sub} ${run}"
done< /net/data4/SchizGaze2_16/Scripts/slab/CIFTI/jovi_MDF.csv
