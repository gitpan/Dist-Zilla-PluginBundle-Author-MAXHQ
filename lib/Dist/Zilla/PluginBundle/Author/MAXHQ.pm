use strict;
package Dist::Zilla::PluginBundle::Author::MAXHQ;
# ABSTRACT: Dist::Zilla like MAXHQ when you build your dists
our $VERSION = '0.011002'; # VERSION


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
		# Files included
		#
		['GatherDir' => {              # skip files on top level
			exclude_match => [
				'^[^\.]+\.ini$',
				'^[^\.]+\.html$',
				'^[^\.]+\.tar\.gz$',
			]
		}],
		'PruneCruft',                  # prune stuff you probably don't want
		
		['ExecDir' => {                # install contents of bin/ as executable
			dir => 'bin',
		}],		
		['ShareDir' => {               # include all files in /share
			dir => 'share',
		}],
		
		#
		# Conversion and replacements
		#
		'OurPkgVersion',               # replaces "# VERSION" by "our $VERSION = '...';"
		['NextVersion::Semantic' => {  # generate next version based on type of changes
			major => 'NEW FEATURES, API CHANGES',
			minor => 'ENHANCEMENTS',
			revision => 'REVISION, BUG FIXES, DOCUMENTATION',
		}],
		'PreviousVersion::Changelog',  # fetch previous version from changelog
		                               # alternatively run: V=0.00100 dzil release
		
		# weave your Pod together from configuration and Dist::Zilla
		# (turns "# ABSTRACT" into POD, processes =method and short lists etc.)
		# To exclude files from PodWeaver see: http://blogs.perl.org/users/polettix/2011/11/distzilla-podweaver-and-bin.html
		'PodWeaver',

		#
		# Prerequisites
		#
		'AutoPrereqs',                 # extract prereqs from your modules
		'Prereqs::AuthorDeps',         # "adds Dist::Zilla and the result of "dzil
		                               # authordeps" to the 'develop' phase prerequisite list"
		'PrereqsClean',                # "Cleans up mess from other Prereq modules"
		['Prereqs::MatchInstalled::All' => { # adjust prereqs to use latest version available
			exclude => [qw( strict warnings )]
		}],
		
		#
		# Auto generation --- distribution files
		#
		'ModuleBuild',                 # build a Build.PL that uses Module::Build to install the distribution
		'MetaYAML',                    # generate META.yml
		'Manifest',                    # generate Manifest (list of all files)
		'License',                     # generate LICENSE
		'ReadmeAnyFromPod',            # generate README (with dist's name, version, abstract, license)

		#
		# Auto generation --- tests
		#
		'Test::Inline',                # generate .t files from inline test code (POD)
		
		# auto-generate various tests
		'ExtraTests',
		'Test::Perl::Critic',
		'PodCoverageTests',
		'PodSyntaxTests',

		#
		# Auto generation --- docs
		#
		['Pod2Html' => {               # generate HTML documentation
			'dir' => 'doc',
		}],

		#
		# Release
		#
		['NextRelease' => {            # replace {{$NEXT}} in "Changes" file with new version and date
			format => '%-9v %{yyyy-MM-dd}d',
		}],
		'TestRelease',                 # test before releasing
		'ConfirmRelease',              # ask for confirmation before releasing
		'Clean',                       # Like "dzil clean" after release
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

version 0.011002

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