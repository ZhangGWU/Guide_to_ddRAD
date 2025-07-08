#!/usr/bin/perl
#
# 12i20 CCN change over to ForkManager. This is working with samtools 1.9
# 22v19 CCN tuned up for samtools vers 1.6 (not many changes)
# 26xii18 CCN version for anna needs to have paths to older version of samtools: /usr/local/bin/samtools-0.1.19/samtools
# This script is a wrapper around samtools for batch conversion, sorting and indexing of sam file. This version uses fork to split the job over mutliple processors. Adjust $ncpu for the desired number of cpus. 
#
# Usage: perl sam2bam.pl *sam
#
use warnings;
use Parallel::ForkManager;

my $pm=new Parallel::ForkManager(24); # change to 12 for melissa or idas

my $ctr = 0;
my $nfiles = @ARGV; 
print "Analyzing $nfiles files\n";

foreach $sam (@ARGV){
  $pm->start and next;
  $ctr++;
  $base = $sam;
  $base =~ s/sam//;
print "Compressing, sorting and indexing $base\n";
	system "samtools view -b -S -o $base"."bam $sam\n";
        system "samtools sort $base"."bam -o $base"."sorted.bam\n";
        system "samtools index $base"."sorted.bam\n";
  $pm->finish;
}
print "Waiting for Children...\n";
  $pm->wait_all_children;
print "Everybody is out of the pool!\n";
print "Finished $ctr files\n";

