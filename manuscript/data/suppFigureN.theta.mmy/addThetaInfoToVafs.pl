#!/usr/bin/perl

use warnings;
use strict;
use IO::File;
use POSIX;

my $output;
open($output,">data/mmy.snv.vafs.cn");

#read in vafs, store metrics, output as is
my $depth = 0;
my $snvcount = 0;

my $inFh = IO::File->new( "data/mmy.snv.vafs" ) || die "can't open file\n";
while( my $line = $inFh->getline )
{
    chomp($line);
    next if $line =~ /^chr/;
    my @F = split(/\t/, $line);
    
    $depth = $depth + $F[2] + $F[3];
    $snvcount++;

    print $output $line . "\n";
}
close($inFh);
$depth = ceil($depth/$snvcount);
print STDERR "average depth: $depth\n";

#read in CN segments, store lengths
my @lengths;
$inFh = IO::File->new( "data/theta.withBounds" ) || die "can't open file\n";
while( my $line = $inFh->getline )
{
    chomp($line);
    my @F = split(/\t/, $line);
    next if $line =~ /^#/;
    push(@lengths, $F[3]-$F[2]);
}
close($inFh);


#read in theta results, output CN vafs
$inFh = IO::File->new( "data/theta.results" ) || die "can't open file\n";
my $found = 0;
while( my $line = $inFh->getline )
{
    chomp($line);
    
    next if $line =~ /^#/; #skip header
    next if $found; #only consider first (best) line

    $found = 1;
    my ($nll, $mu, $assignment, $prob) = split("\t",$line);
    my @fracs = split(/,/, $mu);
    my @cnstrings = split(/:/,$assignment);

    my $pos=0;
    my $j;
    for($j=0; $j<@cnstrings; $j++){
        my @cns = split(",", $cnstrings[$j]);

        #does this segment have multiple clonal CNs or are they all the same?
        #TODO - this doesn't work for more than two clones
        my $founding = 1;
        my $thiscn = $cns[0];
        my $i;
        for($i=1; $i<@cns; $i++){
            if($cns[$i] != $thiscn){
                $founding = 0;
            }
        }

        #how many SNVs does this segment get (based on mutation rate, minimum 1)
        my $snvs = ceil(($lengths[$j]/3200000000) * $snvcount);

        unless($founding){
            my $i;
            for($i=0; $i<@cns; $i++){
                unless($cns[$i] == 2){
                    my $numreads = $depth;
                    # add some jitter (~10%) for nice plotting
                    # $numreads = $numreads + rand(ceil($numreads * 0.10));
                
                    #my $frac = (($fracs[$i]/2))-0.04;
                    my $frac = ($fracs[$i+1]/2);
                    my $varreads = ceil($numreads * $frac);
                    my $refreads = ceil($numreads * (1-$frac));
                    my $vaf = $frac*100;
                    my $k;

                    for($k=0; $k<$snvs; $k++){
                        print $output join("\t",("CN", $pos, $refreads, $varreads, $vaf)) . "\n";
                        $pos++;
                    }
                }
            }
        }
    }
}
close($inFh);
