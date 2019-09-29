# Library of bpipe functions for processing minc files

`minc-bpipe-library` provides a set of chainable minc file processing functions to (pre)process data. At the moment is our star preprocessing pipeline. By default it will perform: N4correction, Cutneck, Head and Brain masks (using BEAST) and registration to MNI space using bestlinreg.

To run it on Niagara see below.

To control which stages are run, edit ``pipeline.bpipe`` and add stage names using "+" to the "run" stage.

The default in ``pipeline.bpipe`` is what has experimentally determined to be a best-practice run.

Stages are listed in the ``minc-library.bpipe``, correction stages such as denoising, n3 and n4, and normalize
should be run before any other stages. Typically after this ``linear_antsRegistration`` would be run, which will
allow other processing such as VBM, cutneck, deface and beast to be done in MNI space.

For convenience, "segments" have been defined for some processing jobs (beast, cutneck, VBM) which are multi-step.
These may conflict with each other if you try to combine them, so instead you must specifiy their individual stages.

Stage options have been chosen based on best pratices from publications where applicable but can be changed.

Once you have defined your stages, you can run your pipeline on the CIC cluster with:
```sh
> git clone https://github.com/CobraLab/minc-bpipe-library.git
#Edit minc-bpipe-library/pipeline.bpipe as you see fit
> module load bpipe #needed to run bpipe
> module load minc-toolkit minc-toolkit-extras ANTs/20190211 #needed for most stages
> cd /path/to/store/outputs
#Choose n to be the smaller of, (number of subjects, 240), minimum 4 regardless of subject number
> bpipe run -n<number> /path/to/pipeline.bpipe /path/to/inputs/*mnc
```

Output filenames from bpipe will be of the form ``<inputname>.stage1.stage2.stage3.ext`` where the last stage
name will be the last run. ``commandlog.txt`` will be generated by bpipe describing all the commands run for
the pipeline. This is a very good file to keep around as as a note of what happened to your data.

Some stages produce both ``mnc`` files and ``xfm`` files, see the ``$output`` variables for what is generated.

# Installation dependencies

- minc-toolkit-v2 > 1.9.15 https://bic-mni.github.io/
- bpipe pipelining tool http://bpipe.org
- Human atlases/priors from the MNI http://nist.mni.mcgill.ca/?page_id=714 unzipped into a ``${QUARANTINE_PATH}/resources`` one directory per zip file
- beast-library/1.1 https://bic-mni.github.io/#data-files-and-models and possibly augmented according to https://github.com/BIC-MNI/BEaST/blob/master/README.library
- iterativeN4_multispectral.sh from https://github.com/CobraLab/iterativeN4_multispectral

# Note on the space of output files
``minc-bpipe-library`` produces outputs in two spaces, the native space of the input image, and a LSQ12 registered
space of a target image, typically the MNI ICBM 09c template. Be aware of the difference between these spaces, most
pipelines (CIVET, MAGeT, etc) expect their input files to be in native space. Files with a ``register`` component
in their name indicate files which have been transformed into the template space, files without are in their native space.

The use of the ``clean_and_center`` stage does not change the space of the file through registration, but does uniformize
the direction cosines and the zero-point of the scan to the center of the image. Such modifications do impact orientation
and location but in a reversable way with no loss of information. If your dataset contains multiple modalities (T1, T2, fMRI)
you should not use ``clean_and_center`` as it will remove the intrinsic co-registration your scans have as a result of scanning
within a single session.

# Troubleshooting Failures
Depending upon the type of cluster and type of files you run through bpipe, there can be a few error conditions. On Niagara
running out of walltime can be a problem, as well as random filesystem problems. At the CIC, workstation crashes can
interrupt some jobs, which causes the pipeline to stop.

In general, this first step is always to retry running the job. Since bpipe is a pipeline tool it will not re-run completed
stages and will continue where it left off previously. If the problems you had were intermittent then they will be resolved.

One can check the logs (or just the errors) from a bpipe run from (inside the run directory) running the command ``bpipe log``
or ``bpipe errors`` respectively.

Secondly, if the pipeline is repeatedly failing somewhere in the middle, the next step is to inspect the intermediate outputs
for indications of wrong "solutions". If this is the case, then you should trace back to the origin stage of the issue and
examine if that stage can be tweaked/modified, for more help, contact CoBrALab.

Third, this pipeline heavily utilizes MINC tools and MNI templates, which all assume a RAS, neurological orientation for all
files. If this is not the case, then processing will never succeed as registration cannot overcome such large misorientations.
In order to resolve these issues, scans need to be properly converted into MINC, and may need flipping applied.

# Which outputs should I use?

If you are running default pipeline there are three files of interest for an input file `<basename>.(nii.gz,nii,mnc)`
- `<basename>.convert.n4correct.cutneckapplyautocrop.mnc` -- the final T1 in native space, with skull, extra data and background removed, with bias field corrected
- `<basename>.convert.n4correct.cutneckapplyautocrop.beastmask.mnc` -- the brain mask in native space
- `<basename>.convert.n4correct.cutneckapplyautocrop.beastmask.mnc` -- the extracted T1 in native space, with bias field corrected

# Niagara Operation

Typically, bpipe would talk directly to the cluster queing system but due to the design of Niagara, instead we submit "local"
bpipe runs for each subject each of while goes to a separate computer for processing.

Steps
```sh
> git clone https://github.com/CobraLab/minc-bpipe-library.git
> rm minc-bpipe-library/bpipe.config
> mkdir bpipe-outputs && cd bpipe-outputs
> module load intel/2018.2 openblas/0.2.20 gsl/2.4 minc-toolkit/1.9.16 minc-toolkit-extras/1.9.16 gnu-parallel qbatch java bpipe ANTs/20180814
> ../minc-bpipe-library/bpipe-batch.sh ../minc-bpipe-library/pipeline.bpipe /path/to/my/inputs/*.mnc > joblist #to generate a joblist
> qbatch -N myjobname --chunksize 1 --walltime=8:00:00 joblist #to submit jobs to Niagara queing system
```
# QC
Quality control images are automatically generated in the QC directory (under the output directory) for each input file. These QC images are of the
input files registered in MNI space, with a **red** brain mask generated by BeAST and a **blue** outline of the MNI brain.

For quality control, you should inspect:

1. The registration of the brain relative to the MNI outline
2. The brain mask should cover the brain properly with no over/under segmentation (your goals for the mask determine how careful you need to be)
3. The intensity profile across the brain should be uniform, indicating a good imhomogeneity correction
