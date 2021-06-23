#!/bin/bash

chr="21"
CHR_WIND=/hpc/dhl_ec/aalasiri/scripts/LoFTK/bin/chromosome_windows.txt

start=$( awk ' $1=="'$chr'" { print $2 } ' ${CHR_WIND} )
stop=$( awk ' $1=="'$chr'" { print $3 } ' ${CHR_WIND} )
while [ $start -le $stop ]
do
    lower=$start
    upper=$((start + 5))
    echo $i $chr $lower $upper
    
    echo "scan allele probs file"
    zcat impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs.gz | cut -d' ' -f1-5 > impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs_temp1
    zcat impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs.gz | cut -d' ' -f6- | tac > impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs_temp2 
     paste -d" " impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs_temp1 impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs_temp2 > impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs
     gzip -f impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs
     
     rm impute2_chr"$chr":"$lower"-"$upper"Mb_allele_probs_temp*


     echo "scan hap file"
     zcat impute2_chr"$chr":"$lower"-"$upper"Mb_haps.gz | cut -d' ' -f1-5 > impute2_chr"$chr":"$lower"-"$upper"Mb_haps_temp1
     zcat impute2_chr"$chr":"$lower"-"$upper"Mb_haps.gz  | cut -d' ' -f6- | tac > impute2_chr"$chr":"$lower"-"$upper"Mb_haps_temp2
      paste -d" " impute2_chr"$chr":"$lower"-"$upper"Mb_haps_temp1 impute2_chr"$chr":"$lower"-"$upper"Mb_haps_temp2 > impute2_chr"$chr":"$lower"-"$upper"Mb_haps 
      gzip -f impute2_chr"$chr":"$lower"-"$upper"Mb_haps
      rm impute2_chr"$chr":"$lower"-"$upper"Mb_haps_temp*
      
      echo "scan info file"
      tail -n +2 impute2_chr"$chr":"$lower"-"$upper"Mb_info | cut -d' ' -f1-5 > impute2_chr"$chr":"$lower"-"$upper"Mb_info_temp1
      tail -n +2 impute2_chr"$chr":"$lower"-"$upper"Mb_info | cut -d' ' -f6- | tac > impute2_chr"$chr":"$lower"-"$upper"Mb_info_temp2
      paste -d" " impute2_chr"$chr":"$lower"-"$upper"Mb_info_temp1 impute2_chr"$chr":"$lower"-"$upper"Mb_info_temp2 > impute2_chr"$chr":"$lower"-"$upper"Mb_info 
      sed -i '1i snp_id rs_id position a0 a1 exp_freq_a1 info certainty type info_type0 concord_type0 r2_type0' impute2_chr"$chr":"$lower"-"$upper"Mb_info
      rm impute2_chr"$chr":"$lower"-"$upper"Mb_info_temp*

      echo "scan sample file"
      tail -n +3 impute2_chr"$chr":"$lower"-"$upper"Mb_samples > impute2_chr"$chr":"$lower"-"$upper"Mb_samples.temp1
      paste -d" " impute2_chr"$chr":"$lower"-"$upper"Mb_samples.temp1 1197.sample.txt | awk '{print $1,$8,$3,$4,$5,$6,$7}' > impute2_chr"$chr":"$lower"-"$upper"Mb_samples 
      sed -i '1i 0 0 0 _2 _2 _2 B' impute2_chr"$chr":"$lower"-"$upper"Mb_samples 
      sed -i '1i I_21 I_22 missing father mother sex plinkpheno' impute2_chr"$chr":"$lower"-"$upper"Mb_samples
      rm impute2_chr"$chr":"$lower"-"$upper"Mb_samples.temp1 


      (( start += 5 ))

done 
