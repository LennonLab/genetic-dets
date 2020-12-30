# Summarizing mutations by chemostat

# using guide tutorial at https://barricklab.org/twiki/pub/Lab/ToolsBacterialGenomeResequencing/documentation/tutorial_clones.html
# "Example 3. Analyze unique mutations for evidence of bias and selection" 

library(tidyverse)

###########################################
#separate .gd files according to chemstat
###########################################

# list .gd files
f <- list.files("~/GitHub/genetic-dets/breseq/genome_diff/", full.names = T)

# data of chemostat
strains <- read_csv("~/GitHub/genetic-dets/data/strains.csv")%>%
  filter(trt!="A") #remove ansector

# vector of chemostats
cstat <- unique(strains$cID)

#make folder for each chemostat
dir.create("~/GitHub/genetic-dets/breseq/diff_by_cID")

#copy files into proper folder
setwd("~/GitHub/genetic-dets/breseq/diff_by_cID/")

for(i in cstat) dir.create(i)
c.folders <- list.dirs(full.names = T)[-1] #remove ./

for (i in f){
  cur.c <- str_detect(i, cstat)
  cur.f <- str_detect(c.folders,cstat[cur.c])
  file.copy(i,c.folders[cur.f])
}

###########################################
# unify .gd files of each chemostat
###########################################
dir.create("../unified")

# using gdtools from breseq on carbonate
    # Curl version 7.54.0 loaded.
    # Sun/Oracle Java SE Development Kit version 11.0.2 loaded.
    # R version 3.6.0 loaded
    # bowtie2 version 2.4.2 loaded.
    # breseq version 0.32.0 loaded.
for (i in cstat){
  setwd (grep(i, c.folders, value = T))
  breseq.cmd <- paste0("gdtools UNION -o ../../unified/",i,"_unique.gd `ls *.gd`")
  system(paste("module load breseq; ",breseq.cmd))
  setwd("..")
}

###########################################
# annotate and count unified .gd files of each chemostat
###########################################
setwd("../unified")

# using gdtools from breseq on carbonate
    # Curl version 7.54.0 loaded.
    # Sun/Oracle Java SE Development Kit version 11.0.2 loaded.
    # R version 3.6.0 loaded
    # bowtie2 version 2.4.2 loaded.
    # breseq version 0.32.0 loaded.

# make csv file
breseq.cmd <- "gdtools ANNOTATE -o genome-diff.tsv -f TSV -r ../ancestor.gff ./*.gd"
system(paste("module load breseq; ",breseq.cmd))

breseq.cmd <- "gdtools COUNT  -o count-diff.csv -r ../ancestor.gff ./*.gd"
system(paste("module load breseq; ",breseq.cmd))

