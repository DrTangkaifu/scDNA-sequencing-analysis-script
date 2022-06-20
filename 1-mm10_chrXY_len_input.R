# library(data.table)
library(ggplot2)
setwd("/public/home/tangkaifu/test_hu/process/5-calculate/")

filelist_sampleid <- c("L929","Raw264_7")
len = length(filelist_sampleid)
for(j in 1:len){
  data_chrXY <- read.table(paste0(filelist_sampleid[j],".window.bed.region.cov"),sep="\t") 
  
  chrXYreads<-sum(data_chrXY$V7)/2
  
  allreads<-chrXYreads
  normalized <-c()
  for(i in 1:nrow(data_chrXY)){  
    normalized[i] <- (data_chrXY[i,7]/allreads*1000000)
  } 
  data1<-cbind(data_chrXY,normalized)
  log_normalized <-c()
  for(i in 1:nrow(data_chrXY)){  
    log_normalized[i]<- log2(data1[i,11]+1)
  }
  data1<-cbind(data1,log_normalized)
  chr <-c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY","chrz") 
  
  
  #因为人类染色体还有很多非常规染色体，如果全部画出来会不好看，所有此处只画出常规染色体。也可以在文件hg19.txt里面只输入常规染色体???
  data2<- data1[data1$V1 %in% chr,]
  data2$V1 <- factor(data2$V1,levels=c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY","chrz") )
  windowsFonts(myFont=windowsFont("Arial")) #要修改字体，先要初始化字???
  #name
  png(file=paste0("./",filelist_sampleid[j],".png"),width=750,height=500)
  
  ggplot(data2,aes(x=V2/1000000,y =log_normalized))+facet_grid(V1~.,scales="fixed")+geom_line()+theme_classic()+scale_x_continuous(expand = c(0,3))+scale_y_discrete(breaks=NULL
  )+theme(
    strip.text.y=element_text(size=10, family="myFont", color="black",angle=0,hjust=0),
    legend.position="none",
    panel.grid.minor=element_blank(),
    panel.grid.major=element_blank(),
    #plot.title=element_text(size=20,face="bold"),
    axis.text.x =element_text(size=10, family="myFont", color="black"),
    axis.title= element_text(size=12, family="myFont", color="black"),
    strip.background=element_blank(),
    panel.background=element_rect(fill="white"),
    axis.line=element_line(linetype=1)
  )+
    xlab("")+
    ylab("")
    #ylab("Reads Density")
  
  dev.off()
  
}
#chrM======================================================================================
 