package Catalyst::TMBundle::XML;


use vars qw/@ISA @EXPORT_OK/;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(parse);

use XML::Tiny qw/parsefile/;

sub parse {
    my ($xml) = @_;
    $xml =~ s/\n//g;
    return parsefile("_TINY_XML_STRING_$xml");
}

1;
