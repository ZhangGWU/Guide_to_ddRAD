
#!/usr/bin/perl
#
# manage barcode parsing 
#


use Parallel::ForkManager;
my $max = 48;
my $pm = Parallel::ForkManager->new($max);

FILES:
foreach $fq (@ARGV){
	$pm->start and next FILES; ## fork
	$bc = "lyc_barcodeKey_L1.csv";
	print "Parsing $fq -- $lane with $bc\n";
	system "perl /uufs/chpc.utah.edu/common/home/gompert-group3/data/lycaeides_chc_experiment/fastq/parsed/parse_barcodesFish.pl $bc $fq\n"; 
        $pm->finish;
}

$pm->wait_all_children;
