package Catalyst::TMBundle;

use strict;
use warnings;

use Catalyst::TMBundle::PList qw/parse/;
use Data::Dump qw/dump/;

use lib '/Users/andremar/Projects/Other/catalyst-devel-1.10-trunk/lib';

use Catalyst::Helper;

use vars qw/@ISA @EXPORT_OK %EXPORT_TAGS/;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(create_view _get_app_name);
%EXPORT_TAGS = (
    cmds => [qw()], 
    test => [qw(_get_app_name)], 
);

sub create {
    
    my $args = {};
    
    # if the first argument is a ref, we take it as our arguments
    if (ref $_[0]) {
        $args = shift;
    }
    
    
    my $helper = Catalyst::Helper->new( { 
        '.newfiles' => 1, 
        mech => 1, 
    });
    $helper->{base} = $ENV{TM_PROJECT_DIRECTORY},
    
    # TODO: Catch output on STDOUT and mangle it?
    my $ret = $helper->mk_component( _get_app_name(), @_);
    error("could not create component") unless $ret;
    rescan_project();
}
sub create_view {
    
    my $res = show_dialog('create_view.nib');
    warn "res: " . dump($res);
    
    create('view', $res->{returnArgument}, $res->{helper});
}
sub show_dialog {
    my ($nib, $user_defaults) = @_;
    
    my $real_nib = $ENV{TM_BUNDLE_SUPPORT} . '/dialogs/' . $nib;
    error("no such nib: $real_nib") unless -e $real_nib;
    my $cmd = $ENV{DIALOG}  
        . " -d '{Catalyst_create_force = 0; Catalyst_create_mech = 1;}' -mp '{}' '" 
        . $real_nib . "'";
        
    # create a plist of user_defaults
    my $res = `$cmd`;
    my $plist = parse($res);
    
    return $plist->{dict}->{result};
}

sub _get_app_name {
    
    open (my $in, "<", $ENV{TM_PROJECT_DIRECTORY} . "/Makefile.PL")
        or die "cannot read " . $ENV{TM_PROJECT_DIRECTORY} . "/Makefile.PL  :: $!";
    my @makefile = $in->getlines;
    close($in);
    my ($name) = map {  /^name '(.*?)'/; $1 } 
        grep { /^name/ }  @makefile;
    
    return $name;
}

sub error {
    my ($err) = @_;
    print "err: $err";
    exit_show_tool_tip();
}
sub exit_discard {
    exit 200;
}
sub exit_replace_text {
    exit 201;
}
sub exit_replace_document {
    exit 202;
}
sub exit_insert_text {
    exit 203;
}

sub exit_show_tool_tip {
    exit 206;
}

sub rescan_project {
    `osascript &>/dev/null -e 'tell app "SystemUIServer" to activate' -e 'tell app "TextMate" to activate' &`
}
1;

=pod

# an abstract way to change the output option of the running command
exit_discard ()                                 { echo -n "$1"; exit 200; }
exit_replace_text ()                            { echo -n "$1"; exit 201; }
exit_replace_document ()                { echo -n "$1"; exit 202; }
exit_insert_text ()                             { echo -n "$1"; exit 203; }
exit_insert_snippet ()                  { echo -n "$1"; exit 204; }
exit_show_html ()                                       { echo -n "$1"; exit 205; }
exit_show_tool_tip ()                   { echo -n "$1"; exit 206; }
exit_create_new_document ()     { echo -n "$1"; exit 207; }

# force TM to refresh current file and project drawer
rescan_project () {
        osascript &>/dev/null \
           -e 'tell app "SystemUIServer" to activate' \
           -e 'tell app "TextMate" to activate' &
}

=cut


