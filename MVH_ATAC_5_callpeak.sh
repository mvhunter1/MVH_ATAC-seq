#!/bin/bash

# *******************************************************************************
# 
# (c) 2022, Miranda V. Hunter, White Lab, MSKCC
# hunterm@mskcc.org | mirandavhunter@gmail.com
# 
# Call peaks with MACS2 using control (published) A375 data as comparison.
#
# *******************************************************************************
#
# To be completed after removing duplicates
#
# To use MACS2: need to install it into a conda environment 
# Once installing (which I have already installed), activate the environment by:
# module add python/3.7.1
# module add conda/conda3
# source activate macs2
#
# check if it worked by typing macs2 --help
#
# As control input for MACS2, using control A375 data that Richard K used in Richard H's paper
# Control data: GSM3212794
#
# *******************************************************************************

# Experiment Parameters:
R_DIR=/data/white/miranda/HMGB2_OE/Miranda_analyses/ATACseq/
bam=aligned_no_duplicates.bam

controldata=/data/white/miranda/Miranda_genomes/A375_ATAC_control/GSM3212794/A375_input_SRR7416678.hg38.sorted.RmDup.bam

# *******************************************************************************

for i in $(cat $R_DIR/Sample_List.txt); do
        echo "Running $i"
        cd $R_DIR/$i

        bsub \
                -n8 \
                -R rusage[mem=24] \
                -o MVH_ATAC_5_callpeak_%J.stdout \
                -eo MVH_ATAC_5_callpeak_%J.stderr \
                -W 36:00 \
                "macs2  callpeak \
                        -t $bam \
                        -c $controldata \
                        -f BAM \
                        -g hs \
                        --nomodel \
                        -n MACS_results \
                        --outdir callpeak_results \
                        -p 0.001"
done
