our $returnp = "ReTuRnp";
our $UMLINCLUDE = "UML";
our %CS;
our %CFSD;
our %SC;
our %SCF;

sub change_special_code
{
	my ($s) = @_;
	$s =~ s/\{/#\+#\+#\+\+###/g;
	$s =~ s/\}/#\-#\-#\-\-###/g;
	$s =~ s/\\/#\=#\=#\=\=###/g;
	$s =~ s/\n/#\%#\%#\%\%###/g;
	$s =~ s/\"/#\&#\&#\&\&###/g;
	return $s;
}

sub recover_special_code
{
	my ($s) = @_;
	$s =~ s/#\+#\+#\+\+###/\{/g;
	$s =~ s/#\-#\-#\-\-###/\}/g;
	$s =~ s/#\=#\=#\=\=###/\\/g;
	$s =~ s/#\%#\%#\%\%###/\n/g;
	$s =~ s/#\&#\&#\&\&###/\"/g;
	return $s;
}

sub generate_cc($$)
{
	my $str = $_[0];
	my $doc = $_[1];
	my $cnt = 1;
	#print "generate_cc $doc\n";
	if($doc =~ /^HASH\(/){
		#print "TT " . %{$doc} . "\n";
		foreach $key (keys %{$doc}) {
			if( not ( (${$doc}{$key} =~ /^ARRAY\(/) || (${$doc}{$key} =~ /^HASH\(/) ) ){
				#print FH "$str { $key } = value( ${$doc}{$key} )\n";
				print FH "$str { $key } =  \"" . change_special_code(${$doc}{$key}) . "\"\n";
			}
			generate_cc("$str { $key }",  ${$doc}{$key});
		}
	} elsif($doc =~ /^ARRAY\(/){
		#print "@$doc\n";
		foreach $key (@{$doc}) {
			#print "array key( $key ) value( $key )\n";
			generate_cc("$str { $cnt }",$key);
			$cnt ++;
		}
	} else {
		#print "Nothing\n";
	}
}


sub printdox
{
	# $depth is the count of tabs in starting line.
	my ($depth, $p , @p) = @_;

	if($p =~ /^\s*-\s*$/){ return; }

	my $mytab = "";
	for(my $i=0;$i<$depth;$i++){
		$mytab .= "\t";
	}
	if($p eq "plantuml"){
		my ($name , @pp) = @p;
		print "$mytab" . "$p";
		print "\n";
		print "$mytab" . "$name";
		print "\n";
		print "$mytab" . "@pp";
		print "\n";

		print OH1 "$mytab" . "- " . $name . "\n";
		print OH1 "```puml\n";
		print OH1 "@pp";
		print OH1 "\n";
		print OH1 "```\n";

		$name =~ s/\s//g;
		$name =~ s/\:/_/g;
		$name =~ s/\./_/g;
		open(LO,">", "./outplantuml/" . $name . "\.plantuml") or die "Can't open > $name $!";
		print LO "\n\@startuml " . $name . "\.png\n";
		print LO @pp;
		print LO "\n\@enduml\n";
		close LO;
		print OH2 "$mytab" . "- " . $name . "\n";
		#print OH2 "\n$mytab\![alt " . "./outplantuml/" . $name . "\.png](" . "./outplantuml/" . $name . "\.png)\n";
		print OH2 "![alt " . "./outplantuml/" . $name . "\.png](" . "./outplantuml/" . $name . "\.png)\n";
		print OH2 "\n";
	} else {
		print "$mytab" . "$p";
		print "\n";
		print "$mytab" . "@p";
		print "\n";
		print OH1 "$mytab" . "$p@p";
		print OH1 "\n";
		print OH2 "$mytab" . "$p@p";
		print OH2 "\n";
	}
}

sub sort_keys
{
	my $myhash = shift;
	my $direction = shift;
	my $allDigit = 1;
	foreach my $tmpKey (keys %{$myhash}){
		if( not ($tmpKey =~ /^\s*\d+\s*$/)){
			$allDigit = 0;
			last;
		}
	}
	if($allDigit == 1){
		if($direction eq "~"){
			return reverse sort {$a <=> $b} keys %{$myhash};
		} else {
			return sort {$a <=> $b} keys %{$myhash};
		}
	} else {
		if($direction eq "~"){
			return reverse sort keys %{$myhash};
		} else {
			return sort keys %{$myhash};
		}
	}
}

sub getDetails
{
	my $depth = shift;
	my $myhash = shift;
	my $mystr = "";
	my $myline = "";
	my $mytab = "";
	for(my $i=0;$i<$depth;$i++){
		$mytab .= "\t";
	}

	$myline = "- ";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		print "getDetails key [" . $tmpKey . " ::: \n";
		print "getDetails type [" . $myhash->{$tmpKey}{type} . "]\n";
		print "getDetails content [" . $myhash->{$tmpKey}{content} . "]\n";
		print "getDetails myline [" . $myline . "]\n";
		print "getDetails mystr [" . $mystr . "]\n";
		if(  ($myhash->{$tmpKey}{type} eq "url")
		  || ($myhash->{$tmpKey}{type} eq "text") ){
			$myline .= $myhash->{$tmpKey}{content};
		}
		if( ($myhash->{$tmpKey}{type} eq "parbreak")
		 || ($myhash->{$tmpKey}{type} eq "linebreak") ){
			if(not ($myline =~ /^-\s*$/) ){
				$mystr .= "$mytab" . "$myline\n";
			}
			$myline = "- ";
		}
	}

	if(not ($myline =~ /^-\s*$/) ){
		$mystr .= "$mytab" . "$myline\n";
	}

	print "getDetails return mystr " . $mystr . "]\n";
	return $mystr;
}

sub getContent
{
	my $myhash = shift;
	my $mystr = "";
	my $myline = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		#print $tmpKey . " ::: ";
		#print $myhash->{$tmpKey}{type} . "\n";
		if(  ($myhash->{$tmpKey}{type} eq "url")
		  || ($myhash->{$tmpKey}{type} eq "text") ){
			$myline .= $myhash->{$tmpKey}{content};
		}
		if( ($myhash->{$tmpKey}{type} eq "parbreak")
		 || ($myhash->{$tmpKey}{type} eq "linebreak") ){
			if(not ($myline =~ /^\s*$/) ){
				if($mystr =~ /^\s*$/){
					$mystr = $myline;
				} else {
					$mystr .= "$returnp" . "$myline"; 
				}
			}
			$myline = "";
		}
	}

	if(not ($myline =~ /^\s*$/) ){
		$mystr .= "$myline";
	}

	print "getContent return mystr " . $mystr . "]\n";
	return $mystr;
}

sub getPlantuml
{
	my $myhash = shift;
	my $mystr = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		#print $tmpKey . " ::: ";
		#print $myhash->{$tmpKey}{type} . "\n";
		if(  ($myhash->{$tmpKey}{type} eq "plantuml") ){
			$mystr .= $myhash->{$tmpKey}{content};
		}
	}
	return $mystr;
}

sub getParams
{
	my $myhash = shift;
	my $myin = "";
	my $myout = "";
	my $myany = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		print "getParams " . $tmpKey . " ::: ";
		print $myhash->{$tmpKey}{params} . "\n";
		if($myhash->{$tmpKey}{params} ne ""){
			foreach my $tmp2 (sort_keys(\%{$myhash->{$tmpKey}{params}})){
				if($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} ne ""){
					if($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq "in"){
						$myin .= "<b>[in] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "</b>";
						print "myin $myin\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myin .= " : " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>$returnp";
								print "myin2 $myin\n";
							}
						}
					}
					elsif($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq "out"){
						$myout .= "<b>[out] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "</b>";
						print "myout $myout\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myout .= " : " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>$returnp";
								print "myout2 $myout\n";
							}
						}
					}
					elsif($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq ""){
						$myany .= "<b>[-] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "</b>";
						print "myany $myany\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myany .= " : " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>$returnp";
								print "myany $myany\n";
							}
						}
					}
				}

			}
		}
	}
	return ($myin,$myout,$myany);
}

