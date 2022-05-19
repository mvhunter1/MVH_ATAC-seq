#!/bin/bash

# *******************************************************************************
# 
# (c) 2022, Miranda V. Hunter, White Lab, MSKCC
# hunterm@mskcc.org | mirandavhunter@gmail.com
# 
# Remove duplicates from bam file. 
# Important: requires a sorted bam file (samtools sort output)
#
# *******************************************************************************

# Experiment Parameters:
R_DIR=/data/white/miranda/HMGB2_OE/Miranda_analyses/ATACseq/
bam=sample_aligned_sorted.bam

java=/opt/common/CentOS_7/java/1.8.0_31/bin/java
picard=/opt/common/CentOS_7/picard/picard-2.16.0-jar/picard.jar

# *******************************************************************************

for i in $(cat $R_DIR/Sample_List.txt); do
        echo "Running $i"
        cd $R_DIR/$i

        bsub \
                -n8 \
                -R rusage[mem=24] \
                -o MVH_ATAC_4_MarkDups_%J.stdout \
                -eo MVH_ATAC_4_MarkDups_%J.stderr \
                -W 36:00 \
                "$java -jar $picard MarkDuplicates \
                        INPUT=$bam \
                        METRICS_FILE=marked_dup_metrics.txt \
                        OUTPUT=aligned_no_duplicates.bam \
                        REMOVE_DUPLICATES=true"
done