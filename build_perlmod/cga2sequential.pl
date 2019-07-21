our $returnp = "<br>";
our $boldstartp = "<b>";
our $boldendp = "</b>";
our $UMLINCLUDE = "UML";
our %CS;
our %CFSD;
our %SC;
our %SCF;

sub __SUB__ { return  (caller 2)[3] . "|" . (caller 2)[2] . "-" . (caller 1)[3] . "|" . (caller 1)[2] . "-" . (caller 0)[2] . ": " }

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

    my $oh1,$oh2;

	if($p =~ /^\s*-\s*$/){ return ($depth,$p,"",""); }

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
        $oh1 = 
		    "$mytab" . "- " . $name . "\n" . 
		    "```puml\n" . 
		    "@pp" . 
		    "\n" . 
		    "```\n";

		$name =~ s/\s//g;
		$name =~ s/\:/_/g;
		$name =~ s/\./_/g;
		open(LO,">", "./outplantuml/" . $name . "\.htmlmd\.plantuml") or die "Can't open > $name $!";
		print LO "\n\@startuml " . $name . "\.png\n";
		print LO @pp;
		print LO "\n\@enduml\n";
		close LO;
		print OH2 "$mytab" . "- " . $name . "\n";
		#print OH2 "\n$mytab\![alt " . "./outplantuml/" . $name . "\.png](" . "./outplantuml/" . $name . "\.png)\n";
		print OH2 "![alt " . "./outplantuml/" . $name . "\.png](" . "./outplantuml/" . $name . "\.png)\n";
		print OH2 "\n";
        $oh2 = 
		    "$mytab" . "- " . $name . "\n" .
		    "\n$mytab\![alt " . "./outplantuml/" . $name . "\.png](" . "./outplantuml/" . $name . "\.png)\n" .
		    "\n";
	} else {
		print "$mytab" . "$p";
		print "\n";
		print "$mytab" . "@p";
		print "\n";
		print OH1 "$mytab" . "$p@p";
		print OH1 "\n";
        $oh1 = "$mytab" . "$p@p" .  "\n";
		print OH2 "$mytab" . "$p@p";
		print OH2 "\n";
        $oh2 = "$mytab" . "$p@p" .  "\n";
	}
    return ($depth,$p,$oh1,$oh2);
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
					if($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} =~ /in/){
						$myin .= "$boldstartp" . "[in] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "$boldendp";
						print "myin $myin\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myin .= " " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "$returnp";
								print "myin2 $myin\n";
							}
						}
					}
					if($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} =~ /out/){
						$myout .= "$boldstartp" . "[out] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "$boldendp";
						print "myout $myout\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myout .= " " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "$returnp";
								print "myout2 $myout\n";
							}
						}
					}
					if($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq ""){
						$myany .= "$boldstartp" . "[-] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "$boldendp";
						print "myany $myany\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myany .= " " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "$returnp";
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
                if($mystr =~ /^\s*$/){
				    $mystr .= "$boldstartp" . $myhash->{$tmpKey}{retvals}{$tmp2}{parameters}{1}{name} . "$boldendp";
                } else {
				    $mystr .= "<br>$boldstartp" . $myhash->{$tmpKey}{retvals}{$tmp2}{parameters}{1}{name} . "$boldendp";
                }
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
		$mystr .= "$returnp";
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
    my $mytype;

	$mystr .= "| " . $myaccessibility;
	$mystr .= "| " . $myhash->{name};
	$mystr .= " | $boldstartp" . recover_special_code( getContent(\%{$myhash->{brief}{doc}}) ) . "$boldendp";
	#$mystr .= "$returnp" . getContent(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . recover_special_code( getParameters(\%{$myhash->{parameters}}) );
	($myin , $myout , $myany) = getParams(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . $myin . $myany;
	$mystr .= " | " . $myout;
	$mytype = $myhash->{type};     # return type of function
    $mytype =~ s/^\s*static\s*//;
    $mytype =~ s/^\s*virtual\s*//;
    $mytype =~ s/^\s*static\s*//;
	$mystr .= " | " . $mytype;  # return type of function
	#$mystr .= " | " . recover_special_code( getReturn(\%{$myhash->{detailed}{doc}}) ) . " <br>" . recover_special_code( getRetvals(\%{$myhash->{detailed}{doc}}) );
	$mystr .= " | " . recover_special_code( getRetvals(\%{$myhash->{detailed}{doc}}) );
	$mystr .= " | ";
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
	$mystr .= "| ";
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

sub getSRS
{
	my $myhash = shift;  # \%{$D{classes}{$classes}{$accesstype}{members}{$members}}
	my %mydesc;
	my @mysrs;
	my $myfunc;

	$myfunc = $myhash->{name};
	print "getSRS $myfunc\n";

	%mydesc = getSee(\%{$myhash->{detailed}{doc}});
	print %mydesc . "]]]]\n";
	foreach my $i (sort_keys(\%mydesc)){
		print "$i => $mydesc{$i}\n";
	}
	return ($myfunc, %mydesc);
}

sub	getDetailsSequential
{
    my $mytabCount = shift;
	my $myhash = shift;  # \%{ $D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc} }
    my $myname= shift;  # plantuml name

    my $mypumlname = $myname;  # plantuml name
	# $myhash->{$tmpKey}{see} ne ""
	# foreach my $i (sort_keys(  \%{$myhash->{$tmpKey}{see}}  ))

	my $mytab = "";
	my $myplantumlCnt = 1;
	for(my $i=0;$i<$mytabCount;$i++){ $mytab .= "\t"; }
	$mypumlname =~ s/\s//g;
	$mypumlname =~ s/\:/_/g;
	$mypumlname =~ s/\./_/g;

    ## @array = (10, 20, 30);
    ## %hash = ('key1' => 10, 'key2' => 20);
    ## case (\@array)    { print "number in list" }
    ## case (\%hash)     { print "entry in hash" }
    ## else              { print "previous case not true" }
    my $mystr3 = "";
    my $mystr4 = "";
    my $myline = "";
    my @mybreak = ("parbreak" , "linebreak");;
    my @mytext = ("url" , "text");;
	foreach my $i (sort_keys(  \%{$myhash} )){
        foreach my $mykind (sort_keys(  \%{$myhash->{$i}} )){
            print __SUB__ . " TYTY: $i : $mykind \n";
            if($mykind eq "type"){
                print __SUB__ . " : type : " . $myhash->{$i}{type} . "\n";
                if( ($myhash->{$i}{type} eq "parbreak")
                        || ($myhash->{$i}{type} eq "linebreak") ){
                    if(not ($myline =~ /^\s*$/) ){
                        $mystr3 .= "$mytab" . "- TTTT $myline\n";
                        $mystr4 .= "$mytab" . "- TTTT $myline\n";
                        $myline = "";
                    }
                }
                elsif( ($myhash->{$i}{type} eq "url")
                        || ($myhash->{$i}{type} eq "text") ){
                    $myline .= " " . $myhash->{$i}{content};
                }
                elsif($myhash->{$i}{type} eq "plantuml") {
                    $mystr3 .= 
                        "$mytab" . "- TTTT " . $myname . " UML\n" . 
                        "```puml\n" . 
                        recover_special_code( $myhash->{$i}{content} ) . 
                        "\n" . 
                        "```\n";
                    open(LO,">", "./outplantuml/" . $mypumlname . $myplantumlCnt . "\.htmlmd\.plantuml") or die "Can't open > $name $!";
                    print LO "\n\@startuml " . $mypumlname . $myplantumlCnt . "\.png\n";
                    print LO recover_special_code( $myhash->{$i}{content} );
                    print LO "\n\@enduml\n";
                    close LO;
                    $mystr4 .= 
                        "$mytab" . "- TTTT " . $myname . " UML\n" . 
                        "\n$mytab\![alt " . "./outplantuml/" . $mypumlname . $myplantumlCnt . "\.png](" . "./outplantuml/" . $mypumlname . $myplantumlCnt . "\.png)\n";
                    $myplantumlCnt++;
                }
            }
            elsif($mykind eq "note"){
                print __SUB__ . " : note : " . $myhash->{$i}{note} . "\n";
                $mystr3 .= "$mytab" . "> TTTT " .  getContent(\%{$myhash->{$i}{$mykind}}) . "\n";
                $mystr4 .= "$mytab" . "> TTTT " .  getContent(\%{$myhash->{$i}{$mykind}}) . "\n";
            }
        }
    }
    if(not($myline =~ /^\s*$/)){
        $mystr3 .= "$mytab" . "- TTTT $myline\n";
        $mystr4 .= "$mytab" . "- TTTT $myline\n";
    }
    
    print __SUB__ . " : mystr3 $myname : " . $mystr3 . "\n";
    print __SUB__ . " : mystr4 $myname : " . $mystr4 . "\n";
    return ($mystr3, $mystr4);

}


###
###================ main ====================
###

print "arguments count : " . ($#ARGV +1) . "\n";
print @ARGV . "\n";
($infile , $outfile) = (@ARGV);
if($infile eq ""){
	$infile = "default.GV";
}
if($outfile eq ""){
	$outfile = "out.html.md";
	$outwithimage = "out.html.plantuml.md";
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

open(OH1,">",$outfile . ".full.md") or die "Can't open > $outfile" . ".full.md $!";  # sequ
open(OH2,">",$outwithimage . ".full.md") or die "Can't open > $outwithimage" . ".full.md $!";  # sequ
open(OH3,">",$outfile) or die "Can't open > $outfile $!";  # sequ
open(OH4,">",$outwithimage) or die "Can't open > $outwithimage $!";  # sequ

my $n1,$n2,$n3,$n4;
my $r3="",$r4="";
my $lflag1=0,$lflag2=0,$lflag3=0;$lflag4=0;
my $lr3="",$lr4="";
my $llflag=0;
($n1,$n2,$n3,$n4) = printdox(0,"# Class Lists");
$r3 .= $n3; $r4 .= $n4;
($n1,$n2,$n3,$n4) = printdox(0,"| Class | Class ID | Description |");
$r3 .= $n3; $r4 .= $n4;
($n1,$n2,$n3,$n4) = printdox(0,"|-------|----------|-------------|");
$r3 .= $n3; $r4 .= $n4;
foreach my $classes (sort_keys(\%{$D{classes}})){
    $lflag1=1;
	($n1,$n2,$n3,$n4) = printdox(0,"| " . $D{classes}{$classes}{name} . "| " . $D{classes}{$classes}{name} . "| <b>"
		. recover_special_code( getContent( \%{$D{classes}{$classes}{brief}{doc}}))
		. "</b> $returnp"
		. recover_special_code( getContent( \%{$D{classes}{$classes}{detailed}{doc}})) );
    $r3 .= $n3; $r4 .= $n4;
}
($n1,$n2,$n3,$n4) = printdox(0,"");
$r3 .= $n3; $r4 .= $n4;
if($lflag1 == 1){ print OH3 "$r3"; print OH4 "$r4";}


foreach my $classes (sort_keys(\%{$D{classes}})){
    $lflag1=0;
    $r3="";$r4="";
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $r3 .= $n3; $r4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $r3 .= $n3; $r4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"## Class : " . $D{classes}{$classes}{name});
    $r3 .= $n3; $r4 .= $n4;

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
	($n1,$n2,$n3,$n4) = printdox(0, "plantuml" , "class_" . $D{classes}{$classes}{name} , $mypuml);
    $r3 .= $n3; $r4 .= $n4;

	if(-e "./$UMLINCLUDE/" . $D{classes}{$classes}{name} . ".class"){
		($n1,$n2,$n3,$n4) = printdox(0,"");
        $r3 .= $n3; $r4 .= $n4;
		($n1,$n2,$n3,$n4) = printdox(0, "plantuml" , "class_" . $D{classes}{$classes}{name} . "_uml" , "!include ../$UMLINCLUDE/" . $D{classes}{$classes}{name} . ".class\n");
        $r3 .= $n3; $r4 .= $n4;
	}

    $lr3="";$lr4="";  $llflag=0;
	($n1,$n2,$n3,$n4) = printdox(0,"- Class " .  $D{classes}{$classes}{name} . " Description");
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(1,"- " . recover_special_code( getContent( \%{$D{classes}{$classes}{brief}{doc}})) );
    if(not($n3 =~ /^[\s\n]*$/)){ $llflag=1; }
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(2,"- " . recover_special_code( getContent( \%{$D{classes}{$classes}{detailed}{doc}})) );
    if(not($n3 =~ /^[\s\n]*$/)){ $llflag=1; }
    $lr3 .= $n3; $lr4 .= $n4;
    if($llflag == 1){ 
        #print OH3 "$lr3"; print OH4 "$lr4";
        $lflag1=1;
        $r3 .= $lr3; $r4 .= $lr4;
    }

    $lr3="";$lr4="";  $llflag=0;
	#printdox(0,"- Diagrams for Class");
	my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{detailed}{doc}}) );
	if($puml ne ""){
		($n1,$n2,$n3,$n4) = printdox(0,"- Class Diagrams");
        $lr3 .= $n3; $lr4 .= $n4;
		($n1,$n2,$n3,$n4) = printdox(1,"plantuml" ,
			"class_" . $D{classes}{$classes}{name} . "_diagram" ,
			$puml);
        $lr3 .= $n3; $lr4 .= $n4;
        #print OH3 "$lr3"; print OH4 "$lr4";
        $lflag1=1;
        $r3 .= $lr3; $r4 .= $lr4;

	}
	putXrefitem(1,"step",\%{$D{classes}{$classes}{detailed}{doc}});
	putXrefitem(1,"algorithm",\%{$D{classes}{$classes}{detailed}{doc}});


    # ($n1,$n2,$n3,$n4) = 

    
    $lr3="";$lr4="";  $llflag=0;
	($n1,$n2,$n3,$n4) = printdox(0,"- Public member functions");
    $lr3 .= $n3; $lr4 .= $n4;
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		#if($accesstype =~ /_methods$/)
		if($accesstype =~ /^public.*_methods$/)
        {
            foreach my $members (sort_keys(\%{$D{classes}{$classes}{public_methods}{members}})){
                my $lrfor3="",$lrfor4="";
                my $lforflag=0;

                ($n1,$n2,$n3,$n4) = printdox(1,"- " . $D{classes}{$classes}{public_methods}{members}{$members}{name} . " function");
                $lrfor3 .= $n3; $lrfor4 .= $n4;

                ($n1,$n2,$n3,$n4) = printdox(2,"- " . getContent( \%{ $D{classes}{$classes}{public_methods}{members}{$members}{brief}{doc} }) );
                if(not($n3 =~ /^[-\s\n]*$/)){ 
                    $lforflag=1;
                    $lrfor3 .= $n3; $lrfor4 .= $n4;
                }
                my $mydetailsSequential3 = "";
                my $mydetailsSequential4 = "";
                ($mydetailsSequential3,$mydetailsSequential4) = getDetailsSequential(3
                        , \%{ $D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc} }
                        , "class_" . $D{classes}{$classes}{name} . "_public_methods" . "_" .  $D{classes}{$classes}{public_methods}{members}{$members}{name} 
                        );
                if(not($mydetailsSequential3 =~ /^[-\s\n]*$/)){
                    $lforflag=1;
                    $lrfor3 .= $mydetailsSequential3; $lrfor4 .= $mydetailsSequential4;
                }
                if($lforflag == 1){
                    $llflag=1;
                    $lr3 .= $lrfor3; $lr4 .= $lrfor4;
                }
            }
        }
    }

	foreach my $members (sort_keys(\%{$D{classes}{$classes}{public_methods}{members}})){
$comments=<<"EOF";
        print __SUB__ . " public_methods classes : $classes , members : $members\n";
        my $lrfor3="",$lrfor4="";
        my $lforflag=0;
		($n1,$n2,$n3,$n4) = printdox(1,"- " . $D{classes}{$classes}{public_methods}{members}{$members}{name} . " function");
        $lrfor3 .= $n3; $lrfor4 .= $n4;
		($n1,$n2,$n3,$n4) = printdox(2,"- " . getContent( \%{ $D{classes}{$classes}{public_methods}{members}{$members}{brief}{doc} }) );
        if(not($n3 =~ /^[\s\n]*$/)){ 
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
        }
		my $details = getDetails(3, \%{ $D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc} });
        if(not($details =~ /^[\s\n]*$/)){
			($n1,$n2,$n3,$n4) = printdox(2,"- Details\n" . $details);
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
		}
		my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}}) );
        if(not($puml =~ /^[\s\n]*$/)){
			($n1,$n2,$n3,$n4) = printdox(2,"plantuml" ,
				"class_" . $D{classes}{$classes}{name} . "_public_methods" . "_" .  $D{classes}{$classes}{public_methods}{members}{$members}{name} , 
				$puml);
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
		}
        if($lforflag == 1){
            $llflag=1;
            $lr3 .= $lrfor3; $lr4 .= $lrfor4;
        }
