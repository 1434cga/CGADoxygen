# BEGIN {push @INC, '..'}
use lib '.';
use DoxyDocs;

our %init4py;

sub change_special_code {
	my ($s) = @_;
	$s =~ s/\{/#\+#\+#\+\+###/g;
	$s =~ s/\}/#\-#\-#\-\-###/g;
	$s =~ s/\\/#\=#\=#\=\=###/g;
	$s =~ s/\n/#\%#\%#\%\%###/g;
	$s =~ s/\"/#\&#\&#\&\&###/g;
	return $s;
}

sub generate_cc($$) {
	my $str = $_[0];
	my $doc = $_[1];
	my $cnt = 1;

	my $ps = $str;
	$ps =~ s/\{\s*/\[\'/g;
	$ps =~ s/\s*\}/\'\]/g;
	$ps =~ s/^\$//;

	#print "generate_cc $doc\n";
	if($doc =~ /^HASH\(/){
		#print PH "=== $ps\n";
		if($init4py{$ps} eq ""){
			print PH "$ps={}\n";
			$init4py{$ps} = "init";
		}
		#print "HASH " . %{$doc} . "\n";
		foreach $key (keys %{$doc}) {
			if( not ( (${$doc}{$key} =~ /^ARRAY\(/) || (${$doc}{$key} =~ /^HASH\(/) ) ){
				#print "hash $str { $key } = value( ${$doc}{$key} )\n";
				print FH "$str { $key } =  \"" . change_special_code(${$doc}{$key}) . "\"\n";
				print PH "$ps ['$key'] =  \"" . change_special_code(${$doc}{$key}) . "\"\n";
			} else {
				generate_cc("$str { $key }",  ${$doc}{$key});
			}
		}
	} elsif($doc =~ /^ARRAY\(/){
		#print "ARRAY @$doc\n";
		#print PH "=== $ps\n";
		if($init4py{$ps} eq ""){
			print PH "$ps={}\n";
			$init4py{$ps} = "init";
		}
		foreach $key (@{$doc}) {
			#print "array $cnt key( $key )\n";
			#print "array $doc->{$key}\n";
			if( not ( ($key =~ /^ARRAY\(/) || ($key =~ /^HASH\(/) ) ){
				#print "hash $str { $key } = value( ${$doc}{$key} )\n";
				print  "ARRAY $str [ $key ] =  \"" . change_special_code(${$doc}[$key]) . "\"\n";
			} else {
				generate_cc("$str { $cnt }",$key);
				$cnt ++;
			}
		}
	} else {
		print PH ">>> $ps\n";
		#print "DOC $str $doc\n";
		#print "DOC $str @{$doc}\n";
		#print "DOC $str %{$doc}\n";
	}
}


print "arguments count : " . ($#ARGV + 1) . "\n";
($filename) = (@ARGV);
if($filename eq ""){
	$filename = "default.GV";
}
print "input : DoxyDocs.pm , output filename : $filename\n";
print STDERR "input DoxyDocs.pm  output filename = $filename\n";
open(FH, ">",$filename) or die "Can't open < $filename: $!";
open(PH, ">","DB4python.data") or die "Can't open < DB4python.data : $!";
#generate($doxydocs, $doxystructure);
generate_cc("\$D",$doxydocs);

close FH;
