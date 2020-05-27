#!/bin/bash

cd /net/data4/SchizGaze2_16/Subjects/

for i in `cat BIDSsublist`
do
cd /net/pepper/ivy_data/workflow/raw/
mkdir sub-${i}
cd sub-${i}
mkdir anat fmap func
cd /net/data4/SchizGaze2_16/Subjects/
if [[ -e ${i}/anatomy/t1spgr_208sl/t1spgr_208sl.nii ]]
then
cp ${i}/anatomy/t1spgr_208sl/t1spgr_208sl.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/anat/sub-${i}_T1w.nii
fi
if [[ -e ${i}/anatomy/t2cube_208sl/t2cube_208sl.nii ]]
then
cp ${i}/anatomy/t2cube_208sl/t2cube_208sl.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/anat/sub-${i}_T2w.nii
fi
if [[ -e ${i}/func/gaze/run_01/run_01.nii ]]
then
cp ${i}/func/gaze/run_01/run_01.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-01_bold.nii
fi
if [[ -e ${i}/func/gaze/run_02/run_02.nii ]]
then
cp ${i}/func/gaze/run_02/run_02.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-02_bold.nii
fi
if [[ -e ${i}/func/gaze/run_03/run_03.nii ]]
then
cp ${i}/func/gaze/run_03/run_03.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-03_bold.nii
fi
if [[ -e ${i}/func/gaze/run_04/run_04.nii ]]
then
cp ${i}/func/gaze/run_04/run_04.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-04_bold.nii
fi
if [[ -e ${i}/func/gaze/run_05/run_05.nii ]]
then
cp ${i}/func/gaze/run_05/run_05.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-05_bold.nii
fi
if [[ -e ${i}/func/gaze/run_06/run_06.nii ]]
then
cp ${i}/func/gaze/run_06/run_06.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-gaze_run-06_bold.nii
fi
if [[ -e ${i}/func/jovi/run_01/run_01.nii ]]
then
cp ${i}/func/jovi/run_01/run_01.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-jovi_run-01_bold.nii
fi
if [[ -e ${i}/func/jovi/run_02/run_02.nii ]]
then
cp ${i}/func/jovi/run_02/run_02.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-jovi_run-02_bold.nii
fi
if [[ -e ${i}/func/jovi/run_03/run_03.nii ]]
then
cp ${i}/func/jovi/run_03/run_03.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-jovi_run-03_bold.nii
fi
if [[ -e ${i}/func/jovi/run_04/run_04.nii ]]
then
cp ${i}/func/jovi/run_04/run_04.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-jovi_run-04_bold.nii
fi
if [[ -e ${i}/func/resting/run_01/run_01.nii ]]
then
cp ${i}/func/resting/run_01/run_01.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/func/sub-${i}_task-rest_run-01_bold.nii
fi

if [[ -e ${i}/func/fieldmaps/FM_gaze/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_gaze/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-gaze_fieldmap.nii
fslcpgeom ${i}/func/fieldmaps/FM_gaze/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-gaze_fieldmap.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-jovi_fieldmap.nii
fslcpgeom ${i}/func/fieldmaps/FM_jovi/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-jovi_fieldmap.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-rest_fieldmap.nii
fslcpgeom ${i}/func/fieldmaps/FM_resting/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-rest_fieldmap.nii
fi

if [[ -e ${i}/func/fieldmaps/FM_gaze/dicom/my_fieldmap_mag.nii ]]
then
cp ${i}/func/fieldmaps/FM_gaze/dicom/my_fieldmap_mag.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-gaze_magnitude.nii
fslcpgeom ${i}/func/fieldmaps/FM_gaze/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-gaze_magnitude.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-jovi_magnitude.nii
fslcpgeom ${i}/func/fieldmaps/FM_jovi/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-jovi_magnitude.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-rest_magnitude.nii
fslcpgeom ${i}/func/fieldmaps/FM_resting/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_acq-rest_magnitude.nii
fi
echo ${i}
done
