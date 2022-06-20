#计算每条染色体reads数及不同长度的reads数，
filedir=/public/home/tangkaifu/test_hu/process/4-trimTA
outdir=/public/home/tangkaifu/test_hu/process/5-calculate
hg38ref=/public/home/tangkaifu/reference/hg38_Human
mm10ref=/public/home/tangkaifu/reference/mm10_Mouse


for file in $filedir/*.bed
do
mkdir $outdir
cd $outdir

for chrom in `seq 1 22` X Y M;
do
echo chr$chrom >>$(basename $file .bed)_chr_length
awk -v a=chr$chrom '{if($1 == a)print $0}' $file |wc -l >>$(basename $file .bed)_chr_count

awk -v a=chr$chrom '($3==a && $6!="*" ){print length($10)}' $filedir/$(basename $file .bed).sam >> $(basename $file .bed)_readlen
awk '{sum[$1]+=1}END{for(i in sum)print i"\t"sum[i]}'  $(basename $file .bed)_readlen |sort>$(basename $file .bed)_readlen_count
#perl /public1/home/jiangjiayu/copy/human_mouse_smallrna/human/2-remove_marker/quchong.pl length length_freq
done
paste $(basename $file .bed)_chr_length $(basename $file .bed)_chr_count >$(basename $file .bed)_chr_length_count
mv $(basename $file .bed)_chr_length $(basename $file .bed)_chr_count $(basename $file .bed)_readlen
done 