sub getRetvals
{
	my $myhash = shift;
	my $mystr = "";
	my $myout = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		print $tmpKey . " ::: ";
		print $myhash->{$tmpKey}{retvals} . "\n";
		if($myhash->{$tmpKey}{retvals} ne ""){
			foreach my $tmp2 (sort_keys(\%{$myhash->{$tmpKey}{retvals}})){
				$mystr .= "<br><b>" . $myhash->{$tmpKey}{retvals}{$tmp2}{parameters}{1}{name} . "</b> ";
				foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{retvals}{$tmp2}{doc}})){
					if("" ne $myhash->{$tmpKey}{retvals}{$tmp2}{doc}{$tmp3}{content}){
						$mystr .= "  " . $myhash->{$tmpKey}{retvals}{$tmp2}{doc}{$tmp3}{content};
					}
				}
			}
		}
	}
	return $mystr;
}

sub getReturn
{
	my $myhash = shift;
	my $mystr = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		#print $tmpKey . " ::: ";
		#print $myhash->{$tmpKey}{params} . "\n";
		if($myhash->{$tmpKey}{return} ne ""){
			$mystr .= $myhash->{$tmpKey}{return}{1}{content};
		}
	}
	return $mystr;
}

sub getParameters
{
	my $myhash = shift;
	my $mystr = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		print "getParameters " . $tmpKey . " ::: ";
		print "getParameters type [" . $myhash->{$tmpKey}{type} . "]\n";
		print "getParameters declaration_name [" . $myhash->{$tmpKey}{declaration_name} . "]\n";
		print "getParameters mystr [" . $mystr . "]\n";
		$mystr .= $myhash->{$tmpKey}{type};
		$mystr .= "    " . $myhash->{$tmpKey}{declaration_name};
		$mystr .= "<br>$returnp";
	}
	return $mystr;
}

