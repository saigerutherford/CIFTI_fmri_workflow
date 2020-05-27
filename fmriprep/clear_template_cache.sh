 #!/bin/bash
rm -rf ~/.cache/templateflow
for tmpl in fsaverage  MNI152Lin MNI152NLin6Asym MNIInfant NKI PNC fsLR MNI152NLin2009cAsym MNI152NLin6Sym MNIPediatricAsym OASIS30ANTs WHS
do
echo $tmpl
singularity exec /sw/examples/singularity/fmriprep-20.0.4.simg \
	    python -c "import templateflow.api as tf; tf.get('$tmpl')"
done