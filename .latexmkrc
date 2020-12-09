$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
@default_files = ('ekg-mm/ekg-mm.tex');
$do_cd = 1;

$ENV{max_print_line} = 2000;
$log_wrap = 2000;
$ENV{error_line} = 254;
$ENV{half_error_line} = 238;
$ENV{latex_document_customer} = $ENV{latex_document_customer} || 'ekgf';
$ENV{latex_document_mode} = $ENV{latex_document_mode} || 'final';

$pre_tex_code = "\\def\\customerCode{$ENV{latex_document_customer}} \\def\\DocumentClassOptions{$ENV{latex_document_mode}}";

$lualatex = 'lualatex --shell-escape --halt-on-error --interaction=nonstopmode %O %P';

$clean_ext = "aux fls log glsdefs tdo"