sub getFindPageType
{
	my $mycontent = shift;
	my @mycontent = split(/<!!>/,$mycontent);
	my %mycnt;
	my %mytype;
	foreach my $item (@mycontent){
		$item =~ s/^\s*//;
		$item =~ s/\s*$//;
		foreach my $name (keys %gPages){
			foreach my $doc (keys %{$gPages{$name}{content}}){
				print "getFindPageType [$item] $name $doc  : [$gPages{$name}{content}{$doc}] \n";
				if($gPages{$name}{content}{$doc} =~ /$item/){
					print "===> getFindPageType $item $name $doc  : $gPages{$name}{content}{$doc} \n";
					$mycnt{$name}++;
					$mytype{$mycnt{$name}} = $name;
				}
			}
		}
	}
	foreach my $key (reverse sort_keys(\%mytype)){
		print ">>>>> getFindPageType return : $key $mytype{$key}\n";
		return $mytype{$key};
	}

	print ">>>>> getFindPageType return : NULL\n";
	return "";
}

sub getXrefitem
{
	my $type = shift;
	my $myhash = shift;
	my $mystr = "";
	foreach my $doc (sort_keys(\%{$myhash})){
		#print $tmpKey . " ::: ";
		#print $myhash->{$tmpKey}{params} . "\n";
		if($myhash->{$doc}{type} ne "xrefitem"){ next; }

		my $mycontent = "";
		foreach my $content (sort_keys(\%{$myhash->{$doc}{content}})){
			if($myhash->{$doc}{content}{$content}{type} eq "parbreak"){
				$mycontent .= "<!!>";
			} elsif($myhash->{$doc}{content}{$content}{type} eq "linebreak"){
				$mycontent .= "<br>";
			} else {
				$mycontent .= $myhash->{$doc}{content}{$content}{content};
			}
		}
		print "getXrefitem mycontent : $mycontent \n";
		if($type eq getFindPageType($mycontent)){
			$mystr .= "<!!>" . $mycontent;
		}
		print "getXrefitem str : $mystr \n";
	}
	return $mystr;
}

sub putXrefitem
{
	# $depth is the count of tabs in starting line.
	my $depth = shift;
	my $type = shift;
	my $hash = shift;
	my @str = split(/<!!>/, getXrefitem($type,$hash));
	my $flag = 0;
	for my $item (@str){
		if($item eq ""){ next; }
		$flag = 1;
	}
	if($flag == 1){
		printdox(0,"");
		printdox($depth,"- <b>$type</b>" );
		for my $item (@str){
			if($item eq ""){ next; }
			printdox( $depth + 1,"- $type : $item" );
		}
	} else {
		printdox(0,"" );
	}
}

