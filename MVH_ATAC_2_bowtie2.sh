#!/bin/bash

# *******************************************************************************
# 
# (c) 2022, Miranda V. Hunter, White Lab, MSKCC
# hunterm@mskcc.org | mirandavhunter@gmail.com
# 
# Alignment to human genome with bowtie2, then pipe to samtools view to convert from sam to bam file.
# 
# *******************************************************************************

# Experiment Parameters:
R_DIR=/data/white/miranda/HMGB2_OE/Miranda_analyses/ATACseq/
R1="*_R1_001_val_1.fq.gz"
R2="*_R2_001_val_2.fq.gz"

bowtie=/admin/opt/common/CentOS_7/bowtie2/bowtie2-2.3.5.1-linux-x86_64/bowtie2
samtools=/opt/common/CentOS_7/samtools/samtools-1.13/bin/samtools
v2=sample_aligned.bam

numthreads=8

# prefix of bt2 files must be in path to folder (also including folder name)
genome=/data/white/miranda/Miranda_genomes/GRCh38_noalt_as/GRCh38_noalt_as

# *******************************************************************************

for i in $(cat $R_DIR/Sample_List.txt); do
        echo "Running $i"
        cd $R_DIR/$i

        bsub \
              	-n8 \
                -R rusage[mem=8] \
                -o MVH_ATAC_2_bowtie2_%J.stdout \
                -eo MVH_ATAC_2_bowtie2_%J.stderr \
                -R "span[ptile=8]" \
                -W 24:00 \
                "$bowtie --local -p $numthreads -x $genome -1 $R1 -2 $R2 | $samtools view -h -@ $numthreads -bS - > $v2"
done
