#!/bin/bash
#PBS -l select=1:ncpus=10
#PBS -q ntu192G
#PBS -P MST109178
#PBS -W group_list=MST109178
#PBS -N VEP_hg38_test
#PBS -j oe
#PBS -M s0890003@gmail.com
#PBS -m e

#BASIC INFO
#GIAB_NA12878_HG001_hg38
SAMPLE_ID="test01"
HG="hg38"

# INPUT & OUTPUT PATH
INPUT_VCF_PATH=/work2/lynn88065/script/github/nhri_cov19_Annotation/nchc_vep/inputs/GIAB_NA12878_HG001_hg38_alt_dragen_v3.4.12.hard-filtered.vcf.gz
OUTPUT_VCF_PATH=/work2/lynn88065/script/github/nhri_cov19_Annotation/nchc_vep/outputs

# VEP TOOL PATH
VEP_CACHE_DIR=/pkg/biology/DATABASES/vep-j116831/Cache_GRC_38
#VEP_PLUGIN_DIR=/pkg/biology/DATABASES/vep-j116831/Plugins
#VEP_PLUGIN_DATA_DIR=/pkg/biology/DATABASES/vep-j116831/Data_for_plugins
VEP_PATH=/pkg/biology/Ensembl-VEP/Ensembl-VEP_v99.2
VEP_FASTA=/project/GP1/u3710062/AI_SHARE/shared_scripts/ANNOTATION/VEP/VEP_ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
#ExACpLI_BAM=/project/GP1/u3710062/AI_SHARE/shared_scripts/ANNOTATION/VEP/VEP_ref/GCF_000001405.38_GRCh38.p12_knownrefseq_alns.bam
HTSLIB_PATH=/pkg/biology/HTSLIB/HTSLIB_v1.10.2/bin/
export PATH=$HTSLIB_PATH:$PATH

module load biology/Perl/default

# add new sample file
mkdir -p $OUTPUT_VCF_PATH/${SAMPLE_ID}_${HG}
cd $OUTPUT_VCF_PATH/${SAMPLE_ID}_${HG}

# USAGE OPTIONS
$VEP_PATH/vep --cache --offline \
        --cache_version 99 \
        --assembly GRCh38 \
        --port 3337 \
        --merged \
        --dir_cache $VEP_CACHE_DIR \
        --fasta $VEP_FASTA \
        -i $INPUT_VCF_PATH \
        --vcf \
        -o ${SAMPLE_ID}_${HG}_output.vcf \
        --sift b \
        --regulatory \
        --check_existing \
        --buffer_size 5000 \
        --fork 4 \
        --force_overwrite 

$VEP_PATH/vep --cache --offline \
        --cache_version 99 \
        --assembly GRCh38 \
        --port 3337 \
        --merged \
        --dir_cache $VEP_CACHE_DIR \
        --fasta $VEP_FASTA \
        -i $INPUT_VCF_PATH \
        --pick \
        --tab \
        -o ${SAMPLE_ID}_${HG}_output.txt \
        --sift b \
        --everything \
        --regulatory \
        --check_existing \
        --buffer_size 5000 \
        --fork 10 \
        --force_overwrite > vep.log 2>&1

