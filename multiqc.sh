#!/bin/bash
#SBATCH --job-name=fastqc # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e test_error
#SBATCH --cpus-per-task=1 # Number of CPU cores per task
#SBATCH --mem-per-cpu=1gb
#SBATCH --nodes=1
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=test.log # Standard output/error

for file in /projects/mjolnir1/people/knb401/nea_pv/demulti_out/*.fq.gz
do
    /projects/mjolnir1/people/knb401/sofware/FastQC/fastqc $file -o /projects/mjolnir1/people/knb401/nea_pv/fastq_pv_out
done
