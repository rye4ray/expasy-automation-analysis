#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::UserAgent;
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

print("***************************************************************\n");
print("*           Welcome to Expasy Automation Analysis!            *\n");
print("***************************************************************\n");

my $prefix=$ARGV[0];

my @fs=glob("${prefix}*.seq"); # Read all sequence files with the prefix. Filename formats can be modified.

my $f;

my $list = '';

foreach $f (@fs) 
{
	open(my $fh, '<:encoding(UTF-8)', $f)
		or die "Could not open file '$f' $!";
	my $seq = '';
	chomp $seq;
	while (my $row = <$fh>) {
  		$seq = $seq . $row;
	}
	# Connect to the Expasy web server
	my $browser  = LWP::UserAgent->new;
	my $dna_sequence = $seq;
	my $response = $browser->post(
		'https://web.expasy.org/cgi-bin/translate/dna2aa.cgi',
		[
			'dna_sequence'    => $dna_sequence,  
			'output_format'   => 'fasta'
		]
	);
	my $s =  ( $response->content );
	my $s1 = $ARGV[1]; # Protein sequence of interest at the N-terminus
	my $s2 = $ARGV[2]; # Protein sequence of interest at the C-terminus
	my $p1 = index($s,$s1);
	my $p2 = index($s,$s2);
	# Copy the original sequence file to a new filename
	my $f2 = substr($f,-7); 
	system("cp $f $f2"); # Change "cp" to "copy" in the Windows version
	print ("$f2\n");

	my $l = $p2 - $p1 + length($s2); # Determine the length of the sequence of interest
	my $ss = substr($s,$p1,$l); # Extract the sequence of interest
	$ss =~ s/[\n\r]//g; # Remove newline characters
	open(my $fh2, '>>', $f2) or die $!;
	my $ff = $f2;
	substr($ff,-3) = 'ab1'; # Input appropriate extension
	if (($p1 != -1) and ($p2 != -1)){
		print(qq\The sub-sequence "$s1" found at position "$p1"\,"\n");
		print(qq\The sub-sequence "$s2" found at position "$p2"\,"\n");
		print "$ss\n";
		print $fh2 "\n>$ff\n$ss\n"; # Apprehend the sequence to the copy
		$list = $list . "\n>$ff\n$ss\n"; # Save the found sequence for the list
	} else {
		print "The appropriate sequence is NOT found!\n";
		print $fh2 "\n>$ff\nThe appropriate sequence is NOT found!\n";
	}
	
	my $f3 = $f2;
	substr($f3,-3) = 'out';
	open(my $fh3, '>', $f3) or die $!;
	print $fh3 $s; # Print Expasy translation output to files, e.g., B10.out

}

my $f4 = 'list.txt';
open(my $fh4,'>',$f4) or die $!;
print $fh4 $list; # Apprehend the found sequence to the list