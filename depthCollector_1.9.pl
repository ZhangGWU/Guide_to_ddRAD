#!/usr/bin/perl
# 21ix19 CCN modified for non-ref projects
# CCN 15vi18 collecting depth coverage (DP=) from GATK vcf

#Usage:perldepthCollector.pl file.vcf

use warnings;

$vcf = shift @ARGV;
open(VCF, $vcf) or die "Could not open $vcf\n";
open(OUT, "> depth_$vcf");
while(<VCF>){
    chomp;
#    if (m/^Scaffold\_(\d+);HRSCAF\_\d+\s+(\d+)\s+[.\w]+\s+([ACTG])\s+([ACTG])\s+[0-9.]+\s+[.\w]+\s+AC=\d+;AF=([\d.e-]+)/){
#    if (m/^scaffold\_(\d+)\s+(\d+).*DP=(\d+);/){
     if (m/(Chromosome\d+|ctg\d+\.\d+)\t(\d+).*DP=(\d+);/){
      print "$1 $2 $3\n";
	print OUT "$1 $2 $3 \n";
    }
  }
close(VCF);
close(OUT);
