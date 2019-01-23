my $status = "NONE";
open(CH,">","./UML/__ALL_only_class__\.class");
while(<>){
	my $s = $_;
	if($status eq "NONE"){
		if($s =~ /^\s*(abstract\s*|\s*)?class\s+(\S+)\s*\{/){
			print "1:$1 2:$2\n";
			$status = "CLASS";
			$class = $2;
			open(OH,">","./UML/$class\.class");
			print OH "\n" . $s;
			print CH "\n" . $s;
		}
	} elsif($status eq "CLASS"){
		if($s =~ /^\s*\}/){
			$status = "NONE";
			print OH $s . "\n";
			print CH $s . "\n";
			close OH;
		} else {
			print OH $s;
			print CH $s;
		}
	}
}

close CH;
