#!/usr/bin/perl

#$PNGurl =  "http://collab.lge.com/main/download/attachments/874958928/";
$PNGurl =  "http://collab.lge.com/main/download/attachments/876520840/";

($infile , $outfile) = (@ARGV);
if($infile eq ""){
	print STDERR "change 2 things.\n";
	print STDERR "<img src=\"./PNG/Architecture.png\" -> $PNGurl/Architecture.png\n";
	print STDERR "(./PNG/Architecture.png) -> $PNGurl/Architecture.png\n";
	print STDERR "perl collab.pl  inputfilename outputfilename\n";
	exit;
}
if($outfile eq ""){
	$outfile = $infile;
	$outfile =~ s/^(.*)\.([^\.]+)$/$1\.collab\.$2/;
}

print STDERR "infile = $infile , outfile = $outfile\n";

open(FH, "<","$infile") or die "Can't open < $infile $!";
open(OH, ">","$outfile") or die "Can't open < $outfile $!";
while(<FH>){
	my $s = $_;
	if($s =~ s/\"\s*\.\/PNG\/(\S+)\.png\s*\"/\"$PNGurl$1\.png\"/g){
		print OH $s;
	} elsif($s =~ s/\(\s*\.\/PNG\/(\S+)\.png\s*\)/($PNGurl$1\.png)/g){
		print OH $s;
	} elsif($s =~ s/\"\s*\.\/outplantuml\/(\S+)\.png\s*\"/\"$PNGurl$1\.png\"/g){
		print OH $s;
	} elsif($s =~ s/\(\s*\.\/outplantuml\/(\S+)\.png\s*\)/($PNGurl$1\.png)/g){
		print OH $s;
	} elsif($s =~ s/\"\s*\.\/telltaleimages\/(\S+)\.png\s*\"/\"$PNGurl$1\.png\"/g){
		print OH $s;
	} elsif($s =~ s/\(\s*\.\/telltaleimages\/(\S+)\.png\s*\)/($PNGurl$1\.png)/g){
		print OH $s;
	} else {
		print OH $s;
	}
}

close FH;
close OH;
