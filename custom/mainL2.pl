use strict;
use warnings;
use Data::Dumper;
use List::Util qw(max);

my %LoE_power;
$LoE_power{1} = 10;
$LoE_power{2} = 9;
$LoE_power{'3A'} = 8;
$LoE_power{'3А'} = 8;
$LoE_power{'3B'} = 7;
$LoE_power{'3В'} = 7;
$LoE_power{'3C'} = 6;
$LoE_power{'3С'} = 6;
$LoE_power{4} = 5;
$LoE_power{5} = 1;


my %drugDic;
open (READ, "<DrugDic");

while (<READ>) {
	chomp;
	my @mas = split/\t/;
	$drugDic{$mas[0]} = $mas[1];
	}

close READ;

my %struct;
open (READ, "<ListMain");

while (<READ>) {
	chomp;
	my @mas = split/\t/;
	$struct{$mas[0]} = [] unless defined $struct{$mas[0]};
	my %row;
	$row{'gene'} = $mas[2];
	die "$mas[0] '$mas[4]'" unless defined $drugDic{$mas[4]};
	$row{'drug'} = $drugDic{$mas[4]};
	$row{'LoE'} = uc($mas[5]);
	$row{'civic'} = $mas[6];
	$row{'oncokb'} = $mas[7];
	$row{'cgi'} = $mas[8];
	$row{'cga'} = $mas[9];
	print STDERR Dumper \%row if $row{'gene'} eq 'MAPK1';
	push @{$struct{$mas[0]}}, \%row;
	}

close READ;

foreach my $patient (keys %struct) {
	my @rec;
	my %known;
	foreach my $arg (@{$struct{$patient}}) {
		my $ass = $arg->{'gene'}.'-'.$arg->{'drug'};
		next if $arg->{'LoE'} eq '1';
		next if $arg->{'LoE'} eq 'R1';
		next if $arg->{'LoE'} eq 'R2';
		next if $known{$ass};
		$known{$ass} = 1;
		push @rec, [$arg->{'gene'}, $arg->{'drug'}]
		}
	foreach my $arg (@rec){
		print STDERR "HERE" if $arg->[0] eq 'MAPK1';
		my $LoE = 5;
		my $civic = 0;
		my $oncokb = 0;
		my $cgi = 0;
		my $cga = 0;
		foreach my $el (@{$struct{$patient}}) {
			next unless $el->{'gene'} eq $arg->[0];
			next unless $el->{'drug'} eq $arg->[1];
			$civic = 1 if $el->{'civic'} eq 1;
			$cga = 1 if $el->{'cga'} eq 1;
			$cgi = 1 if $el->{'cgi'} eq 1;
			$oncokb = 1 if $el->{'oncokb'} eq 1;
			#print $el->{'LoE'},"\n";
			$LoE = $el->{'LoE'} if $LoE_power{$el->{'LoE'}} > $LoE_power{$LoE};
			}
		print "$patient\t",$arg->[0],"\t",$arg->[1],"\t";
		print "$LoE\t$civic\t$oncokb\t$cgi\t$cga\n";
		}
	}

#print Dumper \%struct;

















