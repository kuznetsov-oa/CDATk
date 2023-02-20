use strict;
use warnings;
use Data::Dumper;
use List::Util qw(max);

my %LoE_power;
$LoE_power{1} = 11;
$LoE_power{'R1'} = 10;
$LoE_power{2} = 9;
$LoE_power{'3A'} = 8;
$LoE_power{'3А'} = 8;
$LoE_power{'3B'} = 7;
$LoE_power{'3В'} = 7;
$LoE_power{'3C'} = 6;
$LoE_power{'3С'} = 6;
$LoE_power{4} = 5;
$LoE_power{'R2'} = 4;
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
	die "$mas[0] '$mas[5]'" unless defined $drugDic{$mas[5]};
	$row{'drug'} = $drugDic{$mas[5]};
	$row{'disease'} = $mas[1];
	$row{'type'} = $mas[4];
	$row{'LoE'} = uc($mas[6]);
	push @{$struct{$mas[0]}}, \%row;
	}

close READ;

foreach my $patient (keys %struct) {
	my @rec;
	my %known;
	foreach my $arg (@{$struct{$patient}}) {
		my $ass = $arg->{'gene'}.'-'.$arg->{'type'}.'-'.$arg->{'drug'}.'-'.$arg->{'disease'};
#		next if $arg->{'LoE'} eq '1';
#		next if $arg->{'LoE'} eq 'R1';
#		next if $arg->{'LoE'} eq 'R2';
		next if $known{$ass};
		$known{$ass} = 1;
		push @rec, [$arg->{'gene'}, $arg->{'type'}, $arg->{'drug'}, $arg->{'disease'}];
		}
	foreach my $arg (@rec){
		my $LoE = 5;
		foreach my $el (@{$struct{$patient}}) {
			next unless $el->{'gene'} eq $arg->[0];
			next unless $el->{'type'} eq $arg->[1];
			next unless $el->{'drug'} eq $arg->[2];
			next unless $el->{'disease'} eq $arg->[3];
			#print $el->{'LoE'},"\n";
			$LoE = $el->{'LoE'} if $LoE_power{$el->{'LoE'}} > $LoE_power{$LoE};
			}
		print "$patient,",$arg->[0],",",$arg->[1],",",$arg->[2],",",$arg->[3],",$LoE\n";
		#print "$LoE\t$civic\t$oncokb\t$cgi\t$cga\n";
		}
	}

#print Dumper \%struct;

