EOF
		putXrefitem(2,"step",\%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}});
		putXrefitem(2,"algorithm",\%{$D{classes}{$classes}{public_methods}{members}{$members}{detailed}{doc}});
        print __SUB__ . " public_methods lr3 : $lr3\n";
	}
	foreach my $members (sort_keys(\%{$D{classes}{$classes}{public_static_methods}{members}})){
$comments=<<"EOF";
        print __SUB__ . " public_static_methods classes : $classes , members : $members\n";
        my $lrfor3="",$lrfor4="";
        my $lforflag=0;
		($n1,$n2,$n3,$n4) = printdox(1,"- " . $D{classes}{$classes}{public_static_methods}{members}{$members}{name} . " function");
        $lrfor3 .= $n3; $lrfor4 .= $n4;
		($n1,$n2,$n3,$n4) = printdox(2,"- " . getContent( \%{ $D{classes}{$classes}{public_static_methods}{members}{$members}{brief}{doc} }) );
        if(not($n3 =~ /^[\s\n]*$/)){ 
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
        }
		my $details = getDetails(3, \%{ $D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc} });
        if(not($details =~ /^[\s\n]*$/)){
			($n1,$n2,$n3,$n4) = printdox(2,"- Details\n" . $details);
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
		}
		my $puml = recover_special_code( getPlantuml( \%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}}) );
        if(not($puml =~ /^[\s\n]*$/)){
			($n1,$n2,$n3,$n4) = printdox(2,"plantuml" ,
				"class_" . $D{classes}{$classes}{name} . "_public_methods" . "_" .  $D{classes}{$classes}{public_methods}{members}{$members}{name} , 
				$puml);
            $lforflag=1;
            $lrfor3 .= $n3; $lrfor4 .= $n4;
		}
        if($lforflag == 1){
            $llflag=1;
            $lr3 .= $lrfor3; $lr4 .= $lrfor4;
        }
