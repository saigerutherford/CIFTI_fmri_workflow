#!/bin/bash

cd /net/pepper/ivy_data/workflow/raw/
for i in sub-*
do
#for task in gaze rest jovi
#do
#cp acq-${task}_fieldmap.json ${i}/fmap/
#done
cd ${i}/fmap/
find ./ -name "*.json" -type f -exec sed -i "s/task-gaze/func\/${i}_task-gaze/g" {} \;
find ./ -name "*.json" -type f -exec sed -i "s/task-jovi/func\/${i}_task-jovi/g" {} \;
find ./ -name "*.json" -type f -exec sed -i "s/task-rest/func\/${i}_task-rest/g" {} \; 
cd ../../
done
