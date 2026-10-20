# Enable Biber for biblatex (2 = use Biber)
$bibtex_use = 2;

# Auto-cleanup: Tell latexmk which extra files to remove on \lc / -c
push @generated_exts, "synctex(busy)";
push @generated_exts, "synctex.gz";
push @generated_exts, "run.xml";
push @generated_exts, "bbl";
push @generated_exts, "loc";
push @generated_exts, "soc";
push @generated_exts, "bcf-SAVE-ERROR";
push @generated_exts, "bbl-SAVE-ERROR";
push @generated_exts, "fls";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
