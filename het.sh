#!/bin/bash
#SBATCH --job-name=het # Job name
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e het_test_error
#SBATCH --cpus-per-task=5 # Number of CPU cores per task
#SBATCH --mem-per-cpu=8gb
#SBATCH --nodes=1
#SBATCH --time 3:00:00 # Time limit hrs:min:sec
#SBATCH --output=het.log # Standard output/error

# Loading modules
module load angsd
module load gcc
module load R

#loop over bam files and do saf

for bam in /projects/mjolnir1/people/knb401/nea_pv/bam.filelist; do
    n="${bam%%.*}"
    name="${n##*/}"
    angsd -i "$bam" -anc /projects/mjolnir1/people/knb401/nea_pv/GCF_004348235.1_GSC_HSeal_1.0_genomic.fasta -out /projects/mjolnir1/people/knb401/nea_pv/analyses/het_out/"$name" -dosaf 1 -gl 2 -minQ 20 -minMapQ 30 -nThreads 10 -sites /projects/mjolnir1/people/knb401/nea_pv/angsd.file
    realSFS "$name".saf.idx >"$name".ml
    Rscript -e "a<-scan('$name.ml');a[2]/sum(a)" >"$name".het
done
awk '{print $0","FILENAME}' *.het > AllHet.list


