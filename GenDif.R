## pairwise Fst, speciation continuum
## R version 4.4.2
library(scales)
library(RColorBrewer)
library(ape)
library(phangorn)

pf<-list.files(pattern="p_")
L<-49028
N<-length(pf)

ids<- gsub(pattern="p_",replacement="",gsub(pattern="_filtered2x_frogs.txt",replacement="",pf))

P<-matrix(NA,nrow=L,ncol=N)
for(j in 1:N){
	pp<-read.table(pf[j],header=FALSE)
	P[,j]<-pp[,3]
}

## uses Fst=Gst from Nei 1973, Analysis of gene diversity in subdivided populations
fst<-function(p1=NA,p2=NA){
	pbar<-(p1+p2)/2
	ht<-2*pbar*(1-pbar)
	hs<-p1*(1-p1) + p2*(1-p2)
	ff<-mean(ht-hs)/mean(ht)
	return(ff)
}

Ncom<-N*(N-1)*0.5
Fvec<-rep(NA,Ncom)
id1<-rep(NA,Ncom)
id2<-rep(NA,Ncom)

k<-1
for(i in 1:(N-1)){for(j in (i+1):N){
	Fvec[k]<-fst(P[,i],P[,j])
	id1[k]<-ids[i]
	id2[k]<-ids[j]
	k<-k+1
}}

Fmat<-matrix(NA,nrow=N,ncol=N)
for(i in 1:N){for(j in 1:N){
	Fmat[i,j]<-fst(P[,i],P[,j])
}}
rownames(Fmat)<-ids
colnames(Fmat)<-ids

write.table(file="FstMatrix.txt",round(Fmat,5),col.names=T,row.names=T)

ut<-upgma(as.dist(Fmat))


pc<-prcomp(t(P),center=TRUE,scale=FALSE)

# 2 = both ACA, 1 not
csid<-(grepl(pattern="ACA",id1) & grepl(pattern="ACA",id2)) + 1
cs<-alpha(c("darkgray","firebrick"),.5)

pdf("UCESpecCont.pdf",width=9,height=9)
par(mfrow=c(2,2))
par(mar=c(4.5,5.5,2.5,1.5))
plot(sort(Fvec),pch=19,col=cs[csid][order(Fvec)],xlab=expression(paste("Rank",F[ST])),ylab=expression(paste(F[ST])),cex.lab=1.4)
legend(1,.9,c("heterospecific","conspecific"),col=cs,pch=19,bty='n')
title(main="(A) Speciation Continuum",cex.main=1.3)

cspc<-c(brewer.pal(7,"Blues")[-1],brewer.pal(6,"Greens")[-1],"orange","firebrick","orchid2","goldenrod3","black")
plot(pc$x[,1],pc$x[,2],pch=19,col=alpha(cspc,.7),xlab="PC1 (42.2%)",ylab="PC2 (18.2%)",cex.lab=1.4)
legend(-20,45,ncol=4,legend=ids,col=alpha(cspc,.7),bty='n',pch=19)
title(main="(B) Population Structure",cex.main=1.3)

plot(ut)
title(main="(C) Phylogenetic Tree (UPGMA)",cex.main=1.3)
dev.off()


pdf("UCEFst.pdf",width=5,height=5)
par(mar=c(4.5,5.5,2.5,1.5))
plot(sort(Fvec),pch=19,col=cs[csid][order(Fvec)],xlab=expression(paste("Rank",F[ST])),ylab=expression(paste(F[ST])),cex.lab=1.4)
legend(1,.9,c("heterospecific","conspecific"),col=cs,pch=19,bty='n')
dev.off()
