# NAME

Perl::Critic::MergeProfile - merge multiple Perl::Critic profiles into one

# VERSION

Version 0.003

# SYNOPSIS

    use Perl::Critic::MergeProfile;

    my $merge = Perl::Critic::MergeProfile->new;
    $merge->read('xt/author/perlcriticrc-base');
    $merge->read('xt/author/perlcriticrc-project');
    $merge->write('xt/author/perlcriticrc-merged');

# DESCRIPTION

Merges multiple [Perl::Critic](https://metacpan.org/pod/Perl%3A%3ACritic) profiles into a single one.

This allows to keep a common base profile for all projects but add project
specific changes to the profile.

# USAGE

## new

Returns a new `Perl::Critic::MergeProfile`
instance. Arguments to `new` are ignored.

## read( FILENAME, \[ ENCODING \] )

Calls `read` from [Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) with the same arguments it
was called. Please see the documentation for `read` of
[Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) for an explanation of the parameters.

If no valid [Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) object is returned an exception is
thrown.

If this is the first call to `read` or `read_string`, the returned
[Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) object is used as the base of the new merged
profile. No checks are performed on this first profile object.

Otherwise, the returned object is checked and if the same policy is enabled
and disabled in this new profile an exception is thrown.

After that, existing entries for all policies from the new profile are
removed from the merged profile. Then the polices from the new profile are
added to the merged profile.

Entries in the global section of this profile overwrite the existing entries
with the same name in the global section.

## read\_string( STRING )

Behaves the same as `read` but calls `read_string` from
[Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny).

## write( FILENAME, \[ ENCODING \] )

An exception is thrown if no valid policy exists, because neither `read` nor
`read_string` were successfully called at least once.

Otherwise `write` from [Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) is called on the profile
with the same arguments `write` was called. Please see the documentation for
`write` of [Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny) for an explanation of the parameters.

Returns something _true_ if on success and throws an exception otherwise.

## write\_string

Behaves the same as `write` but calls `write_string` from
[Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny).

Returns the policy as string on success and throws an exception otherwise.

# EXAMPLES

## Example 1 [Test::Perl::Critic](https://metacpan.org/pod/Test%3A%3APerl%3A%3ACritic)

The following test script can be used to test your code with
[Perl::Critic](https://metacpan.org/pod/Perl%3A%3ACritic) with a merged profile.

    use 5.006;
    use strict;
    use warnings;

    use Test::More;
    use Perl::Critic::MergeProfile;

    eval {
        my $merge = Perl::Critic::MergeProfile->new;
        $merge->read('xt/author/perlcriticrc-base');
        $merge->read('xt/author/perlcriticrc-project');

        my $profile = $merge->write_string;

        require Test::Perl::Critic;
        Test::Perl::Critic->import(-profile => \$profile);
        1;
    } || do {
        my $error = $@;
        BAIL_OUT($error);
    };

    all_critic_ok();

# SEE ALSO

[Config::Tiny](https://metacpan.org/pod/Config%3A%3ATiny), [Perl::Critic](https://metacpan.org/pod/Perl%3A%3ACritic),
[Test::Perl::Critic](https://metacpan.org/pod/Test%3A%3APerl%3A%3ACritic)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/skirmess/Perl-Critic-MergeProfile/issues](https://github.com/skirmess/Perl-Critic-MergeProfile/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/skirmess/Perl-Critic-MergeProfile](https://github.com/skirmess/Perl-Critic-MergeProfile)

    git clone https://github.com/skirmess/Perl-Critic-MergeProfile.git

# AUTHOR

Sven Kirmess <sven.kirmess@kzone.ch>
