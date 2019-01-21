#!/usr/bin/perl
use File::Copy;

copy('./build_doxygen/Doxyfile', './build_doxygen/Doxyfile.org')
  or die "Copy failed: $!";

my $plantumljar = `find . -type f -name plantuml.jar`;
print $plantumljar . "\n";
if($plantumljar eq ""){
	print STDERR "Can not find plantuml.jar\n";
	exit;
} else {
	my @lines = split /\n/, $plantumljar;
	$plantumljar = $lines[0];
	#$plantumljar =~ s/\/plantuml\.jar$//;
	#my $pwd = `pwd`;
	#chop($pwd);
	#$plantumljar = $pwd . "/" . $plantumljar;
	print "PATH : $plantumljar\n";
}

open(FH, "<","./build_doxygen/Doxyfile.org") or die "Can't open < ./build_doxygen/Doxyfile.org $!";
open(OH, ">","./build_doxygen/Doxyfile") or die "Can't open < ./build_doxygen/Doxyfile $!";
while(<FH>){
	my $s = $_;
	if($s =~ /^PLANTUML_JAR_PATH\s*\=/){
		print OH "PLANTUML_JAR_PATH		= $plantumljar\n";
	} else {
		print OH $s;
	}
}

close FH;
close OH;
