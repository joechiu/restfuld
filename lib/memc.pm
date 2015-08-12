package memc;

use strict;
use Data::Dumper;
use Cache::Memcached;
use Storable qw(freeze thaw);
use JSON;
use Digest::MD5  qw(md5 md5_hex md5_base64);
use lib '/srv/restful/lib';
use u;

use constant TIMEOUT    => 30 * 24 * 60 * 60;  # seconds
use constant COMPRESS	=> 10_000;  # compress value if exceeds default 10KB 
use constant ENABLE	=> 1;	    # 1: enable compress, 0: no compress

my $memd;
my @servers = qw/ 
    localhost:11211 
/;
# memcached servers
# xx.xx.xxx.xx:11211
my $COUNT = 0; # do log once for keygen
my @param = qw/
    street
    suburb
    state
/;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my %c = @_;
    map { $self->{lc($_)} = $c{$_} } keys %c;

    $memd = _cacheopen();

    return $self;
}

sub _keygen {
    my $h = shift;
    my @key;
    foreach my $p (@param) {
	push @key, $p, lc $h->{$p} if $h->{$p};
    }
    my $key = join '-', @key;
    $key =~ s/\s/%20/g;
    # logit("Key: ".$key) unless ++$COUNT;
    return $key;
}

sub get_cache {
    my $self = shift;
    my $h = shift;
    my $key = _keygen $h;
    _cacheopen();
    my $val = $memd->get($key);
    return thaw($val) || undef;
}

sub set_cache {
    my $self = shift;
    my $h = shift;
    my $val = shift; # expect to be an array ref
    my $key = _keygen $h;
    _cacheopen();
    # expired 90 days to match GNAF address updates
    my $exp = shift || TIMEOUT;
    $memd->set($key, freeze($val), $exp);
}

sub get_json_cache {
    my $self = shift;
    my $h = shift;
    my $key = _keygen $h;
    # logit("Key: ".$key);
    _cacheopen();
    my $val = $memd->get($key) || return undef;
    return _from_json($val);
}

sub set_json_cache {
    my $self = shift;
    my $h = shift;
    my $val = shift; # expect to be an array ref
    my $key = _keygen $h;
    _cacheopen();
    # expired 90 days to match GNAF address updates
    my $exp = shift || TIMEOUT;
    $memd->set($key, _to_json($val), $exp);
}

sub _cacheopen {
    return $memd ||= new Cache::Memcached {
        servers => [ @servers ],
        'debug' => 0,
        no_rehash => 1,
	set_compress_threshold => COMPRESS,
	enable_compress => ENABLE,
    };
}

1;
