#!/usr/bin/perl
#
# get scaffold lengths
#

$fa = shift(@ARGV);
open(IN, $fa) or die "failed to read\n";
while(<IN>){
	chomp;
	if(/^>(\S+)/){
		$scaf = $1;
		$ln{$scaf} = 0;
	}
	elsif(/^[a-zA-Z]/){
			$ln{$scaf} += length($_);
	}
}

foreach $scaf (sort keys %ln){
	print "$scaf $ln{$scaf}\n";
}
