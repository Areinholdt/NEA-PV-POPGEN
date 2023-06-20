#!/bin/bash
#SBATCH --job-name=samtooqc2 # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e samtool_qc_test_error
#SBATCH --cpus-per-task=1 # Number of CPU cores per task
#SBATCH --mem-per-cpu=2gb
#SBATCH --nodes=1
#SBATCH --time=02:00:00 # Time limit hrs:min:sec
#SBATCH --output=test.log # Standard output/error

#loading modules
module load samtools

# Input/output directories
input_dir=/projects/mjolnir1/people/knb401/nea_pv/mapping_out
output_dir=/projects/mjolnir1/people/knb401/nea_pv/mapping_out/mapping_qc

#to do
for bamfile in $input_dir/*.bam
do
  # Get the sample name from the BAM file name
  sample=$(basename "$bamfile" .bam)

  # Calculate mean depth using samtools depth and awk - takes the third collum, devide by the number of line to get average

  mean_depth=$(samtools depth "$bamfile" | awk '{sum+=$3} END {print sum/NR}')

  # Write to output file
  echo "$sample $mean_depth" >> "$output_dir/mean_depth.txt"
done

