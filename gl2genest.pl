#!/usr/bin/perl

## This script returns a genotype matirx (locus by ind) with genotype
## means (point estimates) from a genotype likelihood file

## USAGE: perl gl2genest.pl file.mpgl
use warnings;

$in = shift (@ARGV);

open (IN, $in) or die;
$out = $in;
#$out =~ s/gl$/txt/;
open (OUT, "> gl_$out") or die;
while (<IN>){
    chomp;
#    if (s/^scaffold_\d+:\d+\s+//){ ## this line has genotype data, get rid of locus id
     if (s/^(Chromosome\d+|ctg\d+\.\d+):\d+\s+//){ 
	@line = split(" ",$_);
	@gest = ();
	while (@line){
	    $sum = 0;
	    for $i (0..2){ ## three genotyple likelihoods for each individual
		$gl[$i] = shift(@line);
		$gl[$i] = 10 ** ($gl[$i]/-10);
		$sum += $gl[$i];
	    }
	    $gest = 0;
	    for $i (0..2){ ## normalize, and calculate mean genotype
		$gl[$i] = $gl[$i]/$sum;
		$gest += $i * $gl[$i];
	    }
	    $gest = sprintf("%.5f",$gest);
	    push(@gest, $gest);
	}
	$gest = join(" ",@gest);
	print OUT "$gest\n";
    }
}
close (IN);
close (OUT);
