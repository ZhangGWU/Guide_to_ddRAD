#!/usr/bin/perl

use warnings;

### Calculates number of reads per locus and individual for all sites
### in an mpgl file (produced from vcf) and for all individuals in an
### indiv_ids.txt file.  Uses samtools to query bam files for
### individuals at those sites.

### variants.mpgl: script only grabs the locus id from the beginning
### of the line, in the format: scaffold135:55 (any word character
### indicating the contig or scaffold, a colon, and the basepair
### position to be queried).  Because these come from the vcf, which
### comes from the bam, these labels in mpgl will match what is the
### bam.  If not, your files are likely out of sync or there is a
### glitch in one of the upstream scripts.

### indiv_ids.txt: this is a comma-separated file, with one individual
### per line. Only the first field on the line is used.  As written,
### individual ids can have any word character, a period or a dash in
### their name.  For example:
# ind,pop,taxon,col
# aculshet_rt_166_VN96164,aculshet,rt,#272F43
# alzamay_rt_145_VN96143,alzamay,rt,#272F43
# alzamay_rt_146_VN96144,alzamay,rt,#272F43
# alzamay_rt_147_VN96145,alzamay,rt,#272F43
# alzamay_rt_148_VN96146,alzamay,rt,#272F43

unless(scalar @ARGV == 3){
    print "Usage: coverage_calc_bam.pl variants.mpgl indiv_ids.txt pathto/bamdir/ \n";
    exit;
}
unless(-e $ARGV[2] && -d $ARGV[2]){
    print "The second argument should be a directory\n";
    exit;
}

open(VAR, "$ARGV[0]") or die "Failed to open mpgl for reading";
$bedfile = "$ARGV[0].bed";
open(BED, '>', $bedfile) or die "Failed to open bed file for writing";
while(<VAR>){
    m/^(\w+):(\d+)/;
    print BED "$1 ", $2-1, " $2\n";
    $counts{"$1:$2"} = 0;
    push @chrom, $1;
    push @pos, $2;
}
close(VAR);
close(BED);

open(IND, "$ARGV[1]") or die "Failed to open indiv_ids.txt for reading";
<IND>;
while(<IND>){
    m/^([-.\w]+),/;
    push @inds, $1;
}
close(IND);


open(OUT, '>', "$ARGV[0]_coverage.csv") or 
    die "Failed to open file for writing";
foreach $ind (@inds){
    if(-e "$ARGV[2]aln$ind.sorted.bam"){
	@result = `samtools depth -b $bedfile $ARGV[2]aln$ind.sorted.bam`;
	chomp(@result);
	print "$ind\n";
	print OUT "$ind";
	## samtools does not return anything for 0 depth, so need to fill these in
	foreach $k (keys %counts){
	    $counts{$k} = 0;
	}
	foreach (@result){
	    ($chrom, $pos, $c) = split /\s+/;
	    $counts{"$chrom:$pos"} = $c;
	}
	foreach $i (0..$#chrom){
	    $c = $counts{"$chrom[$i]:$pos[$i]"};
	    print OUT ",$c";
	}
	print OUT  "\n";
    }
    else{
	print "No bamfile for $ind\n";
	print OUT "$ind";
	print OUT ",0" x scalar keys %counts;
	print OUT  "\n";
    }
}
