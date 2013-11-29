
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Dist::Zilla like MAXHQ when you build your dists",
  "dist_author" => [
    "Jens Berthold <jens.berthold\@jebecs.de>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-MAXHQ",
  "dist_version" => "0.011004",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::MAXHQ",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dist::Zilla::Plugin::AutoPrereqs" => 0,
    "Dist::Zilla::Plugin::Clean" => 0,
    "Dist::Zilla::Plugin::ConfirmRelease" => 0,
    "Dist::Zilla::Plugin::ExecDir" => 0,
    "Dist::Zilla::Plugin::ExtraTests" => 0,
    "Dist::Zilla::Plugin::GatherDir" => 0,
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::ModuleBuild" => 0,
    "Dist::Zilla::Plugin::NextRelease" => 0,
    "Dist::Zilla::Plugin::NextVersion::Semantic" => 0,
    "Dist::Zilla::Plugin::OurPkgVersion" => 0,
    "Dist::Zilla::Plugin::Pod2Html" => 0,
    "Dist::Zilla::Plugin::PodCoverageTests" => 0,
    "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
    "Dist::Zilla::Plugin::PodWeaver" => 0,
    "Dist::Zilla::Plugin::Prereqs::AuthorDeps" => 0,
    "Dist::Zilla::Plugin::Prereqs::MatchInstalled::All" => 0,
    "Dist::Zilla::Plugin::PrereqsClean" => 0,
    "Dist::Zilla::Plugin::PreviousVersion::Changelog" => 0,
    "Dist::Zilla::Plugin::PruneCruft" => 0,
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => 0,
    "Dist::Zilla::Plugin::ShareDir" => 0,
    "Dist::Zilla::Plugin::Test::Inline" => 0,
    "Dist::Zilla::Plugin::Test::Perl::Critic" => 0,
    "Dist::Zilla::Plugin::TestRelease" => 0,
    "Dist::Zilla::Role::BundleDeps" => "0.001001",
    "Dist::Zilla::Role::PluginBundle::Easy" => "5.006",
    "Moose" => "2.1005",
    "perl" => "v5.8.8"
  },
  "script_files" => [],
  "test_requires" => {}
);


my %fallback_build_requires = (
  "Module::Build" => "0.3601"
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
