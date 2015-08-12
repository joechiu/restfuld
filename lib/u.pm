#!/usr/bin/perl
package u;

=head1
u.pm
A common tools for RESTful server
	   logit: generate RESTful logs to /tmp/restful-yyyymmdd.log
      _from_json: evaluated from_json and generate ref from json 
	_to_json: evaluated from_json and generate ref to json 
       _validate: validated params with a formatted pattern of ref
    _filter_hash: demolish empty keys in a hash
=cut

use strict;
use Data::Dumper;
use POSIX qw(strftime);
use Time::HiRes qw/gettimeofday tv_interval/;
use IO::File;
use JSON;
use err;
use vars qw/ 
    @ISA
    @EXPORT
    $plugins
    $log
/;
require Exporter;
@ISA = qw/ Exporter /;
@EXPORT = qw/
    logit
    _from_json
    _to_json
    _v
    _validate
    _filter_hash
    _gettime
    _timediff
    $log
/;

my $err = new err;

sub logit {
    my $msg = shift;
    my $prefix = shift || $log || 'restful';
    $msg =~ s/\n+$//g;
    my $path = '/tmp';
    my $now = strftime("%H:%M:%S", localtime);
    my $today = strftime("%Y%m%d", localtime);
    my $file = $prefix.'-'.$today;
    $msg = substr($msg, 0, 120);
    my $log = "[$now $$]\t$msg\n";
    my $logfile = "$path/$file.log";
    my $fh = new IO::File;
    $fh->open(">> $logfile");
    print STDERR $log;
    print $fh $log;
}

sub _from_json {
    my $val = shift;
    $val || return undef;
    # check json compatibility
    eval {
	$val = from_json($val);
    };
    if ($@) {
	return undef;
    } else {
	return $val;
    }
}

sub _to_json {
    my $val = shift;
    $val || return undef;
    eval {
	$val = to_json($val);
    };
    if ($@) {
	return undef;
    } else {
	return $val;
    }
}

sub _validate {
    my $h = shift;
    my $ref = shift;
    foreach my $r (@$ref) {
        foreach my $k (keys %$r) {
            if ( $h->{$k} !~ /$r->{$k}->{r}/ ) {
                return $err->set($r->{$k}->{m}); 
            }
        }
    }
    0;
}

sub _v {
    my $h = shift;
    my $ref = shift;
    foreach my $r (@$ref) {
        foreach my $k (keys %$r) {
            if ( $h->{$k} !~ /$r->{$k}->{r}/ ) {
                return $r->{$k}->{m}; 
            }
        }
    }
    0;
}

sub _filter_hash {
    my $h = shift;    
    foreach my $k (keys %$h) {
	my $val = $h->{$k};
	$val =~ s/\s*|\s+//g;
	if (!$val) {
	    delete $h->{$k}; 
	}
    }
    return $h;
}

sub _gettime {
    return [ gettimeofday ];
}

sub _timediff {
    my ($t1, $t2) = @_;
    return "invalid time diff" unless $t1 and $t1;
    return tv_interval($t1, $t2);
}
1;
