# NAME

Perl::Critic::MergeProfile - merge multiple Perl::Critic profiles into one

# VERSION

Version 0.002

# SYNOPSIS

    use Perl::Critic::MergeProfile;

    my $merge = Perl::Critic::MergeProfile->new;
    $merge->read('xt/author/perlcriticrc-base');
    $merge->read('xt/author/perlcriticrc-project');
    $merge->write('xt/author/perlcriticrc-merged');

# DESCRIPTION

Merges multiple [Perl::Critic](https://metacpan.org/pod/Perl::Critic) profiles into a single one.

This allows to keep a common base profile for all projects but add project
specific changes to the profile.

# USAGE

## new

Returns a new `Perl::Critic::MergeProfile`
instance. Arguments to `new` are ignored.

## read( FILENAME, \[ ENCODING \] )

Calls `read` from [Config::Tiny](https://metacpan.org/pod/Config::Tiny) with the same arguments it
was called. Please see the documentation for `read` of
[Config::Tiny](https://metacpan.org/pod/Config::Tiny) for an explanation of the parameters.

If no valid [Config::Tiny](https://metacpan.org/pod/Config::Tiny) object is returned an exception is
thrown.

If this is the first call to `read` or `read_string`, the returned
[Config::Tiny](https://metacpan.org/pod/Config::Tiny) object is used as the base of the new merged
profile. No checks are performed on this first profile object.

Otherwise, the returned object is checked and if the same policy is enabled
and disabled in this new profile an exception is thrown.

After that, existing entries for this policy are removed from the base policy
and a new entry either a disabled or enabled policy is added.

Entries in the global section of this profile overwrite the existing entries
with the same name in the global section.

## read\_string( STRING )

Behaves the same as `read` but calls `read_string` from
[Config::Tiny](https://metacpan.org/pod/Config::Tiny).

## write( FILENAME, \[ ENCODING \] )

An exception is thrown if no valid policy exists, because neither `read` nor
`read_string` were successfully called at least once.

Otherwise `write` from [Config::Tiny](https://metacpan.org/pod/Config::Tiny) is called on the profile
with the same arguments `write` was called. Please see the documentation for
`write` of [Config::Tiny](https://metacpan.org/pod/Config::Tiny) for an explanation of the parameters.

Returns something _true_ if on success and throws an exception otherwise.

## write\_string

Behaves the same as `write` but calls `write_string` from
[Config::Tiny](https://metacpan.org/pod/Config::Tiny).

Returns the policy as string on success and throws an exception otherwise.

# EXAMPLES

## Example 1 [Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic)

The following test script can be used to test your code with
[Perl::Critic](https://metacpan.org/pod/Perl::Critic) with a merged profile.

    use 5.006;
    use strict;
    use warnings;

    use Test::More 0.88;
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

[Config::Tiny](https://metacpan.org/pod/Config::Tiny), [Perl::Critic](https://metacpan.org/pod/Perl::Critic),
[Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic)

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

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Sven Kirmess.

This is free software, licensed under:

    The (two-clause) FreeBSD License
