##Genotype Likelihoods 3d PCA and 2d PCA

library(scatterplot3d)

gprob<-matrix(scan("/Users/katherinebell/iris_entropy/names_f_tran_common_loci.txt",n=199*1894,sep="",what='character'),nrow=199,ncol=1894,byrow=T)
gprobMat<-gprob[,-c(1:2)]
gprobMat[1:5,1:5]
gprobMat2<-matrix(as.numeric(gprobMat),nrow=199,ncol=1892,byrow=F)
gprobMat2[1:5,1:5]
pcaout<-prcomp(gprobMat2,center=T,scale=F)
summary(pcaout)

pc1.3<-pcaout$x[,1:3]
id<-as.vector(gprob[,1])
x<-pc1.3
cols<-NA
for(i in 1:length(x[,1])){
	if (id[i] == "bba")cols[i]="green"
	if (id[i] == "bea")cols[i]="blue"
	if (id[i] == "bfb")cols[i]="red"
	if (id[i] == "bfc")cols[i]="purple"
	if (id[i] == "bha")cols[i]="orange"
	if (id[i] == "bna")cols[i]="pink"
}
scatterplot3d(pcaout$x[,1],pcaout$x[,3],pcaout$x[,2],color=cols,xlab="PC1 6% Variance Explained", zlab="PC2 3.8% Variance Explained", ylab="PC3 2.4% Variance Explained")

## z is vertical axis, x is horisontal and y is the other one.

scatterplot3d(pcaout$x[,3],pcaout$x[,1],pcaout$x[,2],color=cols,ylab="PC1 6% Variance Explained", zlab="PC2 3.8% Variance Explained", xlab="PC3 2.4% Variance Explained")

scatterplot3d(pcaout$x[,2],pcaout$x[,1],pcaout$x[,3],color=cols,zlab="PC1 6% Variance Explained", xlab="PC2 3.8% Variance Explained", ylab="PC3 2.4% Variance Explained")

## with lollipops type='h'

scatterplot3d(pcaout$x[,2],pcaout$x[,1],pcaout$x[,3],color=cols,zlab="PC1 6% Variance Explained", xlab="PC2 3.8% Variance Explained", ylab="PC3 2.4% Variance Explained",type='h')

For labeled PCA plot:
pdf("iris_PCA_1vs2.pdf",width=5,height=5)
plot(pcaout$x[,1],pcaout$x[,2],type="n",xlab="PC1",ylab="PC2")
points(pcaout$x[gprob[,1] == "bba",1],pcaout$x[gprob[,1] == "bba",2],col="green",cex=0.1,text(pcaout$x[,1],pcaout$x[,2],labels=gprob[,2],cex=0.3))
points(pcaout$x[gprob[,1] == "bea",1],pcaout$x[gprob[,1] == "bea",2],col="blue",cex=0.1)
points(pcaout$x[gprob[,1] == "bfb",1],pcaout$x[gprob[,1] == "bfb",2],col="red",cex=0.1)
points(pcaout$x[gprob[,1] == "bfc",1],pcaout$x[gprob[,1] == "bfc",2],col="purple",cex=0.1)
points(pcaout$x[gprob[,1] == "bha",1],pcaout$x[gprob[,1] == "bha",2],col="orange",cex=0.1)
points(pcaout$x[gprob[,1] == "bna",1],pcaout$x[gprob[,1] == "bna",2],col="pink",cex=0.1)
dev.off()

##For non-labeled PCA's:

pdf("iris_PCA_1vs2.pdf",width=5,height=5)
plot(pcaout$x[,1],pcaout$x[,2],type="n",xlab="PC1",ylab="PC2")
points(pcaout$x[gprob[,1] == "bba",1],pcaout$x[gprob[,1] == "bba",2],col="green",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bea",1],pcaout$x[gprob[,1] == "bea",2],col="blue",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfb",1],pcaout$x[gprob[,1] == "bfb",2],col="red",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfc",1],pcaout$x[gprob[,1] == "bfc",2],col="purple",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bha",1],pcaout$x[gprob[,1] == "bha",2],col="orange",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bna",1],pcaout$x[gprob[,1] == "bna",2],col="pink",pch=19,cex=1)
dev.off()

pdf("iris_PCA_1vs3.pdf",width=5,height=5)
plot(pcaout$x[,1],pcaout$x[,3],type="n",xlab="PC1",ylab="PC3")
points(pcaout$x[gprob[,1] == "bba",1],pcaout$x[gprob[,1] == "bba",3],col="green",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bea",1],pcaout$x[gprob[,1] == "bea",3],col="blue",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfb",1],pcaout$x[gprob[,1] == "bfb",3],col="red",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfc",1],pcaout$x[gprob[,1] == "bfc",3],col="purple",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bha",1],pcaout$x[gprob[,1] == "bha",3],col="orange",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bna",1],pcaout$x[gprob[,1] == "bna",3],col="pink",pch=19,cex=1)
dev.off()

pdf("iris_PCA_2vs3.pdf",width=5,height=5)
plot(pcaout$x[,2],pcaout$x[,3],type="n",xlab="PC2",ylab="PC3")
points(pcaout$x[gprob[,1] == "bba",2],pcaout$x[gprob[,1] == "bba",3],col="green",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bea",2],pcaout$x[gprob[,1] == "bea",3],col="blue",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfb",2],pcaout$x[gprob[,1] == "bfb",3],col="red",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bfc",2],pcaout$x[gprob[,1] == "bfc",3],col="purple",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bha",2],pcaout$x[gprob[,1] == "bha",3],col="orange",pch=19,cex=1)
points(pcaout$x[gprob[,1] == "bna",2],pcaout$x[gprob[,1] == "bna",3],col="pink",pch=19,cex=1)
dev.off()




