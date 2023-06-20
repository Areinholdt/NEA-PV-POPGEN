#!/bin/bash
#SBATCH --job-name=pcangsd # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e pca_test_error
#SBATCH --cpus-per-task=2 # Number of CPU cores per task
#SBATCH --mem-per-cpu=5gb
#SBATCH --nodes=1
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=test.log # Standard output/error


# Loading modules
module load pcangsd

# Set input/output directories
inputdir=/projects/mjolnir1/people/knb401/nea_pv/analyses/modi
outputdir=/projects/mjolnir1/people/knb401/nea_pv/analyses/modi

# Set path to the beagle file
beagle=$inputdir/modifile.beagle.gz

# Run pcaangsd
pcangsd -b $beagle -minMaf 0.05 -o $outputdir/pca -threads 4



