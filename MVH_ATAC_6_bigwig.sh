#!/bin/bash

# *******************************************************************************
#
# (c) 2022, Miranda V. Hunter, White Lab, MSKCC
# hunterm@mskcc.org | mirandavhunter@gmail.com
#
# Create bigwig file using deeptools.
# Must create index for bam file first using samtools index.
# Note: input to bamCoverage is the .bam file, NOT .bai file. bamCoverage will
# automatically look for a corresponding .bai file in the folder. 
#
# *******************************************************************************
#
# To use deeptools: need to install it into a conda environment
# Easiest method is:
# module add python/3.7.1
# module add conda/conda3
# conda create --name deeptools
# source activate deeptools (<- only need this line if already installed deeptools)
# conda install -c bioconda deeptools
#
# check if it worked by typing deeptools --help
#
# *******************************************************************************

# Experiment Parameters:
R_DIR=/data/white/miranda/HMGB2_OE/Miranda_analyses/ATACseq/
bam=aligned_no_duplicates.bam

numthreads=8

samtools=/opt/common/CentOS_7/samtools/samtools-1.13/bin/samtools

# *******************************************************************************

for i in $(cat $R_DIR/Sample_List.txt); do
        echo "Running $i"
        cd $R_DIR/$i

        bsub \
                -n8 \
                -R rusage[mem=24] \
                -o MVH_ATAC_6_bigwig_%J.stdout \
                -eo MVH_ATAC_6_bigwig_%J.stderr \
                -W 12:00 \
                "$samtools index -b -@ $numthreads $bam 
                bamCoverage -b $bam -of bigwig -o coverage.bw"
done

