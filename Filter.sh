#!/bin/bash
# Author:Tina Yang
# Date: Mar 5,2021
# Single sample variant calling by GATK VariantFiltration
# GATK v4.1.9.0
  
# Dataset
REF_PATH="/LVM_data/tina/0220_variant_calling/mm10"
DATA_PATH="/LVM_data/tina/0220_variant_calling"
 
# Hard-filtering germline short variants, choosing specific thresholds for one or more annotations
# Hard-filter SNPs and indels seperatedly due to different thresholds
 
#Hard-filter SNPs
gatk VariantFiltration \
      -R $REF_PATH/GRCm38.primary_assembly.genome.fa \
      -V $DATA_PATH/RawVariant.vcf.gz \
      --filter-name "QD2" \
      --filter-expression "QD < 2.0" \
      --filter-name "QUAL30" \
      --filter-expression "QUAL < 30.0" \
      --filter-name "FS60" \
      --filter-expression "FS > 60.0" \
      --filter-name "SOR3" \
      --filter-expression "SOR > 3.0" \
      --filter-name "MQ40" \
      --filter-expression "MQ < 40.0" \
      --filter-name "MQRankSum-12.5" \
      --filter-expression "MQRankSum < -12.5" \
      --filter-name "ReadPosRankSum-8" \
      --filter-expression "ReadPosRankSum < -8.0" \
      -O $DATA_PATH/FilteredVariant_SNP.vcf.gz
 
 
#Hard-filter indels
gatk VariantFiltration \
      -R $REF_PATH/GRCm38.primary_assembly.genome.fa \
      -V $DATA_PATH/RawVariant.vcf.gz \
      --filter-name "QD2" \
      --filter-expression "QD < 2.0" \
      --filter-name "QUAL30" \
      --filter-expression "QUAL < 30.0" \
      --filter-name "FS200" \
      --filter-expression "FS > 200.0" \
      --filter-name "ReadPosRankSum-20" \
      --filter-expression "ReadPosRankSum < -20.0" \
      -O $DATA_PATH/FilteredVariant_indel.vcf.gz
 
 
#Combine filtered SNP and INDEL vcfs
#While concat, need to -a (allow overlaps to avoid chr contiguous problem)
tabix $DATA_PATH/FilteredVariant_SNP.vcf.gz
tabix $DATA_PATH/FilteredVariant_indel.vcf.gz
bcftools concat -a  $DATA_PATH/FilteredVariant_SNP.vcf.gz $DATA_PATH/FilteredVariant_indel.vcf.gz -Oz -o FilteredVariant.vcf.gz