sub getMethodsRow
{
	my $myaccessibility = shift;
	my $myhash = shift;
	my $mystr = "";
	my $myin;
	my $myout;
	my $myany;

	$mystr .= "| " . $myaccessibility;
	$mystr .= "| " . $myhash->{name};
	$mystr .= " | <b>" . recover_special_code( getContent(\%{$myhash->{brief}{doc}}) ) . "</b>";
	#$mystr .= " <br>" . getContent(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . recover_special_code( getParameters(\%{$myhash->{parameters}}) );
	($myin , $myout , $myany) = getParams(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . $myin . $myany;
	$mystr .= " | " . $myout;
	$mystr .= " | " . $myhash->{type};  # return type of function
	$mystr .= " | " . recover_special_code( getReturn(\%{$myhash->{detailed}{doc}}) ) . " <br>" . recover_special_code( getRetvals(\%{$myhash->{detailed}{doc}}) );
	return $mystr;
}

sub getMembersRow
{
	my $myaccessibility = shift;
	my $myhash = shift;
	my $mystr = "";
	my $myin;
	my $myout;

	$mystr .= "| " . $myaccessibility;
	$mystr .= "| " . $myhash->{type};
	$mystr .= "| " . $myhash->{name};
	$mystr .= " | <b>" . recover_special_code( getContent(\%{$myhash->{brief}{doc}}) ) . "</b>";
	$mystr .= " <br>" . recover_special_code( getContent(\%{$myhash->{detailed}{doc}}) );
	return $mystr;
}

sub getSee
{
	my $myhash = shift;    # \%{$D{classes}{$classes}{$accesstype}{members}{$members}{detailed}{doc}}
	my %mydesc;
	my $mystr = "";
	foreach my $tmpKey (sort_keys(\%{$myhash})){
		#print $tmpKey . " ::: ";
		#print $myhash->{$tmpKey}{params} . "\n";
		print "getSee $tmpKey\n";
		if($myhash->{$tmpKey}{see} ne ""){
			foreach my $i (sort_keys(\%{$myhash->{$tmpKey}{see}})){
				print "getSee see $tmpKey $i\n";
				print "SSS $myhash->{$tmpKey}{see}{$i}{type} \n";
				if(  ($myhash->{$tmpKey}{see}{$i}{type} eq "url")
					|| ($myhash->{$tmpKey}{see}{$i}{type} eq "text") ){
					print "getSee see $tmpKey $i $myhash->{$tmpKey}{see}{$i}{content} \n";
					if($myhash->{$tmpKey}{see}{$i}{content} =~ /^SRS\s+([a-zA-Z0-9\-\_]+)\s*(.*)$/){
						my $myS = $1;
						my $myD = $2;
						$mydesc{$myS} = $myD;
						print "getSee see TTT $myS = $myD\n";
					}
				}
				if( ($myhash->{$tmpKey}{see}{$i}{type} eq "parbreak")
					|| ($myhash->{$tmpKey}{see}{$i}{type} eq "linebreak") ){
					# do something for the future
				}
			}
		}
	}

	print %mydesc . "[[[[getSee\n";
	return %mydesc;
}

sub getBrief
{
	my $myhash = shift;    # \%{$D{classes}{$classes}{$accesstype}{members}{$members}
	my $myret = "";
	foreach my $i (sort_keys(\%{$myhash->{brief}{doc}})){
		print "getBrief brief $i\n";
		print "getBrief type $myhash->{brief}{doc}{$i}{type} \n";
		if(  ($myhash->{brief}{doc}{$i}{type} eq "url")
			|| ($myhash->{brief}{doc}{$i}{type} eq "text") ){
			print "getBrief brief $i $myhash->{brief}{doc}{$i}{content} \n";
			$myret .= " " . $myhash->{brief}{doc}{$i}{content};
		}
		if( ($myhash->{brief}{doc}{$i}{type} eq "parbreak")
			|| ($myhash->{brief}{doc}{$i}{type} eq "linebreak") ){
			# do something for the future
		}
	}

	print "getBrief return $myret\n";
	return $myret;
}

sub getSRS
{
	my $myhash = shift;  # \%{$D{classes}{$classes}{$accesstype}{members}{$members}}
	my %mydesc;
	my @mysrs;
	my $myfunc;
	my $mybrief;

	$mybrief = getBrief($myhash);

	$myfunc = $myhash->{name};
	print "getSRS F:$myfunc B:$mybrief\n";

	%mydesc = getSee(\%{$myhash->{detailed}{doc}});
	print %mydesc . "]]]]\n";
	foreach my $i (sort_keys(\%mydesc)){
		print "getSRS description $i => $mydesc{$i}\n";
	}
	return ($myfunc, $mybrief,%mydesc);
}

print "arguments count : " . ($#ARGV +1) . "\n";
print @ARGV . "\n";
($infile , $outfile) = (@ARGV);
if($infile eq ""){
	$infile = "default.GV";
}
if($outfile eq ""){
	$outfile = "out.md";
	$outwithimage = "out.plantuml.md";
} else {
	if( not ($outfile =~ /\.md$/) ){
		print STDERR "2nd argument (file name) has .md extention.\n";
		exit ;
	}
	$outwithimage = $outfile;
	$outfile =~ s/\.md$/.plantuml.md/;
}
print "in : $infile  , out md file : $outwithimage , out md file with plantuml : $outfile\n";
print STDERR "in : $infile  , out md file : $outwithimage , out md file with plantuml : $outfile\n";

open(FH, "<",$infile) or die "Can't open < $infile $!";
#my $lcnt = 0 ;
while(<FH>){
	$s = $s_org = $_;
	chop($s);
	eval $s;
	#$s =~ /^\$([^\{]+)/;
	#$hashName{$1} = "Done";
	#if($1 eq "gCan"){ print "== $s\n"; }
	#recover_hash_value(\%{$vname},$s);
	#LOG1 print $s_org;
	#if($lcnt >50){ last; }
	#$lcnt++;
}
close(FH);

# get information from pages =>
our %gPages;
foreach my $pages (sort_keys(\%{$D{pages}})){
	if($D{pages}{$pages}{name} =~ /^autotoc_md/){ next; }
	if($D{pages}{$pages}{name} =~ /^todo$/){ next; }

	my $name = $D{pages}{$pages}{name};
	my $title = $D{pages}{$pages}{title4};
	$gPages{$name}{title} = $D{pages}{$pages}{title4};
	my $mystr = "";
	foreach my $doc (sort_keys(\%{$D{pages}{$pages}{detailed}{doc}})){
		#print "$name content $doc : " . $D{pages}{$pages}{detailed}{doc}{$doc}{content} . "\n";
		if($D{pages}{$pages}{detailed}{doc}{$doc}{type} eq "parbreak"){
			$mystr .= "<!!>";  next;
		} elsif($D{pages}{$pages}{detailed}{doc}{$doc}{type} eq "linebreak"){
			$mystr .= "<br>";  next;
		}
		if( not(
			($D{pages}{$pages}{detailed}{doc}{$doc}{content} =~ /^HASH\(/)
			|| ($D{pages}{$pages}{detailed}{doc}{$doc}{content} =~ /^ARRAY\(/)
			|| ($D{pages}{$pages}{detailed}{doc}{$doc}{content} eq  "")
		) ){
			$mystr .= $D{pages}{$pages}{detailed}{doc}{$doc}{content};
		} else {
			$mystr .= "<!!>";
		}
	}
	print "$pages : $name : $mystr \n";
	my @mycontent = split(/<!!>/,$mystr);
	my $mycnt = 1;;
	foreach my $item (@mycontent){
		$item =~ s/^\s*//;
		$item =~ s/\s*$//;
		if($item eq ""){ next; }
		$gPages{$name}{content}{$mycnt} = $item;
		print "==> $name content $mycnt : " . "[$item]" . "\n";
		$mycnt++;
	}
}

open(OH1,">",$outfile) or die "Can't open > $outfile $!";
open(OH2,">",$outwithimage) or die "Can't open > $outwithimage $!";

printdox(0,"# Class Lists");
printdox(0,"| Class | Class ID | Description |");
printdox(0,"|-------|----------|-------------|");
foreach my $classes (sort_keys(\%{$D{classes}})){
	printdox(0,"| " . $D{classes}{$classes}{name} . "| " . $D{classes}{$classes}{name} . "| "
		. recover_special_code( getContent( \%{$D{classes}{$classes}{brief}{doc}}))
		. " <br>$returnp"
		. recover_special_code( getContent( \%{$D{classes}{$classes}{detailed}{doc}})) );
}
printdox(0,"");

foreach my $classes (sort_keys(\%{$D{classes}})){
	printdox(0,"");
	printdox(0,"");
	printdox(0,"## Class : " . $D{classes}{$classes}{name});

	my $myprev = "";
	my $mypuml = "";
	$mypuml .= "class " . $D{classes}{$classes}{name} . "\n";
	foreach my $base (sort_keys(\%{$D{classes}{$classes}{base}})){
		$mynow = $D{classes}{$classes}{name} . " -up-> " . $D{classes}{$classes}{base}{$base}{name} . "\n";
		if($myprev ne $mynow){
			$myprev = $mynow;
			$mypuml .= $mynow;
		} else {
		}
	}

	$myprev = "";
	foreach my $derived (sort_keys(\%{$D{classes}{$classes}{derived}})){
		$mynow = $D{classes}{$classes}{name} . " <-down- " . $D{classes}{$classes}{derived}{$derived}{name} . "\n";
		if($myprev ne $mynow){
			$myprev = $mynow;
			$mypuml .= $mynow;
		} else {
		}
	}
	printdox(0, "plantuml" , "class_" . $D{classes}{$classes}{name} , $mypuml);

	if(-e "./$UMLINCLUDE/" . $D{classes}{$classes}{name} . ".class"){
		printdox(0,"");
		printdox(1, "plantuml" , "class_" . $D{classes}{$classes}{name} . "_uml" , "!include ../$UMLINCLUDE/" . $D{classes}{$classes}{name} . ".class\n");
	}

	printdox(0,"- Description");
	printdox(1,"- " . recover_special_code( getContent( \%{$D{classes}{$classes}{brief}{doc}})) );
	printdox(1,"- " . recover_special_code( getContent( \%{$D{classes}{$classes}{detailed}{doc}})) );

	#printdox(0,"- Diagrams for Class");
	my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{detailed}{doc}}) );
	if($puml ne ""){
		printdox(0,"- Diagrams for Class");
		printdox(1,"plantuml" ,
			"class_" . $D{classes}{$classes}{name} . "_diagram" ,
			$puml);
	}
	putXrefitem(1,"step",\%{$D{classes}{$classes}{detailed}{doc}});
	putXrefitem(1,"algorithm",\%{$D{classes}{$classes}{detailed}{doc}});


	printdox(0,"- Diagrams for public member functions");
	foreach my $members (sort_keys(\%{$D{classes}{$classes}{public_methods}{members}})){
		printdox(1,"- " . $D{classes}{$classes}{public_methods}{members}{$members}{name} . " function");
		printdox(2,"- " . getContent( \%{ $D{classes}{$classes}{public_methods}{members}{$members}{brief}{doc} }) );
		my $details = getDetails(3, \%{ $D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc} });
		if($details ne "")
		{
			printdox(2,"- Details\n" . $details);
		}
		my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){
			printdox(2,"plantuml" ,
				"class_" . $D{classes}{$classes}{name} . "_public_methods" . "_" .  $D{classes}{$classes}{public_methods}{members}{$members}{name} , 
				$puml);
		}
		putXrefitem(2,"step",\%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}});
		putXrefitem(2,"algorithm",\%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}});
	}
	foreach my $members (sort_keys(\%{$D{classes}{$classes}{public_static_methods}{members}})){
		printdox(1,"- " . $D{classes}{$classes}{public_static_methods}{members}{$members}{name} . " function");
		printdox(2,"- " . getContent( \%{ $D{classes}{$classes}{public_static_methods}{members}{$members}{brief}{doc} }) );
		my $details = getDetails(3, \%{ $D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc} });
		if($details ne "")
		{
			printdox(2,"- Details\n" . $details);
		}
		my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){
			printdox(2,"plantuml" ,
				"class_" . $D{classes}{$classes}{name} . "_public_static_methods" . "_" .  $D{classes}{$classes}{public_static_methods}{members}{$members}{name} , 
				$puml);
		}
		putXrefitem(2,"step",\%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}});
		putXrefitem(2,"algorithm",\%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}});
	}

	printdox(0,"\n### Function Lists of " . $D{classes}{$classes}{name});
	printdox(0,"");
	printdox(0,"| Accessibility | Function | Description | Parameters | param input | param output | Returns | return Description |");
	printdox(0,"|-------|-------|----------|-------------|-------|-----|----|-------|");
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /_methods$/){
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				printdox(0,getMethodsRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) );
			}
		}
	}
	printdox(0,"");

	printdox(0,"\n### Variable Lists of " . $D{classes}{$classes}{name});
	printdox(0,"");
	printdox(0,"| Accessability | Variable Name | Type |  Description |");
	printdox(0,"|-------|-------|----------|-------------|");
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /_members$/){
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				printdox(0,getMembersRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) );
			}
		}
	}
	printdox(0,"");
}

