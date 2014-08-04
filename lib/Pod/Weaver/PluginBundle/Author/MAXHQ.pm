use strict;
package Pod::Weaver::PluginBundle::Author::MAXHQ;
# ABSTRACT: MAXHQ's default Pod::Weaver configuration
$Pod::Weaver::PluginBundle::Author::MAXHQ::VERSION = '1.000006';
# Thanks to
# - Joshua Keroes (http://rjbs.manxome.org/rubric/entry/1809)
# - rjbs (http://de.slideshare.net/jkeroes/getting-started-with-podweaver)

#pod =head1 SYNOPSIS
#pod
#pod Put the following into your C<weaver.ini>:
#pod
#pod 	[@Author::MAXHQ]
#pod
#pod =head1 OVERVIEW
#pod
#pod Currently this plugin bundle is equivalent to:
#pod
#pod 	[@CorePrep]
#pod 	
#pod 	[Name]
#pod 	[Version]
#pod 	
#pod 	;#
#pod 	;# prelude
#pod 	;#
#pod 	[Region  / prelude]
#pod 	
#pod 	[Generic / SYNOPSIS]
#pod 	[Generic / DESCRIPTION]
#pod 	[Generic / OVERVIEW]
#pod 	
#pod 	[Extends]
#pod 	
#pod 	;#
#pod 	;# functions etc.
#pod 	;#
#pod 	[Collect / ATTRIBUTES]
#pod 	command = attr
#pod
#pod 	[Collect / REQUIRED METHODS]
#pod 	command = requires
#pod 	
#pod 	[Collect / CLASS METHODS]
#pod 	command = class_method
#pod 	
#pod 	[Collect / METHODS]
#pod 	command = method
#pod 	
#pod 	[Collect / MOJOLICIOUS PLUGINS]
#pod 	command = mojo_plugin
#pod 	
#pod 	[Collect / MOJOLICIOUS SHORTCUTS]
#pod 	command = mojo_short
#pod 	
#pod 	[Collect / MOJOLICIOUS CONDITIONS]
#pod 	command = mojo_cond
#pod 	
#pod 	[Collect / MOJOLICIOUS HELPERS]
#pod 	command = mojo_helper
#pod 	
#pod 	
#pod 	[Leftovers]
#pod 	
#pod 	;#
#pod 	;# postlude
#pod 	;#
#pod 	[Region  / postlude]
#pod 	
#pod 	[Authors]
#pod 	[Legal]
#pod 	
#pod 	;#
#pod 	;# plugins
#pod 	;#
#pod 	[-Transformer]
#pod 	transformer = List
#pod
#pod =cut

use Pod::Weaver::Config::Assembler;
sub _exp { Pod::Weaver::Config::Assembler->expand_package($_[0]) }

#pod =for Pod::Coverage mvp_bundle_config
#pod
#pod =cut
#
#Returns my C<Pod::Weaver> plugin configuration. Based on 
#L<Pod::Weaver::PluginBundle::RJBS>.
#
#The return format is a list of ArrayRefs, where each ArrayRef looks like:
#
#	[$name, $package, $payload]
#	
#(Described in L<Config::MVP::Assembler::WithBundles/replace_bundle_with_contents>)
#
#This method is called by L<Pod::Weaver>, or more specific by
#L<Config::MVP::Assembler::WithBundles/replace_bundle_with_contents>.
sub mvp_bundle_config {
	return (
		[ '@MAXHQ/CorePrep',       _exp('@CorePrep'),        {} ],
		[ '@MAXHQ/Name',           _exp('Name'),             {} ],
		[ '@MAXHQ/Version',        _exp('Version'),          {} ],
		
		[ '@MAXHQ/Prelude',        _exp('Region'),  { region_name => 'prelude'     } ],
	
		[ '@MAXHQ/Synopsis',       _exp('Generic'), { header      => 'SYNOPSIS'    } ],
		[ '@MAXHQ/Description',    _exp('Generic'), { header      => 'DESCRIPTION' } ],
		[ '@MAXHQ/Overview',       _exp('Generic'), { header      => 'OVERVIEW'    } ],
	
		[ '@MAXHQ/Functions',      _exp('Collect'), { command => 'func',         header => ''   } ],
		[ '@MAXHQ/Attributes',     _exp('Collect'), { command => 'attr',         header => 'ATTRIBUTES'} ],
		[ '@MAXHQ/RoleRequires',   _exp('Collect'), { command => 'requires',     header => 'REQUIRED METHODS' } ],
		[ '@MAXHQ/ClassMethods',   _exp('Collect'), { command => 'class_method', header => 'CLASS METHODS' } ],
		[ '@MAXHQ/Methods',        _exp('Collect'), { command => 'method',       header => 'METHODS' } ],
		[ '@MAXHQ/MojoPlugins',    _exp('Collect'), { command => 'mojo_plugin',  header => 'MOJOLICIOUS PLUGINS' } ],
		[ '@MAXHQ/MojoShortcuts',  _exp('Collect'), { command => 'mojo_short',   header => 'MOJOLICIOUS SHORTCUTS' } ],
		[ '@MAXHQ/MojoConditions', _exp('Collect'), { command => 'mojo_cond',    header => 'MOJOLICIOUS CONDITIONS' } ],
		[ '@MAXHQ/MojoHelpers',    _exp('Collect'), { command => 'mojo_helper',  header => 'MOJOLICIOUS HELPERS' } ],
	
	    [ '@MAXHQ/Leftovers', _exp('Leftovers'), {} ],
	    [ '@MAXHQ/postlude',  _exp('Region'),    { region_name => 'postlude' } ],
	    [ '@MAXHQ/Authors',   _exp('Authors'),   {} ],
	    [ '@MAXHQ/Legal',     _exp('Legal'),     {} ],
	    [ '@MAXHQ/List',      _exp('-Transformer'), { 'transformer' => 'List' } ],
	);
}
 
1;

__END__

=pod

=head1 NAME

Pod::Weaver::PluginBundle::Author::MAXHQ - MAXHQ's default Pod::Weaver configuration

=head1 VERSION

version 1.000006

=head1 SYNOPSIS

Put the following into your C<weaver.ini>:

	[@Author::MAXHQ]

=head1 OVERVIEW

Currently this plugin bundle is equivalent to:

	[@CorePrep]
	
	[Name]
	[Version]
	
	;#
	;# prelude
	;#
	[Region  / prelude]
	
	[Generic / SYNOPSIS]
	[Generic / DESCRIPTION]
	[Generic / OVERVIEW]
	
	[Extends]
	
	;#
	;# functions etc.
	;#
	[Collect / ATTRIBUTES]
	command = attr

	[Collect / REQUIRED METHODS]
	command = requires
	
	[Collect / CLASS METHODS]
	command = class_method
	
	[Collect / METHODS]
	command = method
	
	[Collect / MOJOLICIOUS PLUGINS]
	command = mojo_plugin
	
	[Collect / MOJOLICIOUS SHORTCUTS]
	command = mojo_short
	
	[Collect / MOJOLICIOUS CONDITIONS]
	command = mojo_cond
	
	[Collect / MOJOLICIOUS HELPERS]
	command = mojo_helper
	
	
	[Leftovers]
	
	;#
	;# postlude
	;#
	[Region  / postlude]
	
	[Authors]
	[Legal]
	
	;#
	;# plugins
	;#
	[-Transformer]
	transformer = List

=for Pod::Coverage mvp_bundle_config

=head1 AUTHOR

Jens Berthold <jens.berthold@jebecs.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jens Berthold.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
