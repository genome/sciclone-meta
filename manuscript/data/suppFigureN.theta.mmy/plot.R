load("out.Rdata")
library(sciClone)
sc.plot1d(sc,"mmy4.pdf", highlightSexChrs=TRUE, highlightsHaveNames=FALSE, overlayClusters=TRUE, showTitle=TRUE, cnToPlot=c(1:3),highlightCnPoints=TRUE)
sc.plot1d(sc.cn,"mmy4.cn.pdf", highlightSexChrs=TRUE, highlightsHaveNames=FALSE, overlayClusters=TRUE, showTitle=TRUE, cnToPlot=c(1:3),highlightCnPoints=TRUE)
