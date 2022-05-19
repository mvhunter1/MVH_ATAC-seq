#!/bin/bash

# *******************************************************************************
# 
# (c) 2022, Miranda V. Hunter, White Lab, MSKCC
# hunterm@mskcc.org | mirandavhunter@gmail.com
# 
# Trim ATAC-seq FASTQ files using TrimGalore and cutadapt.
# 
# *******************************************************************************
#
# Before running this script:
# Install cutadapt using conda into virtual environment
# Activate virtual environment *** use "source" not "conda" to activate the environment, otherwise it won't work
# Check that cutadapt install worked by cutadapt --version
#
# *******************************************************************************

# Experiment Parameters:
R_DIR=/data/white/miranda/HMGB2_OE/Miranda_analyses/ATACseq
R1="*_R1_001.fastq.gz"
R2="*_R2_001.fastq.gz"

TrimGalore=/data/white/miranda/Miranda_software/TrimGalore-0.6.7/trim_galore

# *******************************************************************************


# submit bsub for each sample

for i in $(cat $R_DIR/Sample_List.txt); do
        echo "Running $i"
        cd $R_DIR/$i

        bsub \
                        -n1 \
                        -R rusage[mem=24] \
                        -o MVH_ATAC_1_TrimGalore_%J.stdout \
                        -eo MVH_ATAC_1_TrimGalore_%J.stderr \
                        -W 36:00 \
                        "$TrimGalore \
                                --paired \
                                --cores 4 \
                                -quality 15 \
                                --fastqc \
                                --illumina \
                                -trim1 \
                                $R1 $R2"
done
