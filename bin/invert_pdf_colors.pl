#!/usr/bin/perl
use strict;
use warnings;
use PDF::API2;
use PDF::API2::Basic::PDF::Utils;


my $num_args = $#ARGV + 1;

if ($num_args != 2) {
		print "\nUsage: ./invert_pdf_colors.pl input.pdf output.pdf\n";
		exit;
}

my $input_pdf = $ARGV[0];
my $output_pdf = $ARGV[1];
$input_pdf =~ tr/\"//d;
$output_pdf =~ tr/\"//d;

print "the pdf  : '$input_pdf'\n";

my $pdf = PDF::API2->open($input_pdf);
for my $n (1..$pdf->pages()) {
    my $p = $pdf->openpage($n);

    $p->{Group} = PDFDict();
    $p->{Group}->{CS} = PDFName('DeviceRGB');
    $p->{Group}->{S} = PDFName('Transparency');

    my $gfx = $p->gfx(1);  # prepend
    $gfx->fillcolor('white');
    $gfx->rect($p->get_mediabox());
    $gfx->fill();

    $gfx = $p->gfx();  # append
    $gfx->egstate($pdf->egstate->blendmode('Difference'));
    $gfx->fillcolor('white');
    $gfx->rect($p->get_mediabox());
    $gfx->fill();
}
$pdf->saveas($output_pdf);