EOF
		putXrefitem(2,"step",\%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}});
		putXrefitem(2,"algorithm",\%{$D{classes}{$classes}{public_static_methods}{members}{$members}{detailed}{doc}});
        print __SUB__ . " public_methods lr3 : $lr3\n";
	}
    if($llflag==1){
        $lflag1=1;
        $r3 .= $lr3; $r4 .= $lr4;
    }


    $lr3="";$lr4="";  $llflag=0;
	($n1,$n2,$n3,$n4) = printdox(0,"\n### Function Lists of " . $D{classes}{$classes}{name});
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"| Accessibility | Function | Description | Parameters | param input | param output | Returns | return Description |");
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"|-------|-------|----------|-------------|-------|-----|----|-------|");
    $lr3 .= $n3; $lr4 .= $n4;
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		#if($accesstype =~ /_methods$/)
		if($accesstype =~ /^public.*_methods$/)
        {
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				($n1,$n2,$n3,$n4) = printdox(0,getMethodsRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) );
                if(not($n3 =~ /^[\s\n]*$/)){ $llflag=1; }
                $lr3 .= $n3; $lr4 .= $n4;
			}
		}
	}
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $lr3 .= $n3; $lr4 .= $n4;
    if($llflag == 1){ 
        $lflag1=1;
        $r3 .= $lr3; $r4 .= $lr4;
    }

    $lr3="";$lr4="";  $llflag=0;
	($n1,$n2,$n3,$n4) = printdox(0,"\n### Variable Lists of " . $D{classes}{$classes}{name});
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"| Accessability | Variable Name | Type |  Description |");
    $lr3 .= $n3; $lr4 .= $n4;
	($n1,$n2,$n3,$n4) = printdox(0,"|-------|-------|----------|-------------|");
    $lr3 .= $n3; $lr4 .= $n4;
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		#if($accesstype =~ /_members$/)
		if($accesstype =~ /^public.*_members$/)
        {
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				($n1,$n2,$n3,$n4) = printdox(0,getMembersRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) );
                if(not($n3 =~ /^[\s\n]*$/)){ $llflag=1; }
                $lr3 .= $n3; $lr4 .= $n4;
			}
		}
	}
	($n1,$n2,$n3,$n4) = printdox(0,"");
    $lr3 .= $n3; $lr4 .= $n4;
    if($llflag == 1){ 
        $lflag1=1;
        $r3 .= $lr3; $r4 .= $lr4;
    }

    # print class
    if($lflag1 == 1){ 
        print OH3 "$r3"; print OH4 "$r4";
    }
}