printdox(0,"");
printdox(0,"");
printdox(0,"## Functions and Variables");
printdox(0,"### Function Lists");
printdox(0,"| FileName | Function | Description | Parameters | param input | param output | Returns | return Description |");
printdox(0,"|-------|-------|----------|-------------|-------|-----|----|-------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.h$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		printdox(0,getMethodsRow($D{files}{$files}{name},\%{$D{files}{$files}{functions}{members}{$members}}) );
	}
}
printdox(0,"");

printdox(0,"### Variable Lists");
printdox(0,"| FileName | Variable Name | Type |  Description |");
printdox(0,"|-------|-------|----------|-------------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{variables}{members}})){
		printdox(0,getMembersRow($D{files}{$files}{name},\%{$D{files}{$files}{variables}{members}{$members}}) );
	}
}
printdox(0,"");

foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }

	my $myflag = 0;
	my $filename = $D{files}{$files}{name};
	if(not ($filename =~ /\.cpp$/) ){ next; }
	$filename =~ s/\.[^.]*$//;
	printdox(0,"");
	printdox(0,"");
	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		my $puml = recover_special_code( getPlantuml( \%{$D{files}{$files}{functions}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){ $myflag = 1; last; }
	}
	if($myflag == 1){
		printdox(0,"### " . $filename . " Diagrams");
		printdox(0,"- Diagrams for public member functions");
	}
	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		my $puml = recover_special_code( getPlantuml( \%{$D{files}{$files}{functions}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){
			printdox(1,"plantuml" ,
				"class_" . $D{files}{$files}{name} . "_functions" . "_" .  $D{files}{$files}{functions}{members}{$members}{name} , 
				$puml);
		}
	}
}
close OH1;
close OH2;


# Start to get SRS
$outfile =~ s/\.md$/\.SRS\.md/;
$outwithimage =~ s/\.md$/\.SRS\.md/;
open(OH1,">",$outfile) or die "Can't open > $outfile $!";
open(OH2,">",$outwithimage) or die "Can't open > $outwithimage $!";

# Gather the SRS information from DoxyDocs : Class
foreach my $classes (sort_keys(\%{$D{classes}})){
	#CS{class}{SRS…}
	#CFSD{class}{function}{SRS} = desc
	#SC{SRS}{class}
	#SCF{SRS}{class}{function}
	my $myclassname = $D{classes}{$classes}{name};

	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /_methods$/){
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				my $myfunc;
				my %mySRS;
				my $mybrief;
				($myfunc,$mybrief,%mySRS) = getSRS(\%{$D{classes}{$classes}{$accesstype}{members}{$members}});
				foreach my $keySRS (sort_keys(\%mySRS)){
					print "-1CCC $myclassname $myfunc $keySRS => $mySRS{$keySRS}\n";
					$CS{$myclassname}{$keySRS} = "$keySRS";
					$CFSD{$myclassname}{$myfunc}{$keySRS} = recover_special_code( $mySRS{$keySRS} );
					if($CFSD{$myclassname}{$myfunc}{$keySRS} =~ /^\s*$/){
						$CFSD{$myclassname}{$myfunc}{$keySRS} = recover_special_code( "Brief: " . $mybrief );
					}
					$SC{$keySRS}{$myclassname} = "$keySRS";
					$SCF{$keySRS}{$myclassname}{$myfunc} = "$keySRS";
				}
			}
		}
	}
}

