#!/bin/bash

# BASIC INFO
# GIAB_NA12878_HG001
SAMPLE_ID="test01"
HG="hg38"

# INPUT & OUTPUT PATH
INPUT_VCF_PATH=/root/inputs/GIAB_NA12878_HG001_hg38_alt_dragen_v3.4.12.hard-filtered.vcf.gzz
OUTPUT_VCF_PATH=/root/outputs

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
        --fork 4 

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
        --force_overwrite 

