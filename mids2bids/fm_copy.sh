#!/bin/bash

cd /net/data4/SchizGaze2_16/Subjects/
for i in [1-2]*
do
if [[ -e ${i}/func/fieldmaps/FM_gaze/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_gaze/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_gaze.nii
fslcpgeom ${i}/func/fieldmaps/FM_gaze/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_gaze.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_jovi/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_jovi.nii
fslcpgeom ${i}/func/fieldmaps/FM_jovi/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_jovi.nii
fi
if [[ -e ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii ]]
then
cp ${i}/func/fieldmaps/FM_resting/dicom/myfieldmap_resized.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_rest.nii
fslcpgeom ${i}/func/fieldmaps/FM_resting/dicom/FM0000.nii /net/pepper/ivy_data/workflow/raw/sub-${i}/fmap/sub-${i}_fieldmap_rest.nii
fi
echo ${i}
done
