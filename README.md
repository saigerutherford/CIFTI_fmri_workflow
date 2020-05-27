# CIFTI_fmri_workflow
This repository holds the scripts I have used to get data from the University of Michigan fMRI lab into BIDS format, preprocessed through fMRIPrep (to get CIFTI-space output data) using a singularity container on UMich's HPC, Great Lakes (which uses slurm https://arc-ts.umich.edu/greatlakes/), then create CIFTI connectivity matrices for rest and task, and finally run task fMRI data through the HCP first level task scripts to get first level and group task activation maps. 

## Step 1: MIDS2BIDS  
`MIDS2BIDS.sh`, `fmap_copy.sh`, `NibabelChangeHDR.ipynb`
Notes/Problems: Fieldmap was not BIDS compatible. Per Krisanne’s instructions, I had to copy the header from another field map image (see `fmap_copy.sh`). TR & voxel xyz units were not correctly set and I had to use nibabel to edit the header (see `NibabelChangeHDR.ipynb`). 

## Step 2: BIDS validator
fMRIPrep will fail if your data is not in proper BIDS format. So make sure to validate your data here: https://bids-standard.github.io/bids-validator/

## Step 3: fMRIPrep
a.) Transfer BIDS folder containing all subjects to Great Lakes. Note that the greatlakes login is different than what you type to normally ssh into GL, it includes `greatlakes-xfer` instead of just `greatlakes` b/c this allows you to bypass the Duo login since you just need to put data on GL and aren't actually trying to login. 
`rsync -av BIDS_dir/ uniqname@greatlakes-xfer.arc-ts.umich.edu:/scratch/ivytso_root/ivytso1/shared_data/SZG2/raw/ 2> transfer.err > transfer.log` The transfer.err text file will list any files that rsync failed to transfer, and the transfer.log file will list all of the files that were successfully transferred. 

b.) Scripts that need to be filled out are `fmriprep.master`, `fmriprep_submit.sh`, `run_fmriprep_ciftioutputs.sh`, & `cleanup.sh`

  i. `fmriprep.master` --> this script contains a lot of the necessary slurm commands (all on the lines that start with #).     It also copies the data to /tmp/ because fmriprep doesn’t like to be run on network drives and wants to be run locally     (from /tmp/). This script also copies the Freesurfer folder into the fmriprep folder (if you have pre-run Freesurfer,      which I recommend doing...running freesurfer from within fmriprep seems to hang and take forever. I found that my jobs     would often hit the wallclock limit). 
  
  ii. `run_fmriprep_ciftioutputs.sh` --> this script points to the singularity container on Great Lakes for fmriprep version 20.0.2 It also contains all of the fmriprep options like output spaces, ignore slicetime, what kind of fieldmap       correction to do, whether or not to run ICA-AROMA, etc. For all of the fmriprep options that can be specified refer to: https://fmriprep.readthedocs.io/en/stable/usage.html
  
  iii. `fmriprep_submit.sh` --> this is the script that will actually submit the fmriprep jobs to run. It will submit one job per subject so that you can run lots of subjects in parallel (my record is ~11,000 at once)
  
  iv. `cleanup.sh` --> this script copies the data from `/tmp/` back to `/scratch/` after fMRIPrep has finished running. 
You will also need a subject list text file called `good_subs.txt` (stored in a sub-directory `data/good_subs.txt`).
Before running the script, you need to make sure the directories exist for `Logs/` & `Results/` (otherwise the jobs will not be copied back correctly after they run. 

To run the script from a Great Lakes terminal (in whatever directory the `fmriprep_submit.sh` script lives) type: `./fmriprep_submit.sh 1 2` The 1 & 2 refer to the line numbers of `good_subs.txt`. This would run fmriprep for the first and second subjects in `good_subs.txt`. If you wanted to run the first 10 subjects in `good_subs.txt` you would type: `./fmriprep_submit.sh 1 10`. I suggest testing it out with a small number of subjects to make sure your script is working correctly before you run it on lots of subjects and potentially waste a bunch of money. You will also need to have a freesurfer license (which you can get here: https://surfer.nmr.mgh.harvard.edu/registration.html) in the `data/` folder and make sure that the `run_fmriprep_ciftioutputs.sh` script points to the correct location for your freesurfer license. 

## Step 4: Quality check
fMRIPrep outputs a HTML file that can be used to QC all steps of preprocessing. This should be done for each run, for each subject. 

## Step 5: Connectivity 
To create resting state and task connectivity matrices I used the scripts in the connectivity folder. These are MATLAB scripts that will regress out all of your confounds in a single step, and can also remove volumes from the time-series if this wasn't done already. 

## Step 6: Task
You will need to clone the HCP pipelines GitHub repo (https://github.com/Washington-University/HCPpipelines) to get some of their scripts for the task analysis. You will also need to have connectome workbench & FSL installed.
a.) Prep (fsf template)

b.) Run-level modeling

c.) Averaging run-level models

d.) Parcellation, gradients

e.) Group level model

## Step 7: Multiple comparison correction
Code coming soon.

## Step 8: Visualization 
I use wb_command to visualize the group level (and first level task maps). It is easy to download and setup. Here is the link: https://www.humanconnectome.org/software/get-connectome-workbench

