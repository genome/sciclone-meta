#this is a short test
library(sciClone)

#read in vaf data
v = read.table("data/vafs.dat",header=T);
v1 = v[1:100,c(1,2,8,9,10)]
v2 = v[1:100,c(1,2,11,12,13)]
v3 = v[1:100,c(1,2,14,15,16)]

#read in regions to exclude
regions = read.table("data/exclude.chr1")

#read in copy number data
cn1 = read.table("data/copy_number_tum1")
cn1 = cn1[,c(1,2,3,5)]
cn2 = read.table("data/copy_number_tum2")
cn2 = cn2[,c(1,2,3,5)]
cn3 = read.table("data/copy_number_tum3")
cn3 = cn3[,c(1,2,3,5)]

#set sample names
names = c("Sample1","Sample2","Sample3")

#regions to exclude
reg1 = read.table("data/regionsToExclude")


#make an output directory, deleting old results first if they exist
suppressWarnings(dir.create("results.new"))
unlink("results.new/*", recursive=TRUE)


cat("\n")
cat("=========================================================\n")
cat("Test 1 - single sample - shortTest1\n")
cat("\n")


print("")
#run one sample
sc = sciClone(vafs=v1,
         copyNumberCalls=cn1,
         sampleNames=names[1],
         regionsToExclude=reg1)
writeClusterTable(sc, "results.new/clusters1")
sc.plot1d(sc,"results.new/clusters1.1d.pdf")



cat("\n")
cat("=========================================================\n")
cat("Test 2 - two samples - shortTest2\n")
cat("\n")
#run two samples
sc = sciClone(vafs=list(v1,v2),
              copyNumberCalls=list(cn1,cn2),
              sampleNames=names[1:2])
writeClusterTable(sc, "results.new/clusters2")
sc.plot1d(sc,"results.new/clusters2.1d.pdf")
sc.plot2d(sc,"results.new/clusters2.2d.pdf")



cat("\n")
cat("=========================================================\n")
cat("Test 3.0 - three samples - should fail")
cat("\n")
#run two samples
sc = sciClone(vafs=list(v1,v2,v3),
              copyNumberCalls=list(cn1,cn2,cn3),
              sampleNames=names,
              regionsToExclude=list(reg1,reg1))
if(!(is.null(sc))){
  print("ERROR - this should have failed, because there are no cn-neutral points in all three samples")
}


cat("\n")
cat("=========================================================\n")
cat("Test 3.1 - three samples - should succeed")
cat("\n")
#run two samples
sc = sciClone(vafs=list(v1,v2,v3),
              copyNumberCalls=list(cn1,cn2,cn2),
              sampleNames=names,
              regionsToExclude=list(reg1,reg1))
writeClusterTable(sc, "results.new/clusters3")
sc.plot1d(sc,"results.new/clusters3.1d.pdf")
sc.plot2d(sc,"results.new/clusters3.2d.pdf")
sc.plot3d(sc, sc@sampleNames, size=700, outputFile="results.new/clusters3.3d.gif")


cat("\n")
cat("=========================================================\n")
cat("Done - compare output in results.new/ to results/ May be slight differences in p-vals")
cat("due to RNG, rounding, etc, but otherwise should be identical")
cat("\n")
