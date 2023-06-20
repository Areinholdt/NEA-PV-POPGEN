#!/bin/bash
#SBATCH --job-name=saf # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e safpop_test_error
#SBATCH --cpus-per-task=5 # Number of CPU cores per task
#SBATCH --mem-per-cpu=8gb
#SBATCH --nodes=1
#SBATCH --time 5:00:00 # Time limit hrs:min:sec
#SBATCH --output=safs.log # Standard output/error

# Loading modules
module load angsd

# Specify the directory containing BAM files
bam_dir="/projects/mjolnir1/people/knb401/nea_pv/bam"

# Specify the list of BAM files and corresponding population names
bam_list=("a.bam" "d.bam" "e.bam" "g.bam" "k.bam")
population_names=("a" "d" "e" "g" "k")

# Generate SAF files and estimate 1D site frequency spectra for each population
for ((i=0; i<${#bam_list[@]}; i++))
do
    # Extract the BAM file and population name
    bam=${bam_list[i]}
    population=${population_names[i]}

    # Generate SAF file
    angsd -b "$bam_dir/$bam" \
           -anc "/projects/mjolnir1/people/knb401/nea_pv/GCF_004348235.1_GSC_HSeal_1.0_genomic.fasta" \
           -out "/projects/mjolnir1/people/knb401/nea_pv/analyses/2dsfs/$population" \
           -dosaf 1 -gl 2 -minQ 20 -minMapQ 30 -nThreads 10 \
           -sites "/projects/mjolnir1/people/knb401/nea_pv/angsd.file"
done
