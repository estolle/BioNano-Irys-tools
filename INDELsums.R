#by Eckart Stolle, Aug 2016
#barplots of InDel sums and fractions
#usage Rscript INDELsums.R inputfile outputname
library("ggplot2")
library("cowplot")
args <- commandArgs(trailingOnly = TRUE)
print(args[1])
input <- read.table(args[1])
colnames(input)<-c("Chr", "Type", "Sum", "ChrL", "LperMB", "GenomeL", "ChrGenomeFraction", "InDelsum", "fraction")
bold.16.text <- element_text(face = "bold", color = "black", size = 16)
bold.12.text <- element_text(face = "bold", color = "black", size = 12)
output <- (args[2])
library(ggplot2)
library(cowplot)
plotINDEL1 <- ggplot(data=input, aes(x=Chr, y=LperMB, group=Type)) +
  geom_bar(stat="identity", width=0.8, aes(Chr, LperMB, fill = Type), position=position_dodge(width = 1)) +
  geom_text(aes(label=paste(sprintf("%2.2f", LperMB*1000), "kb", sep=""), y=LperMB+0.001, x=Chr), hjust=0.0, vjust=+0.3, size=4.5, position = position_dodge(width = 1)) +
  coord_flip() + scale_fill_manual(values=c('black','darkgray')) +
  theme(title = bold.16.text, axis.title = bold.16.text, panel.grid.minor = element_line(colour="white", size=0.5), legend.position="top", axis.text.x = element_text(face="bold", color="black", size=16, angle=0), axis.text.y = element_text(face="bold", color="black", size=16, angle=0), axis.line = element_line(colour = "darkblue", size = 0.4, linetype = "solid") )+ 
  scale_x_continuous(breaks=seq(1,16,1)) +
  ggtitle("Mb InDel per Mb")
  plotINDEL1

plotINDEL2 <- ggplot(data=input, aes(x=Chr, y=fraction, group=Type)) +
  geom_bar(stat="identity", width=0.8, aes(Chr, fraction, fill = Type), position=position_dodge(width = 1)) +
  geom_text(aes(label=paste(sprintf("%2.2f", fraction*100), "%", sep=""), y=fraction+0.001, x=Chr), hjust=0.0, vjust=+0.3, size=4.5, position = position_dodge(width = 1)) +
  coord_flip() + 
  scale_fill_manual(values=c('black','darkgray')) +
  theme(title = bold.16.text, axis.title = bold.16.text, panel.grid.minor = element_line(colour="white", size=0.5), legend.position="top", axis.text.x = element_text(face="bold", color="black", size=16, angle=0), axis.text.y = element_text(face="bold", color="black", size=16, angle=0), axis.line = element_line(colour = "darkblue", size = 0.4, linetype = "solid") )+ 
  scale_x_continuous(breaks=seq(1,16,1)) +
  ggtitle("InDels fraction from all InDels")
  plotINDEL2

plotGRID <- plot_grid(plotINDEL1, plotINDEL2, labels=c("A", "B"), ncol = 2, nrow = 1)
ggsave(file = paste(output,"_plotINDEL_perMb.png",sep=""), height=15, width=15, type="cairo", plotINDEL1)
ggsave(file = paste(output,"_plotINDEL_frac.png",sep=""), height=15, width=15, type="cairo", plotINDEL2)
ggsave(file = paste(output,"_plotINDEL_grid.png",sep=""), height=15, width=15, type="cairo", plotGRID)
