#!/bin/bash

#BASIC INFO
HG="hg38"
sample_list="/root/doc/run_list_02.txt"

while read -r ID sample; do
SAMPLE_ID="$ID"
# INPUT & OUTPUT PATH
INPUT_VCF_PATH="$sample"
OUTPUT_VCF_PATH=/data/output/

# VEP TOOL PATH
VEP_CACHE_DIR=/data/vep_cache
VEP_PATH=/root/ensembl-vep/
VEP_FASTA=/data/vep_cache/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# add new sample file
mkdir -p $OUTPUT_VCF_PATH/${SAMPLE_ID}_${HG}
cd $OUTPUT_VCF_PATH/${SAMPLE_ID}_${HG}

# USAGE OPTIONS
$VEP_PATH/vep --cache --offline \
        --cache_version 102 \
        --merged \
        --assembly GRCh38 \
        --dir_cache $VEP_CACHE_DIR \
    	--port 3337 \
        -i $INPUT_VCF_PATH \
        --vcf \
        -o ${SAMPLE_ID}_${HG}_output.vcf \
        --check_existing \
        --fasta $VEP_FASTA \
        --fork 4 \
        --buffer_size 50000

$VEP_PATH/vep --cache --offline \
        --cache_version 102 \
        --merged \
        --assembly GRCh38 \
        --port 3337 \
        --dir_cache $VEP_CACHE_DIR \
        -i $INPUT_VCF_PATH \
        -o ${SAMPLE_ID}_${HG}_output.txt \
        --tab \
        --pick \
        --everything \
        --check_existing \
        --fasta $VEP_FASTA \
        --fork 10 \
        --force_overwrite \
        --buffer_size 50000

    done<$sample_list
