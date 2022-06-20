#使用bedtools计算区域覆盖的reads数，为后续R语言绘图准备输入文件
filedir=/public/home/tangkaifu/test_hu/process/4-trimTA
outdir=/public/home/tangkaifu/test_hu/process/5-calculate
hg38ref=/public/home/tangkaifu/reference/hg38_Human
mm10ref=/public/home/tangkaifu/reference/mm10_Mouse


for file in $filedir/*.sorted.bam 
do
cd $outdir
bedtools coverage -a $hg38ref/hg38.window.bed.region -b $file > $(basename $file .sorted.bam).window.bed.region.cov
done

