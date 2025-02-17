#!/usr/bin/perl

use warnings;
use strict;

# this program filters a vcf file based on overall sequence coverage, number of non-reference reads, number of alleles, and reverse orientation reads

# usage vcfFilter.pl infile.vcf
#
# change the marked variables below to adjust settings
#

#### stringency variables, edits as desired
## 62 
my $minCoverage = 124; # minimum number of sequences; DP 2X
my $minAltRds = 1; # max likelihood alt allele count  AC
my $notFixed = 1.0; # removes loci fixed for alt; AF
my $bqrs = 3; # ManU Z of the base quality rank sum test;BQB
my $mqrs = 3; # ManU Z mapping quality rank sum test; MQB
my $rprs = 4; # ManU Z of the read position rank sum test; RPB
my $mq = 30; # minimum mapping quality; MQ
my $miss = 12; # maximum number of individuals with no data
##### this set is for whole genome shotgun data
my $d;

my @line;

my $in = shift(@ARGV);
open (IN, $in) or die "Could not read the infile = $in\n";
$in =~ m/^([0-9a-zA-Z_\-]+\.vcf)$/ or die "Failed to match the variant file\n";
open (OUT, "> filtered2x_$1") or die "Could not write the outfile\n";

my $flag = 0;
my $cnt = 0;

while (<IN>){
	chomp;
	$flag = 1;
	if (m/^\#/){ ## header row, always write
		$flag = 1;
	}
	elsif (m/^Aga/){ ## this is a sequence line, you migh need to edit this reg. expr.
		$flag = 1;
		$d = () = (m/0\/0:0,0,0/g); 
		if ($d >= $miss){
			$flag = 0;
			print "fail missing : ";
		}
		if (m/[ACTGN]\,[ACTGN]/){ ## two alternative alleles identified
			$flag = 0;
			print "fail allele : ";
		}
		@line = split(/\s+/,$_);
		if(length($line[3]) > 1 or length($line[4]) > 1){
			$flag = 0;
			print "fail INDEL : ";
		}
		m/DP=(\d+)/ or die "Syntax error, DP not found\n";
		if ($1 < $minCoverage){
			$flag = 0;
			print "fail DP : ";
		}
		m/AC1=(\d+)/ or die "Syntax error, AC not found\n";
		if ($1 < $minAltRds){
			$flag = 0;
			print "fail AC : ";
		}
		m/AF1*=([0-9\.e\-]+)/ or die "Syntax error, AF not found\n";
		if ($1 == $notFixed){
			$flag = 0;
			print "fail AF : ";
		}

		if(m/BQBZ=([0-9\-\.e]*)/){
			if (abs($1) > $bqrs){
				$flag = 0;
				print "fail BQRS : ";
			}
		}
		if(m/MQBZ=([0-9\-\.e]*)/){
			if (abs($1) > $mqrs){
				$flag = 0;
				print "fail MQRS : ";
			}
		}
		if(m/RPBZ=([0-9\-\.e]*)/){
			if (abs($1) > $rprs){
				$flag = 0;
				print "fail RPRS : ";
			}
		}
		if(m/MQ=([0-9\.]+)/){
			if ($1 < $mq){
				$flag = 0;
				print "fail MQ : ";
			}
		}
		else{
			$flag = 0;
			print "fail no MQ : ";
		}
		if ($flag == 1){
			$cnt++; ## this is a good SNV
		} else{
			print "\n";
		}
	}
	else{
		print "Warning, failed to match the chromosome or scaffold name regular expression for this line\n$_\n";
		$flag = 0;
	}
	if ($flag == 1){
		print OUT "$_\n";
	}
}
close (IN);
close (OUT);

print "Finished filtering $in\nRetained $cnt variable loci\n";
