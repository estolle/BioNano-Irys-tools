#Rscript INDELviolon.R $INFILE.ggin $INFILE.png
#by Eckart Stolle, Aug 2016
#violinplot of InDel size
#usage Rscript INDELviolin.R inputfile outputname
library("ggplot2")
library("easyGgplot2")
library("scales")
library("MASS")
args <- commandArgs(trailingOnly = TRUE)
print(args[1])
input <- read.table(args[1])
#names(input) <- c("Chr", "Type", "Length") #if there was a header
colnames(input)<-c("Chr", "Type", "Length")
output <- (args[2])
plot1 <- ggplot2.violinplot(data=input, xName='Chr',yName='Length', groupName = 'Type', Position=position_dodge(0.8),yScale="log10",trim=TRUE, axisLine=c(0.5, "solid", "black"), faceting=TRUE, facetingVarNames="Type", facetingDirection="horizontal", xTickLabelFont=c(14,"bold", "black"), xtickLabelRotation=90, ytickLabelRotation=0, showLegend=FALSE, removePanelGrid=TRUE,removePanelBorder=TRUE, backgroundColor="white", groupColors=c('#999999','lightblue'), legendPosition="top", addDot=TRUE, dotSize=1.0, dotPosition=c("jitter", "jitter"), jitter=0.5, legendPosition="top",orientation="horizontal",  mainTitle="Plot of InDel length by chromosome", xtitle="Chromosome", ytitle="Length (bp)")
plot2 <- ggplot2.violinplot(data=input, xName='Type',yName='Length',yScale="log10",trim=TRUE, axisLine=c(0.5, "solid", "black"),
xTickLabelFont=c(14,"bold", "black"), xtickLabelRotation=90, ytickLabelRotation=0, showLegend=FALSE, removePanelGrid=TRUE,removePanelBorder=TRUE, backgroundColor="white", addDot=TRUE, dotSize=2, dotPosition="jitter", jitter=0.3, orientation="horizontal", addMean=TRUE, meanPointShape=23, meanPointSize=10, meanPointColor="blue", meanPointFill="blue",  mainTitle="Plot of InDel lengths", ytitle="Length (bp)")

ggsave(file = paste(output,"_plot1.png",sep=""), height=15, width=15, type="cairo", plot1)
ggsave(file = paste(output,"_plot2.png",sep=""), height=10, width=15, type="cairo", plot2)
#dev.off()

