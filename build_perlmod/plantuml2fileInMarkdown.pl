#  DoxyDocs.pm -> other.pm
#	I will correct DoxyDocs.pm  : params => [ ...] --->  { params => [...] }, 
print "arguments count : " . ($#ARGV +1) . "\n";
print @ARGV . "\n";
($infile , $outfile) = (@ARGV);
if($infile eq ""){
	$infile = "README.plantuml.md";
}
if($outfile eq ""){
	$outfile = "README.md";
}
if($infile eq $outfile){
	print "The same name : $infile\n";
	exit;
}
print "infile : $infile , outfile : $outfile\n";
print STDERR "infile : $infile , outfile : $outfile\n";
print "The generated plantuml files are in ./outplantuml directory.\n";
print STDERR "The generated plantuml files are in ./outplantuml directory.\n";

open(IH, "<",$infile) or die "Can't open < $infile $!";
open(OH, ">",$outfile) or die "Can't open < $outfile $!";
my $status = "NONE";
my $space = "";
my $cnt = 1;
while(<IH>){
	my $s = $_;
	if($status eq "NONE"){
		if($s =~ /^\s*```\s*puml\s+(.*)$/){
			my $mymatch = $1;
			my $f = "";
			my $desc = "";
			my $depth = 0;
			print "1[$mymatch]\n";
			if( $mymatch =~ /^(\s*[^\s:]*)\s*:\s*(.*)$/){
				$f = $1;
				$mymatch = $2;
				print "2[$mymatch]\n";
				if($mymatch =~ /\[\s*(\d+)\s*\]\s*(.*)$/){
					$depth = $1;
					$desc = $2;
				} else {
					$desc = $mymatch;
				}
			} else {
				$f = $mymatch;
			}
			my $mytab= "";
			for(my $i=0;$i<$depth;$i++){
				$mytab .= "\t";
			}
			$desc =~ s/^\s*//;
			$desc =~ s/\s*$//;
			$f =~ s/^\s*//;
			$f =~ s/\s*$//;
			print "==== $s desc[$desc] f[$f] depth[$depth]\n";
			$f =~ s/\.plantuml$//;
			$filename = "$outfile\_$cnt\_$f";
			$filename =~ s/\./_/g;
			$filename =~ s/\:/_/g;
			print "[out:$filename] [f:$f] [cnt:$cnt]\n";
			$cnt++;
			$outplantuml = "../outplantuml/" . "$filename\.plantuml";
			$outpng = "$filename\.png";
			$status = "PLANTUML";
			print STDERR "Generated output file .plantuml : $outplantuml  depth($depth)  desc($desc)\n";
			print STDERR "Generated output file .png : $outpng\n";
			open(PH, ">",$outplantuml) or die "Can't open < $outplantuml $!";
			print PH "\@startuml $outpng\n";
			if($desc ne ""){
				print OH "$mytab\- [Figure] $desc\n";
			}
			print OH "\n![alt PLANTUML $outfile $cnt $f]\(./outplantuml/$outpng\)\n\n";
		} else {
			print OH $s;
		}
	} elsif($status eq "PLANTUML"){
		if($s =~ /^\s*```/){
			$status = "NONE";
			print PH "\@enduml\n";
			close PH;
		} else {
			print PH $s;
		}
	}
}

close IH;
close OH;

