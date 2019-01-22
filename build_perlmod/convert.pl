#!/usr/bin/perl
#
use 5.010;
use version;

#  DoxyDocs.pm -> other.pm
#	I will correct DoxyDocs.pm  : params => [ ...] --->  { params => [...] }, 
print "arguments count : " .  ($#ARGV +1 ). "\n";
print @ARGV . "\n";
($infile , $outfile) = (@ARGV);
if($infile eq ""){
	$infile = "../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm";
}
if($outfile eq ""){
	$outfile = "./DoxyDocs.pm";
}
print "infile : $infile , outfile : $outfile\n";
print STDERR "infile : $infile , outfile : $outfile\n";

$s = `doxygen --version`;
chop($s);
print $s;
print "\n";

if($s =~ /^\s*([\d\.]+)\s*$/){
	$ver = $1;
	$name = "";
} elsif($s =~ /(\S*)\s*([\d\.]+)\s*$/){
	$name = $1;
	$ver = $2;
}
print $name . "  " . $ver . "\n";

if($name eq "Charles"){
	print STDERR "---------------------------------------------\n";
	print STDERR "Charles Version. It's OK.\n";
	print STDERR "Reuse with original DoxyDocs.pm\n";
	print STDERR "cp -f  $infile $outfile\n";
	print STDERR "---------------------------------------------\n";
	`cp -f  $infile $outfile`;
	exit 0;
}

if(version->parse($ver) > version->parse(1.8.14) ){
	print STDERR "---------------------------------------------\n";
	print STDERR "Current Version $ver > 1.8.14  It's OK.\n";
	print STDERR "Reuse with original DoxyDocs.pm\n";
	print STDERR "cp -f  $infile $outfile\n";
	print STDERR "---------------------------------------------\n";
	`cp -f  $infile $outfile`;
	exit 0;
}

print STDERR "\n";
print STDERR "======================================================\n";
print STDERR " Current Version $ver <= 1.8.14\n";
print STDERR " Run convet.pl to modify DoxyDocs.pm (add braces).\n";
print STDERR "======================================================\n";
print STDERR "\n";


print "in : $infile  , outfile : $outfile\n";
print STDERR "in : $infile  , outfile : $outfile\n";
open(IH, "<",$infile) or die "Can't open < $infile $!";
open(OH, ">",$outfile) or die "Can't open < $outfile $!";
my $status = "NONE";
my $space = "";
my $olds;
while(<IH>){
	my $s = $_;
	if($status eq "NONE"){
		if(   ($s =~ /^(\s+)params =>/)
		   || ($s =~ /^(\s+)retvals =>/) ){
			$space = $1;
			$status = "PARAMS";
			print OH $space . "{\n";
			print OH $s;
			print $space . "{\n" . $s;
		} else {
			print OH $s;
		}
	} elsif($status eq "PARAMS"){
		if($s =~ /^$space\]/){
			$status = "NONE";
			print OH $s;
			print OH $space . "},\n";
			print $s . $space . "},\n";
		} else {
			print OH $s;
		}
	}
	$olds = $s;
}

close IH;
close OH;

