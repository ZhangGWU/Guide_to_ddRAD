#!/usr/bin/perl
use warnings;

# 25iii17 CCN script to remove tapeworm seqs from dDocent-generated reference.fasta

#USEAGE: perl tapewormRemover.pl reference.fasta

$scaffs = shift @ARGV;
my $cntr=0;
my $twcntr=0;
open (IN, $scaffs) or die;
open (OUT, "> good_$scaffs") or die "failed to write\n";
while (<IN>){        
  chomp;
#  if (/^(\>[Contig]+\_[0-9]+)/){
   if (/^(\>[scaffold]+\_[0-9]+)/){
    $scaff = $1;
    foreach(0){
      $seq = <IN>;
      chomp($seq);
      if ($seq =~ /ATCTCGTATGCCGTCTTCTGCTTG/){   # this is the most frequently encountered, #2 in patent
	$twcntr++;
 	next;
      }
      if ($seq =~ /AAGTCGTATGCCGTCTTCTGCTTG/){  #1
	$twcntr++;
 	next;
      }
      if ($seq =~ /AGATCGTATGCCGTCTTCTGCTTG/){   #3
	$twcntr++;
 	next;
      }
      if ($seq =~ /ACTTCGTATGCCGTCTTCTGCTTG/){  #4
	$twcntr++;
 	next;
      }
      if ($seq =~ /AACTCGTATGCCGTCTTCTGCTTG/){   #5
	$twcntr++;
 	next;
      }
      if ($seq =~ /ATATCGTATGCCGTCTTCTGCTTG/){    #6
	$twcntr++;
 	next;
      }
      if ($seq =~ /AGCTCGTATGCCGTCTTCTGCTTG/){   #7
	$twcntr++;
 	next;
      }
      if ($seq =~ /ACGTCGTATGCCGTCTTCTGCTTG/){  #8
	$twcntr++;
 	next;
      }
      if ($seq =~ /AATTCGTATGCCGTCTTCTGCTTG/){   #9
	$twcntr++;
 	next;
      }
      if ($seq =~ /TAGTCGTATGCCGTCTTCTGCTTG/){   #10
	$twcntr++;
 	next;
      }
      if ($seq =~ /TCTTCGTATGCCGTCTTCTGCTTG/){   #11
	$twcntr++;
 	next;
      }
      if ($seq =~ /TTGTCGTATGCCGTCTTCTGCTTG/){   #12
	$twcntr++;
 	next;
      }
      if ($seq =~ /TAATCGTATGCCGTCTTCTGCTTG/){   #13
	$twcntr++;
 	next;
      }
      if ($seq =~ /TGCTCGTATGCCGTCTTCTGCTTG/){   #14
	$twcntr++;
 	next;
      }
      if ($seq =~ /TCATCGTATGCCGTCTTCTGCTTG/){   #15
	$twcntr++;
 	next;
      }
      if ($seq =~ /TTCTCGTATGCCGTCTTCTGCTTG/){   #16
	$twcntr++;
 	next;
      }
      if ($seq =~ /TATTCGTATGCCGTCTTCTGCTTG/){   #17
	$twcntr++;
 	next;
      }
      if ($seq =~ /TCCTCGTATGCCGTCTTCTGCTTG/){   #18
	$twcntr++;
 	next;
      }
      if ($seq =~ /CACTCGTATGCCGTCTTCTGCTTG/){   #19
	$twcntr++;
 	next;
      }
      if ($seq =~ /CTGTCGTATGCCGTCTTCTGCTTG/){   #20
	$twcntr++;
 	next;
      }
      if ($seq =~ /CGTTCGTATGCCGTCTTCTGCTTG/){  #21
	$twcntr++;
 	next;
      }
      if ($seq =~ /CCATCGTATGCCGTCTTCTGCTTG/){   #22
	$twcntr++;
 	next;
      }
      if ($seq =~ /CCTTCGTATGCCGTCTTCTGCTTG/){    #23
	$twcntr++;
 	next;
      }
      if ($seq =~ /CGATCGTATGCCGTCTTCTGCTTG/){   #24
	$twcntr++;
 	next;
      }
      if ($seq =~ /CTCTCGTATGCCGTCTTCTGCTTG/){   #25
	$twcntr++;
 	next;
      }
      if ($seq =~ /CAGTCGTATGCCGTCTTCTGCTTG/){   #26
	$twcntr++;
 	next;
      }
      if ($seq =~ /CATTCGTATGCCGTCTTCTGCTTG/){   #27
	$twcntr++;
 	next;
      }
      if ($seq =~ /GAATCGTATGCCGTCTTCTGCTTG/){   #28
	$twcntr++;
 	next;
      }
      if ($seq =~ /GTATCGTATGCCGTCTTCTGCTTG/){   #29
	$twcntr++;
 	next;
      }
      if ($seq =~ /GCTTCGTATGCCGTCTTCTGCTTG/){   #30
	$twcntr++;
 	next;
      }
      if ($seq =~ /GGTTCGTATGCCGTCTTCTGCTTG/){   #31
	$twcntr++;
 	next;
      }
      if ($seq =~ /GAGTCGTATGCCGTCTTCTGCTTG/){   #32
	$twcntr++;
 	next;
      }
      if ($seq =~ /GTCTCGTATGCCGTCTTCTGCTTG/){   #33
	$twcntr++;
 	next;
      }
      if ($seq =~ /GCCTCGTATGCCGTCTTCTGCTTG/){  #34
	$twcntr++;
 	next;
      }
      if ($seq =~ /GGATCGTATGCCGTCTTCTGCTTG/){   #35
	$twcntr++;
 	next;
      }
      if ($seq =~ /GACTCGTATGCCGTCTTCTGCTTG/){   #36
	$twcntr++;
 	next;
      }
 	else{
 	  print OUT "$scaff\n";
 	  print OUT "$seq\n";
	   $cntr++;
    }
  }
}
  }
print "We removed $twcntr tapeworms and kept $cntr good scaffolds\n";
close (IN);
close (OUT);







