$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
@default_files = ('ekg-mm/ekg-mm.tex');
$do_cd = 1;
$pre_tex_code = '\def\customerCode{agnos} \def\DocumentClassOptions{final}';
$lualatex = 'lualatex --shell-escape --halt-on-error --interaction=nonstopmode %O %P';

$clean_ext = "aux fls log glsdefs tdo"
