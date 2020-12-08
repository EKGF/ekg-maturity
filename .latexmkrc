$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
@default_files = ('main.tex');
$latex = 'lualatex --halt-on-error -interaction=nonstopmode -shell-escape %O %S';
$pdflatex = 'pdflatex --halt-on-error -interaction=nonstopmode -shell-escape %O %S';
$lualatex = 'lualatex --halt-on-error -interaction=nonstopmode -shell-escape %O %S';

$clean_ext = "aux fls log glsdefs tdo"

$pdflatex = 'pdflatex --halt-on-error %O %S';
