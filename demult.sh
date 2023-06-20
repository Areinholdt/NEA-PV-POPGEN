#!/bin/bash
#SBATCH --job-name=demultiplex # Job name
#SBATCH -e test_error

#SBATCH --cpus-per-task=1 # Number of CPU cores per task
#SBATCH --mem-per-cpu=1gb
#SBATCH --nodes=1
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=test.log # Standard output/error

/maps/projects/mjolnir1/people/knb401/sofware/stacks-2.62/process_radtags -f /maps/projects/mjolnir1/people/knb401/nea_pv/HLF3WBGXY_1_fastq.gz -b /maps/projects/mjolnir1/people/knb401/nea_pv/HLF3WBGXY_1_fastq.barcode -o /maps/projects/mjolnir1/people/knb401/nea_pv/demulti_out -e PstI -q -r --inline_null
