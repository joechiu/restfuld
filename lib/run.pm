#!/usr/bin/perl

use lib '/srv/restful/lib';
use err;
use u;

BEGIN {
    sub inc {
	my $in = shift;
	my @libs = qw{
	    /srv/restful/plugins
	    /srv/restful/plugins/lib
	};
	map { unshift @INC, ($in ? "$_/$in" : $_) } @libs;
    }
    inc;
    require "default-settings.pl";
};

my $err = new err;

sub not_package {
    my $p = shift;
    return $p =~ /\.pl$/;
}

sub cando {
    my ($filename) = @_;

    if (exists $INC{$filename}) {
	logit "Redo process: $filename";
	return do($INC{$filename});
    }

    my ($realfilename,$result);

    ITER: {
	foreach my $prefix (@INC) {
	    $realfilename = "$prefix/$filename";
	    if (-f $realfilename) {
		$INC{$filename} = $realfilename;
		$result = do $realfilename;
		last ITER;
	    }
	}
	logit "Can't find $filename in \@INC";
	return undef;
    }

    if ($@) {
	$err->set("internal service error");
	$INC{$filename} = undef;
	logit $@;
	return undef;
    } elsif (!$result) {
	$err->set("no value returns");
	delete $INC{$filename};
	logit "$filename did not return true value";
	return undef;
    } else {
	return $result;
    }
}

sub todo {
    my $act = shift;
    my $content = shift;
    my $prm = shift;
    my $method = shift;
    my $plug = $plugins->{$act};
    $method = $method || $plug->{method} || 'ret';
    my $p = $prm || $plug->{main} || $plug->{package} || "$act/main.pl";

    inc $act;

    return cando $p if not_package($p);

    my $pm = $p =~ /.pm$/ ? $p : "$p.pm";
    cando $pm;
    my $o = new $p;
    my $r = do { $o->can( $method ) };

    if ($@) {
	$err->set($@);
	logit("Error: ".$@);
	return;
    }
    return $o->$r($content);
}

1;
