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

our %LINK;
our %CLASS;
our %OVCLASS;
our %OVLINK;
our %GROUPCLASS;
our %SINGLECLASS;

sub classLink 
{
    my $myFirst = shift;
    my $myDirection= shift; 
	my $mySecond = shift;  
    my $myFP= shift; 

    $myFirst =~ s/::/./g;
    $mySecond =~ s/::/./g;
    $myFirst =~ s/^Bn/Bn.Bn/;
    $mySecond =~ s/^Bn/Bn.Bn/;
    $myFirst =~ s/^Bp/Bp.Bp/;
    $mySecond =~ s/^Bp/Bp.Bp/;
    if($LINK{$myFirst}{$mySecond} eq ""){
        if(  ($myFirst =~ /android/)
          || ($myFirst =~ /IInterface/)
          || ($myFirst =~ /RefBase/)
        ){ return ; }
        if(  ($mySecond =~ /android/)
          || ($mySecond =~ /IInterface/)
          || ($mySecond =~ /RefBase/)
        ){ return ; }
        $LINK{$myFirst}{$mySecond} = $myDirection;
        print $myFP "$myFirst $myDirection $mySecond\n";
        #print "$myFirst $myDirection $mySecond\n";
    } else {
        if($LINK{$myFirst}{$mySecond} ne $myDirection){
            print STDERR "Err : LINK  $myFirst  $myDirection  $mySecond\n";
        }
    }

    return ;
}

###
###================ main ====================
###

our $outdirectory = "./outplantuml/";
print "arguments count : " . ($#ARGV +1) . "\n";
print @ARGV . "\n";
($infile , $outmdfile) = (@ARGV);
if($infile eq ""){
	$infile = "default.GV";
}
if($outmdfile eq ""){
	$outmdfile = $outdirectory . "CLASSAllComponent.plantuml.md";
	$outplantumlfile = $outdirectory . "CLASSAllComponent.plantuml";
} else {
	if( not ($outmdfile =~ /\.md$/) ){
		print STDERR "2nd argument (file name) has .md extention.\n";
		exit ;
	}
	$outplantumlfile = $outmdfile;
	$outmdfile =~ s/\.md$/.plantuml.md/;
}
print "in : $infile  , outmdfile : $outmdfile , outplantumlfile  : $outplantumlfile\n";
print STDERR "in : $infile  , outmdfile : $outmdfile , outplantumlfile  : $outplantumlfile\n";

open(FH, "<",$infile) or die "Can't open < $infile $!";
while(<FH>){
	$s = $s_org = $_;
	chop($s);
	eval $s;
}
close(FH);

#open(OH1,">",$outmdfile . ".full.md") or die "Can't open > $outmdfile" . ".full.md $!";  # sequ
#open(OH2,">",$outplantumlfile . ".full.md") or die "Can't open > $outplantumlfile" . ".full.md $!";  # sequ
open(OH3,">",$outmdfile) or die "Can't open > $outmdfile $!";  # sequ
open(OH4,">",$outplantumlfile) or die "Can't open > $outplantumlfile $!";  # sequ

print OH3 "```puml\n";
print OH3 "\@startuml\n";
print OH4 "\@startuml\n";

foreach my $classes (sort_keys(\%{$D{classes}})){
	$CLASS{$D{classes}{$classes}{name}} = 1;;
}

foreach my $classes (sort_keys(\%{$D{classes}})){
	my $myclass = $D{classes}{$classes}{name};

	foreach my $base (sort_keys(\%{$D{classes}{$classes}{base}})){
        $mybase = $D{classes}{$classes}{base}{$base}{name};
		if($mybase =~ /Bn/){
            classLink($myclass,"-down->",$mybase,OH3);
            classLink($myclass,"-down->",$mybase,OH4);
        } else {
            classLink($myclass,"-->",$mybase,OH3);
            classLink($myclass,"-->",$mybase,OH4);
        }
        #print "class $classes , base $base\n";
	}

	foreach my $derived (sort_keys(\%{$D{classes}{$classes}{derived}})){
		$mydrived = $D{classes}{$classes}{derived}{$derived}{name};
		if($myclass =~ /Bn/){
		    classLink($mydrived,"-down->",$myclass,OH3);
		    classLink($mydrived,"-down->",$myclass,OH4);
        } else {
		    classLink($mydrived,"-->",$myclass,OH3);
		    classLink($mydrived,"-->",$myclass,OH4);
        }
        #print "class $classes , derived $derived\n";
	}

	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /all_members/){ next; }
		if($accesstype =~ /_members$/){
            foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
                my $mymembertype = $D{classes}{$classes}{$accesstype}{members}{$members}{type};
                my $mymembername = $D{classes}{$classes}{$accesstype}{members}{$members}{name};
                my $composition = "*--";
                if( ($mymembertype =~ s/\s*&$//) || ($mymembertype =~ s/\s*\*$//) )
                #if( ($mymembertype =~ s/\s*$//) )
                {
                    $composition = "o--";       ## aggregation type
                }
                if($mymembertype =~ /<\s*(\S+)\s*>/){
                    $mymembertype = $1;
                }
                $mymembertype =~ s/^\s*//;
                $mymembertype =~ s/\s*$//;
                if($mymembertype =~ /(\S+)$/){
                    $mymembertype = $1;
                }
                if($CLASS{$mymembertype} ne ""){
		            classLink($myclass,$composition,$mymembertype,OH3);
		            classLink($myclass,$composition,$mymembertype,OH4);
                }
            }
        }
    }

}
print OH3 "\@enduml\n";
print OH4 "\@enduml\n";
print OH3 "```\n";

