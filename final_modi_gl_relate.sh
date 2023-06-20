#!/bin/bash
#SBATCH --job-name modi_gl_relate
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk	
#SBATCH -e modi_final_gl_test_error
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=5gb
#SBATCH --time=2:00:00
#SBATCH --output=test.log # Standard output/error


#loading modules

module load angsd

echo "setting paths"

ref=/projects/mjolnir1/people/knb401/nea_pv/GCF_004348235.1_GSC_HSeal_1.0_genomic.fasta
bam=/projects/mjolnir1/people/knb401/nea_pv/bam_modi.filelist
angsd_out=/projects/mjolnir1/people/knb401/nea_pv/genotypes_out/modi/modi
sitesf=/projects/mjolnir1/people/knb401/nea_pv/angsd.file

echo "running angsd"

angsd -ref $ref -out $angsd_out -b $bam -sites $sitesf -nThreads 8 \
-minQ 20 -minMapQ 30 \
-doCounts 1 \
-doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -minMaf 0.05 \
-GL 2 -doGlf 3

echo "angsd done"

echo "creating freq file"

less -S *.mafs.gz | cut -f6 | sed 1d > modi_freq.txt

echo "setting paths"

relate_out=/projects/mjolnir1/people/knb401/nea_pv/relate_out/modi/relate.out
genotypes=/projects/mjolnir1/people/knb401/nea_pv/genotypes_out/modi/*
freq=/projects/mjolnir1/people/knb401/nea_pv/genotypes_out/modi/modi_freq.txt
info=/projects/mjolnir1/people/knb401/nea_pv/modi_popinfo.file

echo "running NGSrelate"

/projects/mjolnir1/apps/ngsRelate/ngsRelate -g $genotypes -f $freq -z $info -O $relate_out \
-n 69 -p 8

echo "NGSrelate done"

echo "creating inbreeding data file"

for i in *relate.out
    do
    less -S $i | awk '{print $3"\t"$16}' | sed 's/ida/name/' | sed 's/Fa/IBC/' > ${i%.*}.IBC
    less -S $i | awk '{print $4"\t"$17}' | sed 's/idb/name/' | sed 's/Fb/IBC/' >> ${i%.*}.IBC
done

echo "creating relate data file"

less -S *relate.out | awk '{print $3"\t"$4"\t"$15}' > a_relate.rab

echo "creating KINGS data file" 

less -S *relate.out | awk '{print $3"\t"$4"\t"$33}' > a_relate.KING

module purge

echo "complete"
