# action => { main => "main program pl", package => "package name", method => "method name" }
# .pl scripts don't need a method
# if package defined, method is mandantory
# default program: main.pl
$plugins = {
    auto	=> { package => 'address', method => 'res' },
    test	=> { main => 'test.pl' },
};
