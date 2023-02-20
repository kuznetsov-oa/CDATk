use strict;
use warnings;
use List::Util qw(min max);
use Data::Dumper;

my @db = ('civic', 'oncokb', 'cgi', 'cga', 'VICC', 'MolecularMatch');
my %data;
	for (my $i = 6; $i <= 6; $i++) {
		my $total = 0;
		open (READ, "L${i}e_r");
		my $head = <READ>;
		chomp $head;
		my @mas = split/\t/, $head;
		my %header;
		for (my $l = 0; $l < scalar @mas; $l++) {
			$header{$mas[$l]} = $l;
			}
		while (<READ>) {
			chomp;
			my @mas = split/\t/;
			foreach my $key (qw(1 2 3A 3B 4 R1 R2)) {
				$data{$key} = {} unless defined $data{$key};
				$data{$key}->{countT} = 0 unless defined ($data{$key}->{countT});
				$data{$key}->{countC} = 0 unless defined ($data{$key}->{countC});
				#$data{$mas[3]}->{'total'} = 0 unless defined ($data{$mas[3]}->{total});
				#$data{$mas[3]}->{'any'} = 0 unless defined ($data{$mas[3]}->{any})
				}
			#foreach my $key (@db) {$data{$mas[4]}->{$key} += 1 if $mas[$header{$key}] eq 1}
			if (max(map {$mas[$header{$_}]} @db) eq 1) {
				unless (defined($data{$mas[5]}->{$mas[3]})) {
					$data{$mas[5]}->{$mas[3]} = 0;
					$data{$mas[5]}->{countT} += 1;
					}
				if ((defined($data{$mas[5]}->{$mas[3]}))and($data{$mas[5]}->{$mas[3]} < 1)) {
					$data{$mas[5]}->{countC} += 1;
					$data{$mas[5]}->{$mas[3]} += 1;
					}
				} else {
				unless (defined($data{$mas[5]}->{$mas[3]})) {
					$data{$mas[5]}->{$mas[3]} = 0;
					$data{$mas[5]}->{countT} += 1;
					}
				}
			}
		close READ;
		}
foreach my $key (keys %data) {
	#print "$key";
	foreach my $arg (qw(countC countT)) {#(keys %{$data{$key}}) {
		print "$key\t$arg\t",$data{$key}->{$arg},"\n";
		}
	}
