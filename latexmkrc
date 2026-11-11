# latexmk configuration for slimthesis: compile with
#     latexmk main
# (with LuaLaTeX; for XeLaTeX use $pdf_mode = 5; biber runs automatically)

$pdf_mode = 4;          # PDF output through LuaLaTeX
$lualatex = 'lualatex -interaction=nonstopmode -file-line-error -synctex=1 %O %S';
$bibtex_use = 2;        # run biber when needed, delete its .bbl on cleanup

# extra files removed by "latexmk -c"
$clean_ext = 'lof lot loa run.xml bbl synctex.gz xmpi xmpdata';
