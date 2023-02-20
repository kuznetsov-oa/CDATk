use strict;
use warnings;
use List::Util qw(max);

my $input = $ARGV[0];

sub pp {
	my $data = shift;
	my $key = shift;
	print "$key";
	foreach my $loe (qw(1 2 3A 3B 4 R1)) {
		print "\t",($data->{$key}->{$loe} || 0);
		}
	print "\n";
	}
sub grade {
	my $base = shift;
	my $grade = shift;
	my $result = $base;
	for (my $i = 1; $i <= $grade; $i++) {
		$result = $result * $base;
		}
	return $result;
	}

open (READ, "$input");
my $data;
while (<READ>) {
	chomp;
	my @mas = split/\t/;
	#print "$mas[0]\n";next;
	$data->{$mas[0]} = {} unless defined ($data->{$mas[0]});
	$data->{$mas[0]}->{$mas[1]} = 0 unless defined($data->{$mas[0]}->{$mas[1]});
	$data->{$mas[0]}->{$mas[1]} += 1;
	#print "$mas[0]\t$mas[1]\n";
	}
close READ;#exit;
my %printed;
my %color;
$color{'1'} = "#30A248";
$color{'2'} = "#1679B6";
$color{'3A'} = "#984E9E";
$color{'3B'} = "#BB97C5";
$color{'4'} = "#434343";
$color{'R'} = "#FF706B";
print '"weight";"word";"color";"url"';print "\n";
foreach my $key (keys %{$data}) {
	next if (defined($printed{$key}));
	#pp($data, $key);next;
	my $loe;
	if (($data->{$key}->{'1'} || 0) >= max(map{($data->{$key}->{$_} || 0)} qw(1 2 3A 3B 4 R1))) {
		$loe = 1;#print "1\n";
		} elsif (($data->{$key}->{'2'} || 0) >= max(map{($data->{$key}->{$_} || 0)} qw(1 2 3A 3B 4 R1))) {
		$loe = 2;#print "2\n";
		} elsif (($data->{$key}->{'3A'} || 0) >= max(map{($data->{$key}->{$_} || 0)} qw(1 2 3A 3B 4 R1))) {
		$loe = '3A';#print "3A\n";
		} elsif (($data->{$key}->{'3B'} || 0) >= max(map{($data->{$key}->{$_} || 0)} qw(1 2 3A 3B 4 R1))) {
		$loe = '3B';#print "3B\n"
		} elsif (($data->{$key}->{'4'} || 0) >= max(map{($data->{$key}->{$_} || 0)} qw(1 2 3A 3B 4 R1))) {
		$loe = '4';#print "4\n";
		} else {
		$loe = 'R';#print "R1\n";
		}
	my $count = 0;
	open (READ, "<$input");
	while (<READ>) {chomp; my @mas = split/\t/; ++$count if $mas[0] eq $key}
	close READ;
	print "\"",(int(log((grade($count,14)))/log(10))+6),"\";\"$key\";\"$color{$loe}\";\"\"\n";
	$printed{$key} = 1;
	}