# Gather the SRS information from DoxyDocs : Function
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }
	my $filename = $D{files}{$files}{name};
	print "-1FFFFFF $filename\n";
	if(not ($filename =~ /\.cpp$/) ){ next; }
	#$filename =~ s/\.[^.]*$//;
	print "-2FFFFFF $filename\n";
	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		my $myfunc;
		my %mySRS;
		my $mybrief;
		($myfunc,$mybrief,%mySRS) = getSRS(\%{$D{files}{$files}{functions}{members}{$members}});
		foreach my $keySRS (sort_keys(\%mySRS)){
			print "-2FFF $filename $myfunc $keySRS => $mySRS{$keySRS}\n";
			$CS{$filename}{$keySRS} = "$keySRS";
			$CFSD{$filename}{$myfunc}{$keySRS} = recover_special_code( $mySRS{$keySRS} );
			if($CFSD{$filename}{$myfunc}{$keySRS} =~ /^\s*$/){
				$CFSD{$filename}{$myfunc}{$keySRS} = recover_special_code( "Brief: " . $mybrief );
			}
			$SC{$keySRS}{$filename} = "$keySRS";
			$SCF{$keySRS}{$filename}{$myfunc} = "$keySRS";
		}
	}
}

# Write the SRS to the file
printdox(0,"# SRS");
my $mystr;
printdox(0,"\n## SRS vs Class");
printdox(0,"| SRS | Class Lists |");
printdox(0,"|-----------|:----------------------|");
foreach my $keySRS (sort_keys(\%SC)){        #SC{SRS}{class}
	$mystr = "";
	$mystr .= "| $keySRS | ";
	foreach my $key2 (sort_keys(\%{$SC{$keySRS}})){        #SC{SRS}{class}
		$mystr .= " $key2,";
	}
	$mystr =~ s/,\s*$//;
	$mystr .= " |";
	printdox(0,$mystr);
}
printdox(0,"");

