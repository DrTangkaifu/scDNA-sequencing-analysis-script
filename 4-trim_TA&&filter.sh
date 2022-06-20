#去掉5’及3’的碱基（末端补平的TA），然后再过滤低质量碱基


for file in /public/home/tangkaifu/test_hu/process/1-cutadapt/*.fq;
do
cd /public/home/tangkaifu/test_hu/process/3-remove_marker-reverse/$(basename $file .fq)

#By using the --cut option or its abbreviation -u, it is possible to unconditionally remove bases from the beginning or end of each read. If the given length is positive, the bases are removed from the beginning of each read. If it is negative, the bases are removed from the end.
awk 'BEGIN{FS="\t";OFS="\n"}{print$1,$2,$3,$4}' $(basename $file .fq).cut_reverse.fqt > $(basename $file .fq).cut_reverse.fq
#-u 1 -u -1 分别去掉5’及3’的碱基（末端补平的TA），然后再过滤低质量碱基
cutadapt -u 1 -u -1 -q 20,20 -m 15 -M 80 -o $(basename $file .fq).out.fq $(basename $file .fq).cut_reverse.fq 
#统计reads长度
#awk '{ c++; if((c-2)%4==0){ a[length()] ++} } END{ print "len\tseqs";I=asorti(a,b);for (i;i<=I;i++) print b[i]"\t"a[b[i]]}'${base_filename}.out.fq

#转移文件到统一文件夹
mkdir /public/home/tangkaifu/test_hu/process/4-trimTA/
cp $(basename $file .fq).out.fq /public/home/tangkaifu/test_hu/process/4-trimTA/
done
