#!/usr/bin/env Rscript

library(sciClone)

##first without cn points
v0 = read.table("data/mmy.snv.vafs", sep="\t", header=TRUE)
annotation <- NULL
cn0 = read.table("data/cn.dat")
cn0 = cn0[,c(1,2,3,5)]
clusterParams="empty"
reg0 = read.table("data/exclude.loh")
reg0 = reg0[,c(1,2,3)]
sc = sciClone(vafs=list(v0), sampleNames=c("MMY4"), copyNumberCalls=list(cn0), minimumDepth=100, doClustering=TRUE, annotation=annotation,clusterParams=clusterParams,maximumClusters=10, regionsToExclude=reg0)
writeClusterTable(sc, "clusters")
writeClusterSummaryTable(sc, "cluster.summary")

#then with CN points
v0 = read.table("data/mmy.snv.vafs.cn", sep="\t", header=TRUE)
sc.cn = sciClone(vafs=list(v0), sampleNames=c("MMY4"), copyNumberCalls=list(cn0), minimumDepth=100, doClustering=TRUE, annotation=annotation,clusterParams=clusterParams,maximumClusters=10, regionsToExclude=reg0)
writeClusterTable(sc.cn, "clusters.cn")
writeClusterSummaryTable(sc.cn, "cluster.cn.summary")

save.image("out.Rdata") 
source("plot.R");

