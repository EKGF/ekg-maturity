#
# Configure latexmk
#
# Looks at the following environment variables:
#
# - latex_document_main: the root directory of the document or the full file name of its main doc
# - latex_customer_code: customer code such as "agnos" or "ekgf"
# - latex_document_mode: "draft" or "final"
# - latex_document_members_only: "yes" or "no"
#
use File::Basename;
use experimental 'smartmatch';
$pdf_mode = 4;  # generate PDF using lualatex
$bibtex_use = 2;
$postscript_mode = $dvi_mode = 0;
#
# Specify which PDF viewer you want to use (Skim is the best one on a Mac)
#
$pdf_previewer = 'open -a Skim';

sub findMainDoc() {
    my $documentName = 'content';
    my $mainDocFileName = '${document_name}/main.tex';

    if($ENV{latex_document_main}) {
        $mainDocFileName = $ENV{latex_document_main};
        # If the env var latex_document_main happens to be just the directory name of the
        # document's content root then assume that the main file in that root has the same name
        if (-d $mainDocFileName) {
            $documentName = $mainDocFileName;
            $mainDocFileName = $mainDocFileName . '/' . ${mainDocFileName} . '.tex';
        } elsif (-f $mainDocFileName) {
            my @array = split /\//, $mainDocFileName, 2;
            $documentName = $array[0];
        }
    }

    if (! -e $mainDocFileName) {
        die "${mainDocFileName} does not exist"
    }
    $ENV{latex_document_main} = $mainDocFileName;
    @default_files = ($mainDocFileName);

    print "Main document file name: ${mainDocFileName}\n";
    print "Main document name: ${document_name}\n";

    return ($mainDocFileName, $documentName);
}

sub getCustomerCode() {

    my $defaultCustomerCode = 'ekgf';

    # If this runs in a Github Actions workflow then we can derive the best
    # default customer code from the repository name by taking the organization code.
    if ($ENV{GITHUB_REPOSITORY}) {
        $defaultCustomerCode = split /\//, $defaultCustomerCode, 2;
    } else {
        my $gitRemoteUrl = `git remote get-url origin`;
        if ( $? == -1 ) {
            print "git not in path\n";
        } else {
            my @array = split /[:,\/]+/, $gitRemoteUrl;
            $defaultCustomerCode = $array[-2];
        }
    }
    if (! $ENV{latex_customer_code}) {
        $ENV{latex_customer_code} = $defaultCustomerCode;
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
    print "Document Customer Code: ${document_customer}\n";
    print "Document Short Customer Code: ${document_customer_code_short}\n";

    return ($document_customer, $document_customer_code_short);
}

sub tchomp {
    my $text = shift;

    # Matching with the hex values for the various line separators
    $text =~ s/^(.*?)(?:\x0D\x0A|\x0A|\x0D|\x0C|\x{2028}|\x{2029})/$1/s;
    return $text;
}

#
# Process the VERSION file in the main content directory of the repo and if not found then check the root directory
# of the repo. It should be a one-line file with the major and minor version number separated by a dot.
# This code then adds the Github Actions run number to it (taken from the environment variable GITHUB_RUN_NUMBER) or
# if you run latexmk locally it uses your user id.
#
sub readVersion {
    my $versionFileName = "./${document_name}/VERSION";
    if (-s $versionFileName) {
        $mainDocFileName = $document_name;
    } else {
        print "Could not find ${versionFileName}, so using ./VERSION\n";
        $versionFileName = 'VERSION';
    }
    open my $versionFileHandle, '<', $versionFileName or die "Failed to open ${versionFileName}: $!\n";
    my ($version, @lines) = <$versionFileHandle>;
    close $versionFileHandle or die "Failed to close ${versionFileName}: $!\n";
    $version = tchomp($version);
    $version = tchomp($version);
    return $version;
}

sub getCurrentBranchName() {
    my $branchName = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`;
    if ( $? == -1 ) {
        print "git not in path, can't determine branch name\n";
        return '';
    }
    $branchName = tchomp($branchName);
    print "Git Branch: ${branchName}\n";
    return ${branchName};
}

sub getVersionSuffix() {
    my $suffix = '';
    if (! $ENV{GITHUB_RUN_NUMBER}) {
        $suffix = "${suffix}.$ENV{USER}";
    } else {
        $suffix = "${suffix}.$ENV{GITHUB_RUN_NUMBER}";
    }
    my $branchName = getCurrentBranchName();
    if ($branchName ~~ ['main', 'master']) {
        print "No git branch name in the name of the generated PDF file because we're on ${branchName}\n";
    } elsif ($branchName eq '') {
        ;
    } else {
        $suffix = "${suffix}-${branchName}";
    }
    return ${suffix};
}

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

($mainDocFileName, $document_name) = findMainDoc();

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

# print "clean ext: ${clean_ext}\n";

($document_customer_code, $document_customer_code_short) = getCustomerCode();

#
# Can't use spaces or dots in the file names unfortunately, tools like makeglossaries do not support it
#
if("$ENV{latex_document_mode}" eq 'final') {
    $jobname = "${document_customer_code}-${document_name}";
} else {
    $jobname = "${document_customer_code}-${document_name}-$ENV{latex_document_mode}";
}
# 
# Remove duplicate customer codes
# 
$jobname =~ s/${document_customer_code}-${document_customer_code}/${document_customer_code}/g ;
$jobname =~ s/-${document_customer_code}-/-/g ;

$latex_document_version = readVersion();
$latex_document_version_suffix = getVersionSuffix();
$latex_document_version = "${latex_document_version}${latex_document_version_suffix}";
$versionWithDashes = $latex_document_version;
$versionWithDashes =~ tr/./-/s;
print "Document Version: $latex_document_version...\n";

$pre_tex_code = "${pre_tex_code}\\def\\documentName{$document_name}";
$pre_tex_code = "${pre_tex_code}\\def\\customerCode{$document_customer_code}";
$pre_tex_code = "${pre_tex_code}\\def\\documentVersion{$latex_document_version}";
$pre_tex_code = "${pre_tex_code}\\def\\DocumentClassOptions{$ENV{latex_document_mode}}";

if($ENV{latex_document_members_only} and "$ENV{latex_document_members_only}" eq 'yes') {
    $jobname = "${jobname}-members-only-${latex_document_version}";
    $pre_tex_code = "${pre_tex_code}\\def\\membersOnly{yes} "
} else {
    $jobname = "${jobname}-${latex_document_version}";
    $pre_tex_code = "${pre_tex_code}\\def\\membersOnly{no} "
}
#
# Remove all dots from the latex job name since utilities like makeindex cannot handle them
# well.
#
$jobname =~ tr/./-/s;

print "Job name: ${jobname}\n";
print "pre_tex_code: ${pre_tex_code}\n";

$lualatex = 'lualatex --synctex=1 --output-format=pdf --shell-escape --halt-on-error -file-line-error --interaction=nonstopmode %O %P';

@generated_exts = (@generated_exts, 'synctex.gz');

print "\n\n$lualatex\n\n";

# exit;