printdox(0,"\n## SRS vs Class::Function");
printdox(0,"| SRS | Class::Function Lists |");
printdox(0,"|-----------|:----------------------------------|");
foreach my $keySRS (sort_keys(\%SCF)){        #SCF{SRS}{class}{function}
	$mystr = "";
	$mystr .= "| $keySRS | ";
	foreach my $keyClass (sort_keys(\%{$SCF{$keySRS}})){        #SCF{SRS}{class}{function}
		foreach my $keyFunc (sort_keys(\%{$SCF{$keySRS}{$keyClass}})){        #SCF{SRS}{class}{function}
			$mystr .= " $keyClass\:\:$keyFunc ,";
		}
	}
	$mystr =~ s/,\s*$//;
	$mystr .= " |";
	printdox(0,$mystr);
}
printdox(0,"");

printdox(0,"\n## Class vs SRS");
printdox(0,"| Class | SRS Lists |");
printdox(0,"|-----------|:------------------|");
foreach my $keyClass (sort_keys(\%CS)){     #CS{class}{SRS…}
	$mystr = "";
	$mystr .= "| $keyClass | ";
	foreach my $keySRS (sort_keys(\%{$CS{$keyClass}})){    #CS{class}{SRS…}
		$mystr .= " $keySRS,";
	}
	$mystr =~ s/,\s*$//;
	$mystr .= " |";
	printdox(0,$mystr);
}
printdox(0,"");