($n1,$n2,$n3,$n4) = printdox(0,"");
($n1,$n2,$n3,$n4) = printdox(0,"");
($n1,$n2,$n3,$n4) = printdox(0,"## Functions and Variables");
($n1,$n2,$n3,$n4) = printdox(0,"### Function Lists");
($n1,$n2,$n3,$n4) = printdox(0,"| FileName | Function | Description | Parameters | param input | param output | Returns | return Description |");
($n1,$n2,$n3,$n4) = printdox(0,"|-------|-------|----------|-------------|-------|-----|----|-------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.h$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		($n1,$n2,$n3,$n4) = printdox(0,getMethodsRow($D{files}{$files}{name},\%{$D{files}{$files}{functions}{members}{$members}}) );
	}
}
($n1,$n2,$n3,$n4) = printdox(0,"");

($n1,$n2,$n3,$n4) = printdox(0,"### Variable Lists");
($n1,$n2,$n3,$n4) = printdox(0,"| FileName | Variable Name | Type |  Description |");
($n1,$n2,$n3,$n4) = printdox(0,"|-------|-------|----------|-------------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{variables}{members}})){
		($n1,$n2,$n3,$n4) = printdox(0,getMembersRow($D{files}{$files}{name},\%{$D{files}{$files}{variables}{members}{$members}}) );
	}
}
($n1,$n2,$n3,$n4) = printdox(0,"");

foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }

	my $myflag = 0;
	my $filename = $D{files}{$files}{name};
	if(not ($filename =~ /\.cpp$/) ){ next; }
	$filename =~ s/\.[^.]*$//;
	($n1,$n2,$n3,$n4) = printdox(0,"");
	($n1,$n2,$n3,$n4) = printdox(0,"");
	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		my $puml = recover_special_code( getPlantuml( \%{$D{files}{$files}{functions}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){ $myflag = 1; last; }
	}
	if($myflag == 1){
		($n1,$n2,$n3,$n4) = printdox(0,"### " . $filename . " Diagrams");
		($n1,$n2,$n3,$n4) = printdox(0,"- Diagrams for public member functions");
	}
	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		my $puml = recover_special_code( getPlantuml( \%{$D{files}{$files}{functions}{members}{$members}{detailed}{doc}}) );
		if($puml ne ""){
			($n1,$n2,$n3,$n4) = printdox(1,"plantuml" ,
				"class_" . $D{files}{$files}{name} . "_functions" . "_" .  $D{files}{$files}{functions}{members}{$members}{name} , 
				$puml);
		}
	}
}
close OH1;
close OH2;
close OH3;
close OH4;

$outfile =~ s/\.md$/\.SRS\.md/;
$outwithimage =~ s/\.md$/\.SRS\.md/;
print "in : $infile  , out md file : $outwithimage , out md file with plantuml : $outfile\n";
print STDERR "in : $infile  , out md file : $outwithimage , out md file with plantuml : $outfile\n";
open(OH1,">",$outfile) or die "Can't open > $outfile $!";
open(OH2,">",$outwithimage) or die "Can't open > $outwithimage $!";

