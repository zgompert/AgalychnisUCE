#!/usr/bin/perl
#
# count number of N in a nexus file
#

$nex = shift(@ARGV);

open(IN, $nex) or die "failed to read\n";

$flag = 0;

while(<IN>){
	chomp;
	if(m/^Matrix/){
		$flag = 1;
	} elsif ($flag==1 and m/^([A-Z0-9_])+\s+([A-Z]+)/){
		$id = $1;
		$str = $2;
		$count = $str =~ tr/N//;
		print "$id $count out of 49028\n";
	}
}
close(IN);

