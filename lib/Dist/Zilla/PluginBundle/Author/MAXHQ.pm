use strict;
package Dist::Zilla::PluginBundle::Author::MAXHQ;
# ABSTRACT: Dist::Zilla like MAXHQ when you build your dists
our $VERSION = '0.0100021'; # VERSION


use Moose;

# choose the easy way of configuring a plugin bundle
with 'Dist::Zilla::Role::PluginBundle::Easy';

# add all plugins configured below to the prerequisites of this pluginbundle module
# (requires setting "bundledeps_phase = runtime" in this module's dist.ini)
with 'Dist::Zilla::Role::BundleDeps';

sub configure {
    my $self = shift;
 
    $self->add_plugins(
		#
		# Before build
		#
        [ 'PromptIfStale' => 'build' => { phase => 'build', module => [ blessed($self) ] } ],
        
		#
		# Collect files, calculate dependencies...
		#
		['GatherDir' => {
			exclude_match => '^[^\.]+\.ini',
			exclude_match => '^[^\.]+\.html',
			exclude_match => '^[^\.]+\.tar\.gz',
		}],
		# produce a META.yml
		'MetaYAML',
		
		# build a Build.PL that uses Module::Build to install the distribution
		'ModuleBuild',
		
		# prune stuff that you probably don't mean to include in the package
		'PruneCruft',
		
		# automatically extract prereqs from your modules
		'AutoPrereqs',
		
		# manually add some prereqs
		['Prereqs' => {
			'Test::Inline' => 0,      # for =inc::ExtractInlineTests
			'File::Find::Rule' => 0,  # for =inc::ExtractInlineTests
		}],
		
		# "Automatically cleans up the mess from other Prereq modules"
		'PrereqsClean',
		
		# adjust prereqs to use latest version available
		'LatestPrereqs',
		
		# install contents of bin/ as executable
		'ExecDir',
		
		#
		# Release
		#
		'TestRelease',
		'ConfirmRelease',

		# Like calling "dzil clean" after release to remove builds
		'Clean',
		
		#
		# Auto generation
		#
		
		# Automatically insert version variable (replace "# VERSION" by "our $VERSION = '...';")
		'OurPkgVersion',
		
		# weave your Pod together from configuration and Dist::Zilla
		# (turns "# ABSTRACT" into POD, processes =method and short lists etc.)
		# To exclude files from PodWeaver see: http://blogs.perl.org/users/polettix/2011/11/distzilla-podweaver-and-bin.html
		'PodWeaver',
		
		# output a LICENSE file
		'License',
		
		# build a README file citing the dist's name, version, abstract, and license
		'ReadmeAnyFromPod',
		
		# extract inline test code from modules
		'=Dist::Zilla::PluginBundle::Author::MAXHQ::ExtractInlineTests',
		
		# auto-generate various tests
		'ExtraTests',
		'Test::Perl::Critic',
		'PodCoverageTests',
		'PodSyntaxTests',
		
		# Generate list of all files in the distribution
		'Manifest',
		
		# Generate HTML documentation
		['Pod2Html' => {
			'dir' => 'doc',
		}],
    );
}
 
__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::PluginBundle::Author::MAXHQ - Dist::Zilla like MAXHQ when you build your dists

=head1 VERSION

version 0.0100021

=head1 SYNOPSIS

	# dist.ini
	[@Author::MAXHQ]

=head1 EXTENDS

=over 4

=item * L<Moose::Object>

=back

=head1 METHODS

=head2 configure

Required by role L<Dist::Zilla::Role::PluginBundle::Easy>.

Configures the plugins of this bundle.

=encoding UTF-8

=head1 AUTHOR

Jens Berthold <jens.berthold@jebecs.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jens Berthold.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
