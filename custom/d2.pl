use strict;
use warnings;

open (READ, "<L4e_r");
my %data;
while (<READ>) {
	chomp;
	my @mas = split/\t/;
	if (not(defined($data{$mas[4]}))) {
		$data{$mas[4]} = {};
		}
	if (not(defined($data{$mas[4]}->{$mas[5]}))) {
		$data{$mas[4]}->{$mas[5]} = 0;
		}
	$data{$mas[4]}->{$mas[5]} += 1;
	}
close READ;
foreach my $key (keys %data) {
	print "$key";
	foreach my $loe (qw(1 2 3A 3B 4 R1 R2)) {
		print "\t",($data{$key}->{$loe} || 0);
		}
	print "\n";
	}

