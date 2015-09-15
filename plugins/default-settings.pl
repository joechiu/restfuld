# action => { main => "main program pl", package => "package name", method => "method name" }
# .pl scripts don't need a method
# if package defined, method is mandantory
# default program: main.pl
$plugins = {
    test	=> { main => 'test.pl' },
};
