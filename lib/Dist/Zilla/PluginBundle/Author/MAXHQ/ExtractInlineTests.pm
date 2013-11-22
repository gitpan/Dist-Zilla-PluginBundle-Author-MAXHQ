package Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests;
# ABSTRACT: Extract inline tests from POD sections in the modules
our $VERSION = '0.0100017'; # VERSION

=utf8

=head1 DESCRIPTION

The code of this Dist::Zilla file gatherer module is taken from
L<https://github.com/moose/moose/blob/master/inc/ExtractInlineTests.pm>.

This module scans all files for inline tests in POD sections, like e.g.:

	=begin testing

	use Test::Exception;

	my $list;

	lives_ok {
		$list = My::AddressRange->list_from_range('10.2.3.1', '10.2.3.5')
	} "list_from_range() doesn't die with correct input for a list of IPs";

	dies_ok {
		My::AddressRange->list_from_range('10.2.3.A', '10.2.3.5')
	} "list_from_range() complains about invalid address";

	=end testing
	
=cut
use Moose;

with 'Dist::Zilla::Role::FileGatherer';

use File::Basename qw( basename );
use File::Spec;
use File::Temp qw( tempdir );
use File::Find::Rule;
use Test::Inline;

sub gather_files {
    my $self = shift;
    my $arg = shift;

	$self->log("extracting inline (perldoc) tests");

    my $inline = Test::Inline->new(
        verbose => 0,
        ExtractHandler => 'Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests::Extract',
        OutputHandler => Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests::Output->new($self),
    );

    $inline->add_all;
    $inline->save;
}

{
	# Used to connect Test::Inline to Dist::Zilla
	# (write generated test code into in-memory files)
    package Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests::Output;
    
    sub new {
        my $class = shift;
        my $dzil = shift;

        return bless { dzil => $dzil }, $class;
    }

    sub write {
        my $self = shift;
        my $name = shift;
        my $content = shift;

        $self->{dzil}->add_file(
            Dist::Zilla::File::InMemory->new(
                name => "t/inline-tests/$name",
                content => $content,
            )
        );

        return 1;
    }
}
#
# Taken from https://github.com/moose/Moose/blob/master/inc/MyInline.pm
#
{
	package Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests::Extract;
	
	use parent 'Test::Inline::Extract';
	
	# This extracts the SYNOPSIS in addition to code specifically
	# marked for testing
	our $search = qr/
		(?:^|\n)                           # After the beginning of the string, or a newline
		(                                  # ... start capturing
		                                   # EITHER
			package\s+                            # A package
			[^\W\d]\w*(?:(?:\'|::)[^\W\d]\w*)*    # ... with a name
			\s*;                                  # And a statement terminator
		|                                  # OR
			class\s+                            # A class
			[^\W\d]\w*(?:(?:\'|::)[^\W\d]\w*)*    # ... with a name
			($|\s+|\s*{)                          # And some spaces or an opening bracket
		|                                  # OR
			role\s+                            # A role
			[^\W\d]\w*(?:(?:\'|::)[^\W\d]\w*)*    # ... with a name
			($|\s+|\s*{)                          # And some spaces or an opening bracket
		|                                  # OR
			=for[ \t]+example[ \t]+begin\n        # ... when we find a =for example begin
			.*?                                   # ... and keep capturing
			\n=for[ \t]+example[ \t]+end\s*?      # ... until the =for example end
			(?:\n|$)                              # ... at the end of file or a newline
		|                                  # OR
			=begin[ \t]+(?:test|testing)\b        # ... when we find a =begin test or testing
			.*?                                   # ... and keep capturing
			\n=end[ \t]+(?:test|testing)\s*?      # ... until an =end tag
			(?:\n|$)                              # ... at the end of file or a newline
		)                                  # ... and stop capturing
		/isx;
	
	sub _elements {
	    my $self     = shift;
	    my @elements = ();
	    while ( $self->{source} =~ m/$search/go ) {
	    	my $element = $1;
	    	$element =~ s/^(role|class)(\s+)/package$2/;
	    	$element =~ s/\n\s*$//;
	        push @elements, $element;
	    }
	    
	    (List::Util::first { /^=/ } @elements) ? \@elements : '';
	}
	
}

1;