# .latexmkrc
$pdf_mode = 1;
$bibtex_use = 2; # Use biber instead of bibtex

# Pour les sous-documents avec subfiles
add_cus_dep('tex', 'bbl', 0, 'run_biber');
sub run_biber {
    my ($base_name, $path) = fileparse( $_[0] );
    my $return = system( "biber", "--output-directory=$path/output", "$path$base_name" );
    return $return;
}

# Cleanup
$clean_full_ext = '%R.aux %R.bbl %R.bcf %R.blg %R.fdb_latexmk %R.fls %R.log %R.out %R.run.xml %R.synctex.gz %R.toc %R.lot %R.lof %R.nav %R.snm %R.vrb';