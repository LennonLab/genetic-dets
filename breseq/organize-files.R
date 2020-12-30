#separate .gd files according to chemstat

library(tidyverse)

# list .gd files
f <- list.files("~/GitHub/genetic-dets/breseq/genome_diff/", full.names = T)

# data of chemostat
strains <- read_csv("~/GitHub/genetic-dets/data/strains.csv")%>%
  filter(trt!="A") #remove ansector

# vector of chemostata
cstat <- unique(strains$cID)

#make folder for each chemostat
dir.create("~/GitHub/genetic-dets/breseq/diff_by_cID")

#copy files into proper folder
setwd("~/GitHub/genetic-dets/breseq/diff_by_cID/")

for(i in cstat) dir.create(i)
c.folders <- list.dirs(full.names = T)

for (i in f){
  cur.c <- str_detect(i, cstat)
  cur.f <- str_detect(c.folders,cstat[cur.c])
  file.copy(i,c.folders[cur.f])
}
