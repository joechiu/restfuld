package go;

use lib '/srv/restful/lib';
use XML::Simple qw(:strict);	
use Data::Dumper;
use err;
use u;

my $err = new err;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my %c = @_;
    map { $self->{lc($_)} = $c{$_} } keys %c;
    return $self;
}

sub gen {
    my $self = shift;
    my $content = shift;
    my $h;
    logit( "Content: ".$content) if $self->{log};
    eval {
	my $args = XMLin(
	    $content, 
	    KeyAttr => { server => 'name' },
	    ForceArray => 1
	);
	$h = $args->{server};
    };
    if ($@) {
	my $msg = $@;
	$msg =~ s/\n//g;
	$err->set($@);
	return {};
    }

    logit(Dumper $h) if $self->{debug};
    return XMLout($h, KeyAttr => []);
}
1;
