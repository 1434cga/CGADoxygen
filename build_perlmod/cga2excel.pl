#!/usr/bin/perl
use Excel::Writer::XLSX;

our $returnp = "ReTuRnp";

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
		open(LO,">", "./outplantuml/" . $name . "\.excel\.plantuml") or die "Can't open > $name $!";
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
						$myin .= "[in] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "";
						print "myin $myin\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myin .= ": " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>";
								print "myin2 $myin\n";
							}
						}
					}
					elsif($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq "out"){
						$myout .= "[out] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "";
						print "myout $myout\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myout .= ": " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>";
								print "myout2 $myout\n";
							}
						}
					}
					elsif($myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{dir} eq ""){
						$myany .= "[-] " . $myhash->{$tmpKey}{params}{$tmp2}{parameters}{1}{name} . "";
						print "myany $myany\n";
						foreach my $tmp3 (sort_keys(\%{$myhash->{$tmpKey}{params}{$tmp2}{doc}})){
							if("" ne $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content}){
								$myany .= ": " . $myhash->{$tmpKey}{params}{$tmp2}{doc}{$tmp3}{content} . "<br>";
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
				$mystr .= "<br> " . $myhash->{$tmpKey}{retvals}{$tmp2}{parameters}{1}{name} . " : ";
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
		if($mystr ne ""){ $mystr .= $returnp . $myhash->{$tmpKey}{type};}
		else { $mystr = $myhash->{$tmpKey}{type};}
		$mystr .= "    " . $myhash->{$tmpKey}{declaration_name};
		#$mystr .= "<br>";
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
	$mystr .= " | " . getContent(\%{$myhash->{brief}{doc}}) . "";
	#$mystr .= " <br>" . getContent(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . getParameters(\%{$myhash->{parameters}});
	($myin , $myout , $myany) = getParams(\%{$myhash->{detailed}{doc}});
	$mystr .= " | " . $myin . $myany;
	$mystr .= " | " . $myout;
	$mystr .= " | " . $myhash->{type};  # return type of function
	$mystr .= " | " . getReturn(\%{$myhash->{detailed}{doc}}) . " <br>" . getRetvals(\%{$myhash->{detailed}{doc}});
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
	$mystr .= " | " . getContent(\%{$myhash->{brief}{doc}}) . "";
	$mystr .= " <br>" . getContent(\%{$myhash->{detailed}{doc}});
	return $mystr;
}

#printExcel($row++,$worksheet,"| Class | Class ID | Description |");
sub printExcel
{
	my $myrow = shift;
	my $myworksheet = shift;
	my $mystr = shift;
	my $myformat = shift;
	my $mycol = 0;

	$mystr =~ s/^\|//;
	print "printExcel " . $myrow . "  $mystr\n";
	my @mystr =  split('\|',$mystr);
	for (my $i =0 ;$i <= $#mystr ; $i++){
		print "printExcel 1. $#mystr " . $myrow . " : $i : $mystr[$i]\n";
		$mystr[$i] =~ s/^\s*//;
		$mystr[$i] =~ s/^<br>\s*//;
		$mystr[$i] =~ s/^$returnp\s*//;
		$mystr[$i] =~ s/$returnp\s*$//;
		$mystr[$i] =~ s/$returnp/\n/g;
		$mystr[$i] =~ s/<br>\s*$//;
		$mystr[$i] =~ s/<br>/\n/g;
		print "printExcel 2. $#mystr " . $myrow . " : $i : [ $mystr[$i] ]\n";
		$myworksheet->write( $myrow, $i, $mystr[$i], $myformat );
	}
	print "printExcel end\n";
}

print "arguments count : " . ($#ARGV + 1) . "\n";
print @ARGV . "\n";
($infile , $outfile) = (@ARGV);
if($infile eq ""){
	$infile = "default.GV";
}
if($outfile eq ""){
	$outfile = "out.xlsx";
}

print "in : $infile  , Excel out : $outfile\n";
print STDERR "in : $infile  , Excel out : $outfile\n";

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

my $workbook  = Excel::Writer::XLSX->new( $outfile );

my $worksheet = $workbook->add_worksheet('ClassLists');
$row = 0;   # 0
$col = 0;   # A
$worksheet->set_column( 'A:B', 15 );
$worksheet->set_column( 'C:C', 50 );
my $formatTitle = $workbook->add_format( center_across => 1 , size => 20 , bold => 1);
$formatTitle->set_bold();
$formatTitle->set_color('blue');
$formatTitle->set_align('left');
my $formatHeader = $workbook->add_format( bg_color => 'gray', border => 1 );
my $formatBorder = $workbook->add_format( border => 1 , pattern => 0 , align => 'top');




# Only one cell should contain text, the others should be blank.
$worksheet->write( $row, 0, "Class Lists", $formatTitle );
$worksheet->write_blank( $row, 1, $formatTitle );
$worksheet->write_blank( $row, 2, $formatTitle );
$row++;
# :527,.s/printdox(./printExcel($row,$worksheet/g
printExcel($row++,$worksheet,"| Class | Class ID | Description |", $formatHeader);
#printExcel($row++,$worksheet,"|-------|----------|-------------|");
foreach my $classes (sort_keys(\%{$D{classes}})){
	printExcel($row++,$worksheet,"| " . $D{classes}{$classes}{name} . "| " . $D{classes}{$classes}{name} . "| "
		. getContent( \%{$D{classes}{$classes}{brief}{doc}})
		. "$returnp"
		. getContent( \%{$D{classes}{$classes}{detailed}{doc}}) , $formatBorder);
}


$worksheet = $workbook->add_worksheet('ClassFunctions');
$row = 0;
foreach my $classes (sort_keys(\%{$D{classes}})){
	printExcel($row++,$worksheet,"Function Lists of " . $D{classes}{$classes}{name},$formatTitle);
	printExcel($row++,$worksheet,"| Accessibility | Function | Description | Parameters | param input | param output | Returns | return Description |",$formatHeader);
	#printExcel($row,$worksheet,"|-------|-------|----------|-------------|-------|-----|----|-------|");
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /_methods$/){
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				printExcel($row++,$worksheet,getMethodsRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) ,$formatBorder);
			}
		}
	}
	$row += 3;
}

