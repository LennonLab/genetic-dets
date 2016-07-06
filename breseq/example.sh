#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=8,vmem=50gb,walltime=4:00:00
#PBS -M meglarse@indiana.edu
#PBS -m abe
#PBS -j oe
module load gcc/4.9.2
module load bowtie2/2.2.6
module load r/3.1.1
module load breseq/0.23
cd /N/dc/projects/Lennon_sequences/Larsen_sequences
mkdir ./breseq_analysis/brseq_output/strain_name
breseq -o ./breseq_analysis/brseq_output/strain_name -r ./breseq_analysis/ancestor.gff ./sequences/*_strain_name*
cp ./breseq_analysis/breseq_output/strain_name/output/output.gd ./breseq_analysis/breseq_compare/strain_name.gd