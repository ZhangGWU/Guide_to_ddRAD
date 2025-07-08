#!/usr/bin/perl
# 11ix20 CCN correct to missing filter - 0,0:0 was a typo, change to 0,0,0
# 16x19 CCN modified for bcftools 1.9
# 31v19 CCN tuned up for samtools specific vcf format
# 13iv19 CCN adding modification to kick out Z chromosome loci = Scaffold 1631
# 14vi18 CCN more modifications - this is now 'vcfFilter_CCN.pl'
# added scaffold and position numbers for fail messages
# option: capture with > wanrnings.txt on command line
# 13vi18 Zach's vcf filtering. Few modifications by CCN
use warnings;
use strict;

# this program filters a vcf file based on overall sequence coverage, number of non-reference reads, number of alleles, and reverse orientation reads

# usage vcfFilter.pl infile.vcf
#
# change the marked variables below to adjust settings
#

#### stringency variables, edits as desired
my $minCoverage = 766; # minimum number of sequences; DP   example 175 inds * 2 = 350 = 2x coverage
# my $minAltRds = 20; # minimum number of sequences with the alternative allele; AC  # given how samtools deals with missing data, this is no longer valid filter
my $notFixed = 1.0; # removes loci fixed for alt; AF
my $bqrs = 3; # maximum absolute value of the base quality rank sum test; BaseQRankSum BQB as z-score normal approximation - 3 sd
my $mqrs = 2.5; # maximum absolute value of the mapping quality rank sum test; MQRankSum  MQB
my $rprs = 2; # maximum absolute value of the read position rank sum test; ReadPosRankSum  RPB
my $afreqMin = 0.05; # minimum allele freq; AF1  #
my $afreqMax = 0.95; # maximum allele freq; AF1  #
my $mq = 30; # minimum mapping quality; MQ
my $miss = 77; # maximum number of individuals with no data (this is essential the old -d but using numbers of inds rather than proportion)
################################ 
my $d;

my @line;

my $in = shift(@ARGV);
open (IN, $in) or die "Could not read the infile = $in\n";
#$in =~ m/^([a-zA-Z_\-\d+]+\.vcf)$/ or die "Failed to match the variant file\n";
$in =~ m/^([a-z]+\.vcf)$/ or die "Failed to match the variant file\n"; # for: 'output.vcf'
open (OUT, "> filtered_firstRound_$1") or die "Could not write the outfile\n";

my $flag = 0;
my $cnt = 0;

while (<IN>){
	chomp;
	$flag = 1;
#	print "\n";
	if (m/^\#/){ ## header row, always write
		$flag = 1;
	}
	elsif (m/(Chromosome\d+|ctg\d+\.\d+)/){ ## this is a sequence line, you migh need to edit this reg. expr.   Scaffold_2;HRSCAF_10    11407
	  my $scaff = $1;
	  my $pos = $2;
	  $flag = 1;
#	  if ($scaff == 1631){
#	    $flag = 0;
#	    	print "$scaff $pos fail Z : ";
#	  }
	  $d = () = (m/\d\/\d:0,0,0/g);    # samtools gives a genotype even for no data
		if ($d >= $miss){
			$flag = 0;
			print "$scaff $pos fail missing : ";
		}
		if (m/[ACTGN]\,[ACTGN]/){ ## two alternative alleles identified
			$flag = 0;
			print "$scaff $pos fail allele : ";
		}
		@line = split(/\s+/,$_);
		if(length($line[3]) > 1 or length($line[4]) > 1){   # should not be indels (-I) but leave this in
			$flag = 0;
			print "$scaff $pos fail INDEL : ";
		}
		m/DP=(\d+)/ or die "Syntax error, DP not found\n";
		if ($1 < $minCoverage){
			$flag = 0;
			print "$scaff $pos fail DP : ";
		}
		# m/\s+AC=(\d+)/ or die "Syntax error, AC not found\n";  # see note above - not useful with samtools 1.9
		# if ($1 < $minAltRds){
		# 	$flag = 0;
		# 	print "$scaff $pos fail AC : ";
		# }
		m/AF1=([0-9\.e\-]+)/ or die "Syntax error, AF not found\n";  # AF1 in samtools
		if ($1 == $notFixed){
			$flag = 0;
			print "$scaff $pos fail AF = 1 : ";
		}
		if(m/BQB=([0-9\-\.]*)/){   # = BaseQRankSum in GATK
			if (abs($1) > $bqrs){
				$flag = 0;
				print "$scaff $pos fail BQRS : ";
			}
		}
		if(m/MQB=([0-9\-\.]*)/){   # = MQRankSum in GATK
			if (abs($1) > $mqrs){
				$flag = 0;
				print "$scaff $pos fail MQRS : ";
			}
		}
		if(m/RPB=([0-9\-\.]*)/){   # = ReadPosRankSum in GATK
			if (abs($1) > $rprs){
				$flag = 0;
				print "$scaff $pos fail RPRS : ";
			}
		}
		if(m/AF1=([0-9\.]+)/){ 
			if ( ($1 < $afreqMin) || ($1 > $afreqMax) ){
				$flag = 0;
				print "$scaff $pos fail AF : ";
			}
		}
		if(m/MQ=([0-9\.]+)/){
			if ($1 < $mq){
				$flag = 0;
				print "$scaff $pos fail MQ : ";
			}
		}
		else{
			$flag = 0;
			print "$scaff $pos faile no MQ : ";
		}
		if ($flag == 1){
			$cnt++; ## this is a good SNV
		}
	}
	else{
		print "Warning, failed to match the chromosome or scaffold name regular expression for this line\n$_\n";
		$flag = 0;
	}
	if ($flag == 1){
		print OUT "$_\n";
	}
}
close (IN);
close (OUT);

print "Finished filtering $in\nRetained $cnt variable loci\n";

# my $qd = 2; # minimum ratio of variant confidenct to non reference read depth; QD  # no analog in samtools
