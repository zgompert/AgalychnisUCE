#!/usr/bin/perl
#
# run bwa mem in parallel
#


use Parallel::ForkManager;
my $max = 16;
my $pm = Parallel::ForkManager->new($max);

my $genome = "/uufs/chpc.utah.edu/common/home/gompert-group4/data/UCE_data/Reference/CleanUCE.fasta";

## get ids
open(IN,"ids.txt") or die "failed to read the ID file\n";
<IN>; # burn header
while(<IN>){
	chomp;
	@line = split(/\s+/,$_);
	$itab{$line[0]} = $line[1];
}
close(IN);

foreach $file1 (@ARGV){
    $pm->start and next; ## fork
    $file2 = $file1;
    $file2 =~ s/READ1/READ2/ or die "failed file sub\n";
    $file1 =~ m/^(CSN_\d+_P\d+_[A-Z0-9]+)/ or die "failed id match\n";
    $pid = $1;
    $id = $itab{$pid};

    print "Working on $pid = $id\n";    
    	
    print "bwa mem -t 1 -M -r 1.3 -k 19 -R \'\@RG\\tID:$id\\tPL:ILLUMINA\\tLB:$id\\tSM:$id\' -o $id".".sam $genome $file1 $file2\n";
    system "bwa mem -t 1 -M -r 1.3 -k 19 -R \'\@RG\\tID:$id\\tPL:ILLUMINA\\tLB:$id\\tSM:$id\' -o $id".".sam $genome $file1 $file2\n";
    $pm->finish;
}
 

$pm->wait_all_children;



