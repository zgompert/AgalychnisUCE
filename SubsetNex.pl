#!/usr/bin/perl
#
# keep every Nth character in nexus 
#

$nex = shift(@ARGV);

open(IN, $nex) or die "failed to read\n";
open(OUT, "> sub_$nex") or die "failed to write\n";


$flag = 0;

$N = 49;

while(<IN>){
	chomp;
	if(m/^Matrix/){
		$flag = 1;
		print OUT "$_\n";
	} elsif($flag==0){
		print OUT "$_\n"; ## printing header stuff
	} elsif($flag==1 and m/^([A-Z0-9_]+)\s+([A-Z]+)/){
		$id = $1;
		$str = $2;
		$str =~ s/([A-Z])[A-Z]{$N}/\1/g;
		$ln = length($str);
		print "$id length = $ln\n";
		print OUT "$id $str\n";
	}
}
print OUT ";\nEnd;\n";
close(IN);
close(OUT);
