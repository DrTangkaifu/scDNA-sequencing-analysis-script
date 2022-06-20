#! /bin/bash
#将处理完的序列比对到小鼠基因组
filedir=/public/home/tangkaifu/test_hu/process/4-trimTA
hg38ref=/public/home/tangkaifu/reference/hg38_Human
mm10ref=/public/home/tangkaifu/reference/mm10_Mouse

for file in $filedir/*.out.fq
do
cd $filedir
hisat2 -x $mm10ref/mm10_1 -U $file  -S $(basename $file .out.fq).sam
samtools view -bS $(basename $file .out.fq).sam > $(basename $file .out.fq).bam
samtools sort $(basename $file .out.fq).bam >$(basename $file .out.fq).sorted.bam
rm -rf $(basename $file .out.fq).bam
bedtools bamtobed -i $(basename $file .out.fq).sorted.bam >$(basename $file .out.fq).bed
done 
