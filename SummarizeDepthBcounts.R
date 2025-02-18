library(data.table)

dat<-fread("frogs_uce_depth.txt",header=FALSE)
dm<-as.matrix(dat[,-c(1:2)])
mn<-apply(dm,1,mean)
prop<-apply(dm > 0,1,mean)

keep<-mn > 2 & prop > 0.8

length(keep)
#[1] 1034631
dids<-as.data.frame(dat[,1:2])
pos<-paste(dids[keep,1],dids[keep,2],sep="-")

#pos<-as.numeric(unlist(dat[keep,2]))
#length(pos)

save(list=ls(),file="positions.rdat")

## scan all initial called SNPs
snps_all<-read.table("pos_all.txt",header=FALSE)
## scan snps remaining
snps_kept<-read.table("pos_kept.txt",header=FALSE)

## remove true snps from initial set
snps_all_ids<-paste(snps_all[,1],snps_all[,2],sep="-")
snps_kept_ids<-paste(snps_kept[,1],snps_kept[,2],sep="-")

drop<-which(snps_all_ids %in% snps_kept_ids)

## get initially called but then dropped
bad_snps <-snps_all_ids[-drop]

pos_keep<-pos[-which(pos %in% bad_snps)]
##  945249 = number of sites that wouldn't have been filtered out

write.table(file="invariant_regions.txt",pos_keep,row.names=FALSE,col.names=FALSE,quote=FALSE)


