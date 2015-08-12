use JSON;
use Data::Dumper;
use lib '/srv/restful/lib';
use u;
$h = $main::params || { hello => 'world' };
_to_json($h);
