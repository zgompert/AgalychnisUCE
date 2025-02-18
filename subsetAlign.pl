#!/usr/bin/perl
#

## drop samples with uncertain IDs
$drop{'DROP_ACA_CA_0044'} = 1;  
$drop{'DROP_ACA_CA_0039'} = 1;
$drop{'ASA_LS_0313XX'} = 1;

## now subset alignment
open(IN, "filtered2x_frogs_uce.fa");
open(OUT, "> beast_frogs_uce.fa") or die;
$flag = 0;
while(<IN>){
	chomp;
	if(m/^>(\S+)/){
		$id = $1;
		if($drop{$id}==1){
			$flag = 0;
		}
		else{
			$flag = 1;
			print OUT "$_\n";
		}
	}
	elsif($flag == 1){
		print OUT "$_\n";
	}
}
close(IN);
close(OUT);
