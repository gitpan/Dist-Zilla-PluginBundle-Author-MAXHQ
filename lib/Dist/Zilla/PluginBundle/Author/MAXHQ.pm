use strict;
package Dist::Zilla::PluginBundle::Author::MAXHQ;
# ABSTRACT: MAXHQ's default Dist::Zilla configuration
$Dist::Zilla::PluginBundle::Author::MAXHQ::VERSION = '1.000005';
# =encoding UTF-8
#  
# =head1 SYNOPSIS
#  
# Put following into your C<dist.ini>:
#
# 	[@Author::MAXHQ]
# 	GatherDir.exclude_match = ^[^\/\.]+\.txt$
#
# =head1 OVERVIEW
#
# Currently this plugin bundle is equivalent to:
# 	
# 	#
# 	# Files included
# 	#
# 	[GatherDir]
# 	[PruneCruft]
# 	[ExecDir]
# 	dir = bin
# 	
# 	[ShareDir]
# 	dir = share
# 	
# 	#
# 	# Conversion and replacements
# 	#
# 	[PkgVersion]
# 	die_on_existing_version = 1
# 	die_on_line_insertion   = 1
# 	
# 	[NextRelease]
# 	format = '%-9v %{yyyy-MM-dd}d'
# 	
# 	[PreviousVersion::Changelog]
# 	[NextVersion::Semantic]
# 	major = *NEW FEATURES, *API CHANGES
# 	minor = +ENHANCEMENTS
# 	revision = REVISION, BUG FIXES, DOCUMENTATION
# 	numify_version = 1
#
# 	[PodWeaver]
# 	config_plugin = @Author::MAXHQ
# 	replacer      = replace_with_comment
#
# 	#
# 	# Prerequisites
# 	#
# 	[AutoPrereqs]
# 	[Prereqs::AuthorDeps]
# 	[PrereqsClean]
# 	[Prereqs::MatchInstalled::All]
# 	exclude = strict
# 	exclude = warnings
#
# 	#
# 	# Auto generation --- distribution files
# 	#
# 	[ModuleBuild]
# 	[MetaYAML]
# 	[Manifest]
# 	[License]
# 	[ReadmeAnyFromPod]
#
# 	#
# 	# Auto generation --- tests
# 	#
# 	[Test::Inline]
# 	[ExtraTests]
# 	[Test::Perl::Critic]
# 	[PodCoverageTests]
# 	[PodSyntaxTests]
#
# 	#
# 	# Auto generation --- docs
# 	#
# 	[Pod2Html]
# 	dir = doc
#
# 	# Release
# 	[TestRelease]
# 	[ConfirmRelease]
#
# =cut 

use Moose;

# choose the easy way of configuring a plugin bundle
with 'Dist::Zilla::Role::PluginBundle::Easy';

# add all plugins configured below to the prerequisites of this pluginbundle module
# (requires setting "bundledeps_phase = runtime" in this module's dist.ini)
with 'Dist::Zilla::Role::BundleDeps';

# =for Pod::Coverage mvp_multivalue_args
#
# =cut
#
#"If you want a configuration option that takes more than one value, you'll need
#to mark it as multivalue arg by having its name returned by
#C<mvp_multivalue_args>."
#
#Queried by L<Dist::Zilla>.
#
sub mvp_multivalue_args { return qw(GatherDir.exclude_match) }

