#!/bin/bash
#循环去除marker
allwd=/public/home/tangkaifu/test_hu/process
startwd=$allwd/1-cutadapt
outwd=$allwd/2-remove_marker
for file in $startwd/*.fq;
do

base_filename=$(basename $file .fq)
abs_filename=`$pwd`/${base_filename}.fq
raw_filename=${base_filename}.fq

mkdir $outwd/$base_filename
seq_p50=$allwd/../seq_p50.txt
seq_p50_reverse=$allwd/../seq_p50_reverse.txt

cd $outwd/$base_filename
awk '{if(NR%4!=0)ORS="\t";else ORS="\n"}1' $startwd/${base_filename}.fq > ${raw_filename}t

filename=${raw_filename}t
temp_file=temp_file
mkdir -p temp_folder
#leading strand
i=1
cat $seq_p50 | while read seq_i
do
 if [ $i -eq 1 ];then
	length_i=`echo $seq_i | awk '{print length($0)}'`
	echo -e "${seq_i}\t${length_i}\tmapping"
	
	awk 'BEGIN{OFS="\t";FS="\t"}{start_num=match($2,"'"$seq_i"'");
		if(start_num==0){print $1,$2,$3,$4
			}else if(start_num == 1){print $1,substr($2,length("'"$seq_i"'")+1),$3,substr($4,length("'"$seq_i"'")+1)
			}else if(start_num > 1 && length("'"$seq_i"'") < length($2)){print $1,substr($2,1,start_num-1)substr($2,start_num+length("'"$seq_i"'")),$3,substr($4,1,start_num-1)substr($4,start_num+length("'"$seq_i"'"))
			}else if(start_num > 1 && length("'"$seq_i"'") == length($2)){printf"%0s","" #到该条记录时输出0个字符，即删除此记录
			}else{print "~~~~~~~~~~"
			}
	}' $filename > ./temp_folder/${temp_file}$i
	
	let "i=$i+1"
 else 
	length_i=`echo $seq_i | awk '{print length($0)}'`
	echo -e "${seq_i}\t${length_i}\tmapping"
	
	awk 'BEGIN{OFS="\t";FS="\t"}{start_num=match($2,"'"$seq_i"'");
		if(start_num==0){print $1,$2,$3,$4
			}else if(start_num == 1){print $1,substr($2,length("'"$seq_i"'")+1),$3,substr($4,length("'"$seq_i"'")+1)
			}else if(start_num > 1 && length("'"$seq_i"'") < length($2)){print $1,substr($2,1,start_num-1)substr($2,start_num+length("'"$seq_i"'")),$3,substr($4,1,start_num-1)substr($4,start_num+length("'"$seq_i"'"))
			}else if(start_num > 1 && length("'"$seq_i"'") == length($2)){printf"%0s","" #到该条记录时输出0个字符，即删除此记录
			}else{print "~~~~~~~~~~" 
			}
	}' ./temp_folder/${temp_file}$((i-1)) > ./temp_folder/${temp_file}$i
	let "i=$i+1"
	echo $i
	#rm ./temp_folder/${temp_file}$((i-4))
	 fi
 rm ./temp_folder/${temp_file}$((i-4))
done
	
mv ./temp_folder/${temp_file}666 ./


 

<<COMMENT # awk by raw_fq
	awk 'NR%4 ==2 {start_num=match($0,"'"$seq_i"'");
		if(start_num==1){print substr($0,length("'"$seq_i"'"),length($0))	#当开头为marker序列时，取右边的目标序列
			}else if(start_num==0){print $0		#当不匹配marker序列时，输出原序列
			}else if(){
			}else{
			}
	}' $filename
COMMENT

cd $pwd
done
