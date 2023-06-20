#!/bin/bash
#SBATCH --job-name=mapping # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e mapping_test_error
#SBATCH --cpus-per-task=4 # Number of CPU cores per task
#SBATCH --mem-per-cpu=10gb
#SBATCH --nodes=1
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=test.log # Standard output/error

#loading moduels
module load bwa
module load samtools

#set outputdir

outdir=/projects/mjolnir1/people/knb401/nea_pv/mapping_out


#ref genome
ref=/projects/mjolnir1/people/knb401/nea_pv/GCF_004348235.1_GSC_HSeal_1.0_genomic.fna


#index
bwa index ${ref}


#todo
for file in /projects/mjolnir1/people/knb401/nea_pv/demulti_out/*.fq.gz
do


	#output file
	output=$outdir/$(basename ${file%.*})_sorted.bam

	#mapping
	bwa mem -t 4 ${ref} ${file} | samtools view -bS - | samtools sort -o $output -

done
