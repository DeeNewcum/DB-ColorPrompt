# NAME

DB::ColorPrompt - Use ANSI colors to highlight your prompt within the Perl debugger

# SYNOPSIS

In your `~/.perldb` file, add this:

    use DB::ColorPrompt 'black on_blue';

Any [Term::ANSIColor](https://metacpan.org/pod/Term%3A%3AANSIColor) color sequence works.

There's actually a second color for typeahead prompts (see below). That can be
specified like this:

    use DB::ColorPrompt 'black on_blue', 'green';

The typeahead prompt defaults to foreground-blue.

# DESCRIPTION

When used alongside the [default debugger](https://metacpan.org/pod/perldebug), this provides the ability
to hilight the prompt in the given color.

## What's this "typeahead" thing?

[perl5db.pl](https://metacpan.org/pod/perl5db.pl) doesn't have a way to directly do something like:

    DB::run_debugger_command('b my_subroutine');

# COMPATIBILITY

This has been tested with Perl 5.6.0 through Perl 5.36.0, and it's anticipated
to work as far back as Perl 5.004 at least.

It also works without _any_ extra dependencies, so installation could be as
simple as just downloading DB/ColorPrompt.pm to the right place. (however,
before Perl 5.6.0, Term::ANSIColor wasn't included in Perl core, and in that
case it would need to be installed separately).

# SEE ALSO

There are several other modules that are designed to be `use`d from within
`~/.perldb`:

- [DB::Color](https://metacpan.org/pod/DB%3A%3AColor) -- Provides syntax highlighting using ANSI sequences, within
the Perl debugger.

# AUTHOR

Dee Newcum <deenewcum@cpan.org>

# CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

# LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.