($n1,$n2,$n3,$n4) = printdox(0,"# SRS");
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
				($myfunc,%mySRS) = getSRS(\%{$D{classes}{$classes}{$accesstype}{members}{$members}});
				foreach my $keySRS (sort_keys(\%mySRS)){
					print "-TTT $myclassname $myfunc $keySRS => $mySRS{$keySRS}\n";
					$CS{$myclassname}{$keySRS} = "$keySRS";
					$CFSD{$myclassname}{$myfunc}{$keySRS} = recover_special_code( $mySRS{$keySRS} );
					$SC{$keySRS}{$myclassname} = "$keySRS";
					$SCF{$keySRS}{$myclassname}{$myfunc} = "$keySRS";
				}
			}
		}
	}
}

my $mystr;

($n1,$n2,$n3,$n4) = printdox(0,"\n## SRS vs Class");
($n1,$n2,$n3,$n4) = printdox(0,"| SRS | Class Lists |");
($n1,$n2,$n3,$n4) = printdox(0,"|-----------|:----------------------|");
foreach my $keySRS (sort_keys(\%SC)){        #SC{SRS}{class}
	$mystr = "";
	$mystr .= "| $keySRS | ";
	foreach my $key2 (sort_keys(\%{$SC{$keySRS}})){        #SC{SRS}{class}
		$mystr .= " $key2,";
	}
	$mystr =~ s/,\s*$//;
	$mystr .= " |";
	($n1,$n2,$n3,$n4) = printdox(0,$mystr);
}
($n1,$n2,$n3,$n4) = printdox(0,"");

