# Guide_to_ddRAD
This is a step by step instruction on how to process ddRAD data. Library preparation is based on [rfseq_protocol_Zach_Gompert.pdf](rfseq_protocol_Zach_Gompert.pdf). Bioinformatic process mainly follows guidence from [NextGenNotes_v4_2019.pdf](NextGenNotes_v4_2019.pdf). 

The goal of this guidence is to process raw fastq files to the point where we can get the genotype estimates from Entropy from ddRAD seq data, as well as results for basic population structures including structural plots from Entropy and PCA plot from genotype estimates. 

### 1. File preparation ###
Convert library barcodes from mac to Unix format 
```
dos2unix lyc_barcodeKey_L1.csv
mac2unix lyc_barcodeKey_L1.csv 

dos2unix  lyc_barcodeKey_L2.csv
mac2unix lyc_barcodeKey_L2.csv 
```

### 2. Split fastq files ####
This is because the parsing time for the single big fastq file is too long, well beyond wall time 
```
split -l 90000000 ../Gomp032_S1_L001_R1_001.fastq
split -l 90000000 ../Gomp033_S2_L002_R1_001.fastq
```

### 3. Parse ### 
Removing barcodes and cut sites from raw reads and attaching ind. IDs

This is the code file: parse.sh
```
#!/bin/sh 
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --account=gompert-kp
#SBATCH --partition=gompert-kp
#SBATCH --job-name=L1lycparse

cd library1

module load perl

perl ../RunParseFork.pl x*
```
`RunParseForkl.pl` is attached in the depository 

#### Get individual ID file 
```
cut -d',' -f3- lyc_barcodeKey_L1.csv >lycID_L1.csv ### remove the first two columns
sed 1d lycID_L1.csv> lycID_L1new.csv

cut -d',' -f3- lyc_barcodeKey_L2.csv >lycID_L2.csv
sed 1d lycID_L2.csv> lycID_L2new.csv
```
#### Combine all fastq files #######
```
cat parsed_x* > parsed_comb_L1.fastq
cat parsed_x* > parsed_comb_L2.fastq
```
### get individual fastq files ###
```
#!/bin/sh
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --account=gompert-kp
#SBATCH --partition=gompert-kp
#SBATCH --job-name=L1splitfastq

## This script is to run the parse_barcodes.pl script on the cluster


cd /uufs/chpc.utah.edu/common/home/gompert-group3/data/lycaeides_chc_experiment/fastq/parsed/library1/

module load perl
perl ../splitFastq.pl ../lycID_L1new.csv parsed_comb_L1.fastq
```
Note: you can find [splitFastq.pl](splitFastq.pl) here. The script here is written to match the individual id like this: "VIC-L-20-17". If your individual ID doesn't look like this, you might need to adjust the individual ID row to match your individual id with the splitFastq.pl script.
This is the code line in splitFastq.pl that you need to adjust to match you individual ID: if (/^\@([A-Za-z0-9\-_]+)/).Here A-Za-z0-9\-_ means any uppercase letter (A-Z), any lowercase letter (a-z), any digit (0-9), the hyphen (-), or the underscore (_). You can ask chatGPT how to revise the code to match your individual id in perl language. 
