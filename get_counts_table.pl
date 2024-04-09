#!/usr/bin/perl -w
use strict;

my %gene;
open IN,"geneid_genename_gtf_nodupgeneid" or die $!;
while(my $ln = <IN>)
{ 
  chomp $ln;
  my @arr = split("\t", $ln);
  my $gene_name = $arr[1];
  my $gene_id = $arr[0];
  $gene{$gene_id} = $gene_name;
  #print "-$gene_id-$gene_name-\n";
}
close IN;

# 275-12_Plate1_10_S556_R1_001.STAR.ReadsPerGene.out.tab
my %summary;
my @files = <*ReadsPerGene.out.tab>;
foreach my $f(@files)
{
  open IN,"$f" or die $!;
  $f=~/(.*).Reads/;
  my $sample = $1;
  while(my $ln = <IN>)
  {
    my @arr = split(" ",$ln);
    if($gene{$arr[0]})
    {
      $summary{$sample}{$gene{$arr[0]}} = $arr[1];
    }
  }
}


open OUT,">NumReadsMapped_all.txt" or die $!;
print OUT "\t";
foreach my $sam(sort keys %summary)
{
  print OUT "$sam\t";
}
print OUT "\n";

foreach my $g(sort keys %gene)
{
  if(!($gene{$g})){print "-$g-\n";}
  print OUT "$gene{$g}\t";
  foreach my $s(sort keys %summary)
  {
    if(!($summary{$s}{$gene{$g}}))
    {
      print OUT "0\t";
    }  
    else
    {
      print OUT $summary{$s}{$gene{$g}},"\t";
    }
  }
  print OUT "\n"
}