#close OH1;
#close OH2;
close OH3;
close OH4;



our %CHECKGROUP;
foreach my $first (keys %LINK){
	foreach my $second (keys %{$LINK{$first}}){
        my $f=$first;
        my $s=$second, $d = $LINK{$first}{$second};
        if($first =~ /^([^\.]+)\./){
            $GROUPCLASS{$1}{$first} = 1;
            $CHECKGROUP{$1} = 1;
            $f = $1;
        } else {
            $SINGLECLASS{$first} = 1;
        }
        if($second =~ /([^\.]+)\./){
            $GROUPCLASS{$1}{$second} = 1;
            $s = $1;
        } else {
            $SINGLECLASS{$second} = 1;
        }
        $OVLINK{$f}{$s}{$d} = 1;
    }
}



$outmdfile = $outdirectory . "CLASSGroup.plantuml.md";
$outplantumlfile = $outdirectory . "CLASSGroup.plantuml";
open(OH3,">",$outmdfile) or die "Can't open > $outmdfile $!"; 
open(OH4,">",$outplantumlfile) or die "Can't open > $outplantumlfile $!";  # sequ
print OH3 "```puml\n";
print OH3 "\@startuml\n";
print OH4 "\@startuml\n";
foreach my $first (sort keys %OVLINK){
	foreach my $second (sort keys %{$OVLINK{$first}}){
	    foreach my $dir (sort keys %{$OVLINK{$first}{$second}}){
            print OH3 "$first $dir $second\n";
            print OH4 "$first $dir $second\n";
        }
    }
}
print OH3 "\@enduml\n";
print OH4 "\@enduml\n";
print OH3 "```\n";
close OH3;
close OH4;

$comments=<<"EOF";
foreach my $group (sort keys %GROUPCLASS){
    $outmdfile = $outdirectory . "CLASSSubGroup_$group.plantuml.md";
    $outplantumlfile = $outdirectory . "CLASSSubGroup_$group.plantuml";
    open(OH3,">",$outmdfile) or die "Can't open > $outmdfile $!"; 
    open(OH4,">",$outplantumlfile) or die "Can't open > $outplantumlfile $!";  # sequ
    print OH3 "```puml\n";
    print OH3 "\@startuml\n";
    print OH4 "\@startuml\n";
    my %myclass;
    foreach my $first (sort keys %LINK){
        foreach my $second (sort keys %{$LINK{$first}}){
            if(  ($first =~ /^$group(\.|$)/) || ($second =~ /^$group(\.|$)/) ){
                if( ($myclass{$first} eq "") && ($first =~ /\./) ){
                    $myclass{$first} = 1;
                    print OH3 "class $first\n";
                    print OH4 "class $first\n";
                }
                if( ($myclass{$second} eq "") && ($second =~ /\./) ){
                    $myclass{$second} = 1;
                    print OH3 "class $second\n";
                    print OH4 "class $second\n";
                }
            }
        }
    }
    foreach my $first (sort keys %LINK){
        foreach my $second (sort keys %{$LINK{$first}}){
            if(  ($first =~ /^$group(\.|$)/) || ($second =~ /^$group(\.|$)/) ){
                my $dir = $LINK{$first}{$second};
                print OH3 "$first $dir $second\n";
                print OH4 "$first $dir $second\n";
            }
        }
    }
    print OH3 "\@enduml\n";
    print OH4 "\@enduml\n";
    print OH3 "```\n";
    close OH3;
    close OH4;
}
EOF

my $cnt = 0;
$outmdfile = $outdirectory . "CLASSStatic.plantuml.md";
$outplantumlfile = $outdirectory . "CLASSStatic.plantuml";
open(OH3,">",$outmdfile) or die "Can't open > $outmdfile $!"; 
open(OH4,">",$outplantumlfile) or die "Can't open > $outplantumlfile $!";  # sequ
print OH3 "```puml\n";
print OH3 "\@startuml\n";
print OH4 "\@startuml\n";
foreach my $first (sort keys %GROUPCLASS){
    print OH3 "package \"" . $first . "\" {\n";
    print OH4 "package \"" . $first . "\" {\n";
	foreach my $second (sort keys %{$GROUPCLASS{$first}}){
        if($second =~ /([^\.]+)$/){
            print OH3 "\tcomponent $1$cnt [\n";
            print OH4 "\tcomponent $1$cnt [\n";
            $cnt++;
            print OH3 "$1\n";
            print OH4 "$1\n";
            print OH3 "]\n\n";
            print OH4 "]\n\n";
        } else {
            print OH3 "\tcomponent $second$cnt [\n";
            print OH4 "\tcomponent $second$cnt [\n";
            $cnt++;
            print OH3 "$second\n";
            print OH4 "$second\n";
            print OH3 "]\n\n";
            print OH4 "]\n\n";
        }
    }
    print OH3 "}\n\n";
    print OH4 "}\n\n";
}
foreach my $first (sort keys %SINGLECLASS){
    if($CHECKGROUP{$first} ne ""){ next; }
    print OH3 "component $first$cnt [\n";
    print OH4 "component $first$cnt [\n";
    $cnt++;
    print OH3 "$first\n";
    print OH4 "$first\n";
    print OH3 "]\n\n";
    print OH4 "]\n\n";
}
print OH3 "\@enduml\n";
print OH4 "\@enduml\n";
print OH3 "```\n";
close OH3;
close OH4;

#our %OVLINK;
#our %GROUPCLASS;