# =for Pod::Coverage configure
#
# =cut
#
#Required by role L<Dist::Zilla::Role::PluginBundle::Easy>.
#
#Configures the plugins of this bundle.
#
sub configure {
    my $self = shift;
	
	# build this array by merging...
	my @exclude_matches = (
		# ...the parameter (or an empty ref)
		@{ $self->payload->{'GatherDir.exclude_match'} || [] },
		# ...with the default options
		qw(
			^[^\.]+\.ini$
			^[^\.]+\.html$
			^[^\.]+\.tar\.gz$
		)
	);
 
    $self->add_plugins(
		#
		# Files included
		#
		['GatherDir' => {                 # skip files on top level
			exclude_match => \@exclude_matches,
		}],
		'PruneCruft',                     # prune stuff you probably don't want
		
		['ExecDir' => {                   # install contents of bin/ as executable
			dir => 'bin',
		}],		
		['ShareDir' => {                  # include all files in /share
			dir => 'share',
		}],
		
		#
		# Conversion and replacements
		#
		['PkgVersion' => {                # insert version number in first blank line
			die_on_existing_version => 1,
			die_on_line_insertion   => 1,
		}],
		['NextRelease' => {               # replace {{$NEXT}} in "Changes" file with new version and
			format => '%-9v %{yyyy-MM-dd}d', # date (MUST be included before NextVersion::Semantic)
		}],
		'PreviousVersion::Changelog',     # fetch previous version from changelog
		                                  # alternatively run: V=0.00100 dzil release
		['NextVersion::Semantic' => {     # generate next version based on type of changes
			major => '*NEW FEATURES, *API CHANGES',
			minor => '+ENHANCEMENTS',
			revision => 'REVISION, BUG FIXES, DOCUMENTATION',
			numify_version => 1,          # use x.yyyzzz convention instead of x.y.z
		}],
		# Please note that * and ! are mainly there to enforce correct ordering
		# as CPAN::Changes::Release (used in NextVersion::Semantic) just sorts
		# groups alphabetically
		
		# weave your Pod together from configuration and Dist::Zilla
		# (turns "# ABSTRACT" into POD, processes =method and short lists etc.)
		# To exclude files from PodWeaver see: http://blogs.perl.org/users/polettix/2011/11/distzilla-podweaver-and-bin.html
		['PodWeaver' => {
			config_plugin => '@Author::MAXHQ',
			replacer      => 'replace_with_comment', # replace original POD with comments to preserve line numbering
		}],

		#
		# Prerequisites
		#
		'AutoPrereqs',                    # extract prereqs from your modules
		'Prereqs::AuthorDeps',            # "adds Dist::Zilla and the result of "dzil
		                                  # authordeps" to the 'develop' phase prerequisite list"
		'PrereqsClean',                   # "Cleans up mess from other Prereq modules"
		['Prereqs::MatchInstalled::All' => { # adjust prereqs to use same version as currently installed
			exclude => [qw( strict warnings )]
		}],
		
		#
		# Auto generation --- distribution files
		#
		'ModuleBuild',                    # build a Build.PL that uses Module::Build to install the distribution
		'MetaYAML',                       # generate META.yml
		'Manifest',                       # generate Manifest (list of all files)
		'License',                        # generate LICENSE
		'ReadmeAnyFromPod',               # generate README (with dist's name, version, abstract, license)

		#
		# Auto generation --- tests
		#
		'Test::Inline',                   # generate .t files from inline test code (POD)
		
		# auto-generate various tests
		'ExtraTests',
		'Test::Perl::Critic',
		'PodCoverageTests',
		'PodSyntaxTests',

		#
		# Auto generation --- docs
		#
		['Pod2Html' => {                  # generate HTML documentation
			'dir' => 'doc',
		}],

		#
		# Release
		#
		'TestRelease',                    # test before releasing
		'ConfirmRelease',                 # ask for confirmation before releasing
    );
}
 
__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::PluginBundle::Author::MAXHQ - MAXHQ's default Dist::Zilla configuration

=head1 VERSION

version 1.000005

=head1 SYNOPSIS

Put following into your C<dist.ini>:

	[@Author::MAXHQ]
	GatherDir.exclude_match = ^[^\/\.]+\.txt$

=head1 OVERVIEW

Currently this plugin bundle is equivalent to:

	#
	# Files included
	#
	[GatherDir]
	[PruneCruft]
	[ExecDir]
	dir = bin
	
	[ShareDir]
	dir = share
	
	#
	# Conversion and replacements
	#
	[PkgVersion]
	die_on_existing_version = 1
	die_on_line_insertion   = 1
	
	[NextRelease]
	format = '%-9v %{yyyy-MM-dd}d'
	
	[PreviousVersion::Changelog]
	[NextVersion::Semantic]
	major = *NEW FEATURES, *API CHANGES
	minor = +ENHANCEMENTS
	revision = REVISION, BUG FIXES, DOCUMENTATION
	numify_version = 1

	[PodWeaver]
	config_plugin = @Author::MAXHQ
	replacer      = replace_with_comment

	#
	# Prerequisites
	#
	[AutoPrereqs]
	[Prereqs::AuthorDeps]
	[PrereqsClean]
	[Prereqs::MatchInstalled::All]
	exclude = strict
	exclude = warnings

	#
	# Auto generation --- distribution files
	#
	[ModuleBuild]
	[MetaYAML]
	[Manifest]
	[License]
	[ReadmeAnyFromPod]

	#
	# Auto generation --- tests
	#
	[Test::Inline]
	[ExtraTests]
	[Test::Perl::Critic]
	[PodCoverageTests]
	[PodSyntaxTests]

	#
	# Auto generation --- docs
	#
	[Pod2Html]
	dir = doc

	# Release
	[TestRelease]
	[ConfirmRelease]

=encoding UTF-8

=for Pod::Coverage mvp_multivalue_args

=for Pod::Coverage configure

=head1 AUTHOR

Jens Berthold <jens.berthold@jebecs.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jens Berthold.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
