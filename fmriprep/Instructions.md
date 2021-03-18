# Instructions for running fMRIPrep on a SLURM cluster (at the University of Michgan using Great Lakes server)

1. Data must be in BIDS format. Use the [BIDS validator](https://bids-standard.github.io/bids-validator/) to check that your data passes validation. 
2. Edit the fmriprep.master script 
3. Edit the subject list in `data/goodsubs.txt` to match your data (don't include sub- prefix)
4. Edit submit_fmriprep.sh to match your paths
5. Edit the scripts in the `code/` folder
