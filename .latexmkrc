#
# Configure latexmk
#
$pdf_mode = 4;  # generate PDF using lualatex
$bibtex_use = 2;
$postscript_mode = $dvi_mode = 0;
@default_files = ('ekg-mm/ekg-mm.tex');
$do_cd = 1;
$out_dir = '../out';
$aux_dir = '../out';

$ENV{max_print_line} = 2000;
$log_wrap = 2000;
$ENV{error_line} = 254;
$ENV{half_error_line} = 238;
$ENV{openout_any} = 'a';

if (! $ENV{latex_document_customer}) {
    print "AAAA1";
    $ENV{latex_document_customer} = 'ekgf';
}

$ENV{latex_document_mode} = $ENV{latex_document_mode} || 'final';

if("$ENV{latex_document_customer}" eq 'agnos') {
    $document_customer = 'agnos.ai'
} else {
    $document_customer = $ENV{latex_document_customer}
}
print "Document Customer: $document_customer";

if("$ENV{latex_document_mode}" eq'final'){
    $jobname = "$document_customer - %A";
} else {
    $jobname = "$document_customer - %A - $ENV{latex_document_mode}";
}

$pre_tex_code = "\\def\\customerCode{$ENV{latex_document_customer}} \\def\\DocumentClassOptions{$ENV{latex_document_mode}}";

$lualatex = 'lualatex --shell-escape --halt-on-error -file-line-error -pdf --interaction=nonstopmode %O %P';

print "\n\n$lualatex\n\n";

$clean_ext = "aux fls log glsdefs tdo"
