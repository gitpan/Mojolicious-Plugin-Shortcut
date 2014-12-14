#!perl

BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(
      skip_all => 'these tests are for release candidate testing');
  }
}

# This file was automatically generated by Dist::Zilla::Plugin::PodSyntaxTests.
use Test::More;
use Test::Pod 1.41;

all_pod_files_ok();