$worksheet = $workbook->add_worksheet('ClassVariables');
$row = 0;
foreach my $classes (sort_keys(\%{$D{classes}})){
	printExcel($row++,$worksheet,"Variable Lists of " . $D{classes}{$classes}{name},$formatTitle);
	printExcel($row++,$worksheet,"| Accessability | Variable Name | Type |  Description |",$formatHeader);
	#printExcel($row++,$worksheet,"|-------|-------|----------|-------------|");
	foreach my $accesstype (sort_keys(\%{$D{classes}{$classes}}, "~")){
		if($accesstype =~ /_members$/){
			foreach my $members (sort_keys(\%{$D{classes}{$classes}{$accesstype}{members}})){
				printExcel($row++,$worksheet,getMembersRow($accesstype,\%{$D{classes}{$classes}{$accesstype}{members}{$members}}) ,$formatBorder);
			}
		}
	}
	$row += 3;
}

$worksheet = $workbook->add_worksheet('FileFunctions');
$row = 0;
printExcel($row++,$worksheet,"Function Lists of Files",$formatTitle);
printExcel($row++,$worksheet,"| FileName | Function | Description | Parameters | param input | param output | Returns | return Description |",$formatHeader);
#printExcel($row++,$worksheet,"|-------|-------|----------|-------------|-------|-----|----|-------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.h$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{functions}{members}})){
		printExcel($row++,$worksheet,getMethodsRow($D{files}{$files}{name},\%{$D{files}{$files}{functions}{members}{$members}}) ,$formatBorder);
	}
}
$row += 3;

$worksheet = $workbook->add_worksheet('FileVariables');
$row = 0;
printExcel($row++,$worksheet,"Variable Lists",$formatTitle);
printExcel($row++,$worksheet,"| FileName | Variable Name | Type |  Description |",$formatHeader);
#printExcel($row++,$worksheet,"|-------|-------|----------|-------------|");
foreach my $files (sort_keys(\%{$D{files}})){
	#if( not ($D{files}{$files}{name} =~ /\.c[pp|c]$/) ){ next; }

	foreach my $members (sort_keys(\%{$D{files}{$files}{variables}{members}})){
		printExcel($row++,$worksheet,getMembersRow($D{files}{$files}{name},\%{$D{files}{$files}{variables}{members}{$members}}) ,$formatBorder);
	}
}
$row += 3;

$workbook->close();
exit;

