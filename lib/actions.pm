#!/usr/bin/perl

# package actions;
# JSON's neat so keep the full content
# todo params format: action, content, package name, method

use strict;
use POSIX qw(strftime);
use JSON;
use Data::Dumper;
use lib '/srv/restful/lib';
use err;
use u;
require run;

my $err = new err;
my $ret	= undef;

sub xml_act {
    my $content = shift;
    my $action	= shift; 
    my $debug	= shift; 

    logit( sprintf "Content length: %s", length $content ); 

    if ($action =~ /xml/i) {
	# another way to call the assigned plugin
	# todo params format: action, content, package name, method
	$ret = todo( $action, $content, "go", "gen" );
    } else {
	$ret = todo( $action );
    }

    return $ret;
}

sub json_act {
    my $content = shift;
    my $action	= shift || 'auto'; 
    my $debug	= shift; 

    logit "Content: ".$content; 

    $ret = todo( $action, $content );

    return $ret;
}

sub text_act {
    my $content = shift;
    my $action	= shift; 
    my $debug	= shift; 

    logit( sprintf "Content length: %s", length $content ); 

    my %h = split /[=&]/, $content; 
    $ret = join "&", map { "$_=". $h{"$_"} } keys %h;

    return $ret;
}

1;
