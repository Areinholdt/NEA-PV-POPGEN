#!/bin/bash
#SBATCH --job-name=ibs # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e ibs_test_error
#SBATCH --cpus-per-task=5 # Number of CPU cores per task
#SBATCH --mem-per-cpu=8gb
#SBATCH --nodes=1
#SBATCH --time 6:00:00 # Time limit hrs:min:sec
#SBATCH --output=ibs.log # Standard output/error

# Loading modules
module load angsd

angsd -bam /projects/mjolnir1/people/knb401/nea_pv/bam_modi.filelist -minMapQ 30 -minQ 20 -GL 2 -doMajorMinor 1 -doMaf 1 -SNP_pval 2e-6 -doIBS 1 -doCounts 1 -makeMatrix 1 -minMaf 0.05 -out /projects/mjolnir1/people/knb401/nea_pv/analyses/nj_out -P 10
