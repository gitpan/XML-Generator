# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..29\n"; }
END {print "not ok 1\n" unless $loaded;}
use XML::Generator;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $x = new XML::Generator or print "not ";
print "ok 2\n";

my $xml = $x->foo();
$xml eq '<foo />' or print "not ";
print "ok 3\n";

$xml = $x->bar(42);
$xml eq '<bar>42</bar>' or print "not ";
print "ok 4\n";

$xml = $x->baz({'foo'=>3});
$xml eq '<baz foo="3" />' or print "not ";
print "ok 5\n";

$xml = $x->bam({'bar'=>42},$x->foo(),"qux");
$xml eq '<bam bar="42"><foo />qux</bam>' or print "not ";
print "ok 6\n";

$xml = $x->new(3);
$xml eq '<new>3</new>' or print "not ";
print "ok 7\n";

$xml = $x->foo([baz]);
$xml eq '<baz:foo />' or print "not ";
print "ok 8\n";

$xml = $x->foo([baz,bam]);
$xml eq '<baz:bam:foo />' or print "not ";
print "ok 9\n";

$xml = $x->foo([baz],{'bar'=>42},3);
$xml eq '<baz:foo baz:bar="42">3</baz:foo>' or print "not ";
print "ok 10\n";

$xml = $x->foo({'id' => 4}, 3, 5);
$xml eq '<foo id="4">35</foo>' or print "not ";
print "ok 11\n";

$xml = $x->foo({'id' => 4}, 0, 5);
$xml eq '<foo id="4">05</foo>' or print "not ";
print "ok 12\n";

$xml = $x->foo({'id' => 4}, 3, 0);
$xml eq '<foo id="4">30</foo>' or print "not ";
print "ok 13\n";

my $foo_bar = "foo-bar";
$xml = $x->$foo_bar(42);
$xml eq '<foo-bar>42</foo-bar>' or print "not ";
print "ok 14\n";

$x = new XML::Generator 'escape' => 'always';

$xml = $x->foo({'bar' => '4"4'}, '<&>"\<');
$xml eq '<foo bar="4&quot;4">&lt;&amp;&gt;"\&lt;</foo>' or print "not ";
print "ok 15\n";

$x = new XML::Generator 'escape' => 'true';

$xml = $x->foo({'bar' => '4\"4'}, '<&>"\<');
$xml eq '<foo bar="4"4">&lt;&amp;&gt;"<</foo>' or print "not ";
print "ok 16\n";

$x = new XML::Generator 'namespace' => 'A';

$xml = $x->foo({'bar' => 42}, $x->bar(['B'], {'bar' => 54}));
$xml eq '<A:foo A:bar="42"><B:bar B:bar="54" /></A:foo>' or print "not ";
print "ok 17\n";

$x = new XML::Generator 'conformance' => 'strict';
$xml = $x->xmldecl();
$xml eq '<?xml version="1.0" standalone="yes"?>' or print "not ";
print "ok 18\n";

$xml = $x->xmlcmnt("test");
$xml eq '<!-- test -->' or print "not ";
print "ok 19\n";

$x = new XML::Generator 'conformance' => 'strict',
			'version' => '1.1',
			'encoding' => 'iso-8859-2';
$xml = $x->xmldecl();
$xml eq '<?xml version="1.1" encoding="iso-8859-2" standalone="yes"?>' or print "not ";
print "ok 20\n";

$xml = $x->xmlpi("target", "option" => "value");
$xml eq '<?target option="value"?>' or print "not ";
print "ok 21\n";

eval {
  $x->xml();
};
$@ =~ /names beginning with 'xml' are reserved by the W3C/ or print "not ";
print "ok 22\n";

eval {
  my $t = "42";
  $x->$t();
};
$@ =~ /name \[42] may not begin with a number/ or print "not ";
print "ok 23\n";

eval {
  my $t = "g:";
  $x->$t();
};
$@ =~ /name \[g:] contains illegal character\(s\)/ or print "not ";
print "ok 24\n";

eval {
  $x->foo(['one', 'two']);
};
$@ =~ /only one namespace component allowed/ or print "not ";
print "ok 25\n";

$xml = $x->foo(['bar'], {'baz:foo' => 'qux', 'fob' => 'gux'});
$xml eq '<bar:foo baz:foo="qux" bar:fob="gux" />' or print "not ";
print "ok 26\n";

$x = new XML::Generator;
$xml = $x->xml();
$xml eq '<xml />' or print "not ";
print "ok 27\n";

$x = new XML::Generator 'conformance' => 'strict',
			'dtd' => [ 'foo', 'SYSTEM', '"http://foo.com/foo"' ];
$xml = $x->xmldecl();
$xml eq 
'<?xml version="1.0" standalone="no"?>
<!DOCTYPE foo SYSTEM "http://foo.com/foo">' or print "not ";
print "ok 28\n";

$xml = $x->xmlcdata("test");
$xml eq '<![CDATA[test]]>' or print "not ";
print "ok 29\n";