($n1,$n2,$n3,$n4) = printdox(0,"\n## SRS vs Class::Function");
($n1,$n2,$n3,$n4) = printdox(0,"| SRS | Class::Function Lists |");
($n1,$n2,$n3,$n4) = printdox(0,"|-----------|:----------------------------------|");
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
	($n1,$n2,$n3,$n4) = printdox(0,$mystr);
}
($n1,$n2,$n3,$n4) = printdox(0,"");

($n1,$n2,$n3,$n4) = printdox(0,"\n## Class vs SRS");
($n1,$n2,$n3,$n4) = printdox(0,"| Class | SRS Lists |");
($n1,$n2,$n3,$n4) = printdox(0,"|-----------|:------------------|");
foreach my $keyClass (sort_keys(\%CS)){     #CS{class}{SRS…}
	$mystr = "";
	$mystr .= "| $keyClass | ";
	foreach my $keySRS (sort_keys(\%{$CS{$keyClass}})){    #CS{class}{SRS…}
		$mystr .= " $keySRS,";
	}
	$mystr =~ s/,\s*$//;
	$mystr .= " |";
	($n1,$n2,$n3,$n4) = printdox(0,$mystr);
}
($n1,$n2,$n3,$n4) = printdox(0,"");

($n1,$n2,$n3,$n4) = printdox(0,"\n## Class::Function vs SRS");
($n1,$n2,$n3,$n4) = printdox(0,"|  Class::Function | SRS Lists|");
($n1,$n2,$n3,$n4) = printdox(0,"|---------------|:--------------------------|");
foreach my $keyClass (sort_keys(\%CFSD)){      #CFSD{class}{function}{SRS} = desc
	foreach my $keyFunc (sort_keys(\%{$CFSD{$keyClass}})){     #CFSD{class}{function}{SRS} = desc
		$mystr = "";
		$mystr .= "| $keyClass\:\:$keyFunc | ";
		foreach my $keySRS (sort_keys(\%{$CFSD{$keyClass}{$keyFunc}})){    #CFSD{class}{function}{SRS} = desc
			$mystr .= " $keySRS ,";
		}
		$mystr =~ s/,\s*$//;
		$mystr .= " |";
		($n1,$n2,$n3,$n4) = printdox(0,$mystr);
	}
}
($n1,$n2,$n3,$n4) = printdox(0,"");

($n1,$n2,$n3,$n4) = printdox(0,"\n## Class::Function + SRS vs Description");
($n1,$n2,$n3,$n4) = printdox(0,"|  Class::Function | SRS | Description |");
($n1,$n2,$n3,$n4) = printdox(0,"|---------------|----------|:----------------|");
foreach my $keyClass (sort_keys(\%CFSD)){      #CFSD{class}{function}{SRS} = desc
	foreach my $keyFunc (sort_keys(\%{$CFSD{$keyClass}})){     #CFSD{class}{function}{SRS} = desc
		$mystr .= "| $keyClass\:\:$keyFunc | ";
		foreach my $keySRS (sort_keys(\%{$CFSD{$keyClass}{$keyFunc}})){    #CFSD{class}{function}{SRS} = desc
			$mystr = "| $keyClass\:\:$keyFunc | $keySRS  | $CFSD{$keyClass}{$keyFunc}{$keySRS} |";
			($n1,$n2,$n3,$n4) = printdox(0,$mystr);
		}
	}
}
($n1,$n2,$n3,$n4) = printdox(0,"");

close OH1;
close OH2;
