#!/usr/bin/perl
# package Server;

use strict;
use HTTP::Status;
use HTTP::Response;
use HTTP::Headers;
use Data::Dumper;
use JSON;
use XML::Simple qw(:strict);	# replace this module if paring XML becomes complicated
use lib '/srv/restful/lib';
use err;
use u;

use constant USER_HEADER    => 'AUTH-USER';
use constant PASS_HEADER    => 'AUTH-PASS';
use constant TYPE_HEADER    => 'Content-Type';
use constant TRAN_HEADER    => 'Transaction';

require actions; # add actions here
my $err = new err;
my $ACTION;
my $CONTYPE;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my %c = @_;
    map { $self->{lc($_)} = $c{$_} } keys %c;
    return $self;
}

sub _init {
    my $r = shift;
    my $IP = shift;
    my %h = $r->uri->query_form();
    my $who  = $r->header(USER_HEADER) || $r->header(PASS_HEADER) ? 
	       $r->header(USER_HEADER).':'.$r->header(PASS_HEADER) : 'web';
    my $ip   = $h{ip} || $IP || 'unknown';
    $ACTION  = $r->header(TRAN_HEADER) || $h{act} || $h{action};
    $CONTYPE = $r->header(TYPE_HEADER) || 'application/json';
    my $action = $ACTION ? $ACTION : "(default)";

    logit "-------- $who".'@'."$ip --------";
    logit "Type: $CONTYPE, Action: $action, Method: ".$r->method;

    delete $h{_};
    delete $h{ip};
    delete $h{act};

    $params = $ACTION =~ /nbn-search/i ? _filter_hash(\%h) : \%h;
    return $CONTYPE;
}

sub _success {
    my $h = shift;
    my $return = shift;
    my $msg = 'Success';
    my $res = HTTP::Response->new( RC_OK, $msg, $h, $return);
    return $res;
}
sub _error {
    my $h = shift;
    my $error = shift;
    my $msg = 'Error found';
    my $res = HTTP::Response->new( RC_OK, $msg, $h, $error );
    $err->clean;
    return $res;
}

sub _res {
    my $type = shift;
    my $content = shift;
    my $h = $params;
    my $res;

    if ($type =~ /json/i) {
	if (_from_json($content)) {
	    $res = _request( $content );
	} else {
	    $res = _request( to_json($h) );
	}
    } else {
	$res = _request( $content );
    }

    return $res;
}

sub _response {
    my $return = shift;
    my $hh = HTTP::Headers->new;
    # add the request headers
    $hh->header('Content-Type' => "$CONTYPE; charset=utf-8");
    $hh->header('Access-Control-Allow-Origin' => '*');

    my $res;
    if ($err->get) {
	logit("Error: ".$err->errstr);
	if ($CONTYPE =~ /json/i) {
	    $res = _error $hh, encode_json({'error' => $err->errstr});
	} elsif ($CONTYPE =~ /xml/i) {
	    $res = _error $hh, XMLout({'error' => $err->errstr}, KeyAttr => []);
	} elsif ($CONTYPE =~ /text/i) {
	    $res = _error $hh, "error = $err->errstr";
	}
    } else {
	$res =  _success $hh, $return;
    }
    return $res;
}

sub _actions {
    my $content = shift;
    return 
	$CONTYPE =~ /json/i ? json_act($content, $ACTION)   :
	$CONTYPE =~ /xml/i  ? xml_act($content,$ACTION)	    :
	$CONTYPE =~ /text/i ? text_act($content, $ACTION)   : 
	$err->set('unknown data format - '.$CONTYPE);
}

sub _request {
    my $content = shift; 
    my $result = _actions $content;
    return _response $result;
}

1;