printdox(0,"\n## Class::Function vs SRS");
printdox(0,"|  Class::Function | SRS Lists|");
printdox(0,"|---------------|:--------------------------|");
foreach my $keyClass (sort_keys(\%CFSD)){      #CFSD{class}{function}{SRS} = desc
	foreach my $keyFunc (sort_keys(\%{$CFSD{$keyClass}})){     #CFSD{class}{function}{SRS} = desc
		$mystr = "";
		$mystr .= "| $keyClass\:\:$keyFunc | ";
		foreach my $keySRS (sort_keys(\%{$CFSD{$keyClass}{$keyFunc}})){    #CFSD{class}{function}{SRS} = desc
			$mystr .= " $keySRS ,";
		}
		$mystr =~ s/,\s*$//;
		$mystr .= " |";
		printdox(0,$mystr);
	}
}
printdox(0,"");

printdox(0,"\n## Class::Function + SRS vs Description");
printdox(0,"|  Class::Function | SRS | Description |");
printdox(0,"|---------------|----------|:----------------|");
foreach my $keyClass (sort_keys(\%CFSD)){      #CFSD{class}{function}{SRS} = desc
	foreach my $keyFunc (sort_keys(\%{$CFSD{$keyClass}})){     #CFSD{class}{function}{SRS} = desc
		$mystr .= "| $keyClass\:\:$keyFunc | ";
		foreach my $keySRS (sort_keys(\%{$CFSD{$keyClass}{$keyFunc}})){    #CFSD{class}{function}{SRS} = desc
			$mystr = "| $keyClass\:\:$keyFunc | $keySRS  | $CFSD{$keyClass}{$keyFunc}{$keySRS} |";
			printdox(0,$mystr);
		}
	}
}
printdox(0,"");

close OH1;
close OH2;
