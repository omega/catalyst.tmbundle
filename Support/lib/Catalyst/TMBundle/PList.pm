package Catalyst::TMBundle::PList;

use strict;
use Catalyst::TMBundle::XML;

use vars qw/@ISA @EXPORT_OK/;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(parse);

use Data::Dump qw/dump/;

sub parse {
    my $doc = Catalyst::TMBundle::XML::parse(@_);
    
    my @plist;
    
    foreach my $n (@$doc) {
        # We skip the outermost layer (<plist>);
        push(@plist, _parse_node($_)) foreach @{$n->{content}};
    }
    my %plist = @plist;
    return \%plist;
}

sub _parse_node {
    my ($node) = @_;
    if ($node->{type} eq 't') {
        # this is a text-node, return the text?
        return $node->{content};
    }
    if (scalar(@{ $node->{content} }) == 1) {
        # We have only one subnode, so we can short it out
        return ($node->{name}, _parse_node($node->{content}-[0]));
    }
    
    if ($node->{name} eq 'dict') {
        # we are a dict, so we want to return 
        return ($node->{name}, _parse_dict($node->{content}));
    }
}

sub _parse_dict {
    my ($dict) = @_;
    
    my @key_values;
    
    foreach my $n (@$dict) {
        if ($n->{name} eq 'key' or $n->{name} eq 'string') {
            push(@key_values, _parse_node($n->{content}->[0]));
        } elsif ($n->{name} eq 'dict') {
            push(@key_values, _parse_dict($n->{content}));
        }
    }
    my %dict = @key_values;
    return \%dict;
}
1;