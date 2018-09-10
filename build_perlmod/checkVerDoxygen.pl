#!/usr/bin/perl
use 5.010;
use Version;

$s = `doxygen --version`;
chop($s);
print $s;
print "\n";

$s =~ /(\S*)\s*([\d\.]+)\s*$/;
$name = $1;
$ver = $2;
print $name . "  " . $ver . "\n";

if($name eq "Charles"){
	print STDERR "Charles Version. It's OK.\n";
	exit 1;
}

if(version->parse($ver) >= version->parse(1.8.16) ){
	print STDERR "Current Version $ver >= 1.8.16  It's OK.\n";
	exit 1;
} else {
	print STDERR "Current Version $ver < 1.8.16\n";
	print STDERR "Need to install upper version than 1.8.16\n";
	exit 0;
}

#if(version->parse($ver) > version->parse(1.8.2) ){
#	print "$ver > 1.8.2\n";
#}
#if(version->parse($ver) > version->parse(1.8.14) ){
#	print "$ver > 1.8.14\n";
#}
#if(version->parse($ver) > version->parse(1.8.10) ){
#	print "$ver > 1.8.10\n";
#}
#if(version->parse($ver) > version->parse(1.8.2) ){
#	print "$ver > 1.8.2\n";
#}
#if(version->parse($ver) > version->parse(1.8.20) ){
#	print "$ver > 1.8.20\n";
#}
#if(version->parse($ver) > version->parse(1.8.02) ){
#	print "$ver > 1.8.02\n";
#}
#if(version->parse($ver) > version->parse(1.9.2) ){
#	print "$ver > 1.9.2\n";
#}
