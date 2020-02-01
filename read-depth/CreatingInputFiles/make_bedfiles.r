
#Getting input bed file for each chromosome

#Data_Input

sv <- read.csv("CNV_Insertions_Deletions.csv", header = T)

###Making a list for the FOR loop
chromosomes = c(1:22, "X")


#Creating bed files for SVs in each chromosome. 
#Removing the title row
for(i in chromosomes) {
name = paste('chr', i, sep = '')
name <- subset(sv, sv$chr == name)
write.table(name, file=paste('chr', i, '.csv', sep = ''),col.names=F, row.names=F, sep=',')
}

