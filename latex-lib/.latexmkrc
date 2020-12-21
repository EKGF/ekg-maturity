#
# Configure latexmk
#
$pdf_mode = 4;  # generate PDF using lualatex
$bibtex_use = 2;
$postscript_mode = $dvi_mode = 0;
@default_files = ('content/main.tex');
$do_cd = 1;
$out_dir = '../out';
$aux_dir = '../out';
$tmpdir  = '../out';
$force_mode = 1 ;
# turn recorder option on (.fls file generated)
$recorder = 1;

# Run latexmk silently, not output to text
$ENV{'SILENT'} //= 0;
$silent     = $ENV{'SILENT'};
$quiet      = $ENV{'SILENT'};

$ENV{max_print_line} = 2000;
$log_wrap = 2000;
$ENV{error_line} = 254;
$ENV{half_error_line} = 238;
$ENV{openout_any} = 'a';

sub makeglossaries ($$$) {
  my ($base_name, $path) = fileparse( $_[0] );
  my $from_ext = $_[1];
  my $to_ext = $_[2];
  print "from ${from_ext} to ${to_ext}\n";
  my @args = ();
  pushd $path;
  if ( $silent ) {
    @args = ('makeglossaries', '-q', "$base_name");
  } else {
    @args = ("makeglossaries", "$base_name");
  };
  print "@args\n";
  system(@args);
  my $return = $?;
  popd;
  return $return;
}

sub acn2acr {
    makeglossaries($_[0], 'acn', 'acr');
}

sub glo2gls {
    makeglossaries($_[0], 'glo', 'gls');
}

#sub tld2tdn {
#    makeglossaries($_[0], 'tld', 'tdn');
#}

#sub old2odn {
#    makeglossaries($_[0], 'old', 'odn');
#}

add_cus_dep( 'acn', 'acr', 0, 'acn2acr' );
$clean_ext .= " acn acr";
push @generated_exts, 'acr';

add_cus_dep( 'glo', 'gls', 0, 'glo2gls' );
$clean_ext .= " glo gls";

add_cus_dep( 'tld', 'tdn', 0, 'tld2tdn' ); # search for glossary-business
$clean_ext .= " tld tds";

add_cus_dep( 'old', 'odn', 0, 'old2odn' ); # search for glossary-ontologies
$clean_ext .= " old odn";

$clean_ext .= " alg glg";
$clean_ext .= " aux fls log glsdefs tdo";

print "clean ext: ${clean_ext}\n";

if (! $ENV{latex_document_customer}) {
    $ENV{latex_document_customer} = 'ekgf';
}

$ENV{latex_document_mode} = $ENV{latex_document_mode} || 'final';

if("$ENV{latex_document_customer}" eq 'agnos') {
    $ENV{latex_document_customer} = 'agnos-ai'
}

if("$ENV{latex_document_customer}" eq 'agnos-ai') {
    $document_customer = 'agnos-ai';
    $document_customer_code_short = 'agnos';
} else {
    $document_customer = $ENV{latex_document_customer};
    $document_customer_code_short = ${document_customer};
}
print "Document Customer: $document_customer\n";

#
# Can't use spaces or dots in the file names unfortunately, tools like makeglossaries do not support it
#
if("$ENV{latex_document_mode}" eq 'final') {
    $jobname = "$document_customer-%A";
} else {
    $jobname = "$document_customer-%A-$ENV{latex_document_mode}";
}

$versionFileName = 'VERSION';
if(! open($versionFileHandle, '<:encoding(UTF-8)', $versionFileName)) {
    warn "Could not open ${versionFileName} file";
    exit;
}
$version = <$versionFileHandle>;
chomp($version);
if (! $ENV{GITHUB_RUN_NUMBER}) {
    $version .= ".$ENV{USER}";
} else {
    $version .= ".$ENV{GITHUB_RUN_NUMBER}";
}
print "Version $version\n";
$jobname = "${jobname}-${version}";

print "Job name: ${jobname}\n";
exit;

$pre_tex_code = "\\def\\customerCode{$ENV{latex_document_customer}} \\def\\DocumentClassOptions{$ENV{latex_document_mode}}";

if("$ENV{latex_document_members_only}" eq 'yes') {
    $jobname = "${jobname}-members-only";
    $pre_tex_code = "${pre_tex_code} \\def\\membersOnly{yes}"
} else {
    $pre_tex_code = "${pre_tex_code} \\def\\membersOnly{no}"
}

$lualatex = 'lualatex --output-format=pdf --shell-escape --halt-on-error -file-line-error --interaction=nonstopmode %O %P';

print "\n\n$lualatex\n\n";


