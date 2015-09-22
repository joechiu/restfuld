use JSON;
use Data::Dumper;
use lib '/srv/restful/lib';
use u;

# benchmark, optional
my $t1 = _gettime;

# global params
$h = $params || { hello => 'world' };

# benchmark, optional
my $t2 = _gettime;
$h->{realtime} = _timediff($t1,$t2);

# log the results 
logit "Results: "._to_json($h);
# return results as json
_to_json($h);
