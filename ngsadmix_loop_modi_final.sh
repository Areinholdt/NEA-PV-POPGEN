#!/bin/bash
#SBATCH --job-name=modi_ngsadmix_loop
#SBATCH --mail-type=all
#SBATCH --mail-user=annika.reinholdt@sund.ku.dk
#SBATCH -e ngsadmixloop_test_error
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=8gb
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --output=ngsloop_admix.log


#load

module load gcc
module load R

# Loop and coergence for ngsadmix

NGSA=/projects/mjolnir1/people/knb401/sofware/NGSadmix
input_dir=/projects/mjolnir1/people/knb401/nea_pv/analyses/modi
output_dir=/projects/mjolnir1/people/knb401/nea_pv/analyses/ngsadmix_out/modi

for k in {3..7}
do
    file="$input_dir/modifile.beagle.gz"
    nfile="ngsadmix"
    num=100
    P=10
    K=$k
    out="$output_dir/$K"

    mkdir -p "$out" # Create output dir if it doesn't exist

    for f in $(seq $num)
    do
        echo -n -e "$f\t"
        echo "$file"
        echo "$K"
        $NGSA -likes "$file" -seed "$f" -K "$K" -P "$P" -printInfo 1 -o "$out/$nfile.$K.$f"
        grep "like=" "$out/$nfile.$K.$f.log" | cut -f2 -d " " | cut -f2 -d "=" >> "$out/$nfile.$K.likes"
        CONV=$(R -e "r<-read.table('$out/$nfile.$K.likes');r<-r[order(-r[,1]),];cat(sum(r[1]-r<3),'\n')")

        if [ "$CONV" -gt 2 ]
        then
            cp "$out/$nfile.$K.$f.qopt" "$out/$nfile.$K.$f.qopt_conv"
            cp "$out/$nfile.$K.$f.fopt.gz" "$out/$nfile.$K.$f.fopt_conv.gz"
            cp "$out/$nfile.$K.$f.log" "$out/$nfile.$K.$f.log_conv"
            break
        fi
    done
done

