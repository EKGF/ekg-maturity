#
# Configure latexmk
#
$pdf_mode = 4;  # generate PDF using lualatex
$bibtex_use = 2;
$postscript_mode = $dvi_mode = 0;

#
# If the Github Actions workflow defined an environment variable called REPOSITORY_NAME
# then use that environment variable as the repository name. Otherwise take the base
# name of the current directory.
#
if(! $ENV{REPOSITORY_NAME}) {
    $repoName = basename(getcwd);
} else {
    $repoName = $ENV{REPOSITORY_NAME};
}
print "Repository name: ${repoName}";

if(! $ENV{latex_document_main}) {
    @default_files = ('content/main.tex');
} else {
    @default_files = ($ENV{latex_document_main});
}
foreach (@default_files) {
  print "Main file: $_\n";
}

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

if (! $ENV{latex_customer_code}) {
    $ENV{latex_customer_code} = 'ekgf';
}

$ENV{latex_document_mode} = $ENV{latex_document_mode} || 'final';

if("$ENV{latex_customer_code}" eq 'agnos') {
    $ENV{latex_customer_code} = 'agnos-ai'
}

if("$ENV{latex_customer_code}" eq 'agnos-ai') {
    $document_customer = 'agnos-ai';
    $document_customer_code_short = 'agnos';
} else {
    $document_customer = $ENV{latex_customer_code};
    $document_customer_code_short = ${document_customer};
}
print "Document Customer: $document_customer\n";

#
# Can't use spaces or dots in the file names unfortunately, tools like makeglossaries do not support it
#
if("$ENV{latex_document_mode}" eq 'final') {
    $jobname = "$document_customer-${repoName}";
} else {
    $jobname = "$document_customer-${repoName}-$ENV{latex_document_mode}";
}

#
# Process the VERSION file in the root directory of the repo. It should be a one-line file with the
# major and minor version number separated by a dot. This code then adds the Github Actions run number
# to it (taken from the environment variable GITHUB_RUN_NUMBER) or if you run latexmk locally it uses
# your user id.
#
$versionFileName = 'VERSION';
if(! open($versionFileHandle, '<:encoding(UTF-8)', $versionFileName)) {
    warn "Could not open ${versionFileName} file";
    exit;
}
$latex_document_version = <$versionFileHandle>;
chop($latex_document_version);
# Create a var with the version number where dots are replaced with dashes because some LaTeX tools such
# as makeindex do not work properly when there are dots in the job name.
$versionWithDashes = $latex_document_version;
$versionWithDashes =~ tr/./-/;

if (! $ENV{GITHUB_RUN_NUMBER}) {
    $latex_document_version = "${latex_document_version}.$ENV{USER}";
    $versionWithDashes = "${versionWithDashes}-$ENV{USER}";
} else {
    $latex_document_version = "${latex_document_version}.$ENV{GITHUB_RUN_NUMBER}";
    $versionWithDashes = "${versionWithDashes}-$ENV{GITHUB_RUN_NUMBER}";
}
print "Document Version: $latex_document_version\n";

$pre_tex_code = "${pre_tex_code}\\def\\customerCode{$ENV{latex_customer_code}}";
$pre_tex_code = "${pre_tex_code}\\def\\documentVersion{$latex_document_version}";
$pre_tex_code = "${pre_tex_code}\\def\\DocumentClassOptions{$ENV{latex_document_mode}}";

if($ENV{latex_document_members_only} and "$ENV{latex_document_members_only}" eq 'yes') {
    $jobname = "${jobname}-members-only";
    $jobname = "${jobname}-${versionWithDashes}";
    $pre_tex_code = "${pre_tex_code}\\def\\membersOnly{yes} "
} else {
    $jobname = "${jobname}-${versionWithDashes}";
    $pre_tex_code = "${pre_tex_code}\\def\\membersOnly{no} "
}

print "Job name: ${jobname}\n";
print "pre_tex_code: ${pre_tex_code}\n";

$lualatex = 'lualatex --output-format=pdf --shell-escape --halt-on-error -file-line-error --interaction=nonstopmode %O %P';

print "\n\n$lualatex\n\n";


