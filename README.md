# NAME

DB::ColorPrompt - Use ANSI colors to highlight your prompt within the Perl debugger

# SYNOPSIS

In your `~/.perldb` file, add this:

    use DB::ColorPrompt 'black on_blue';

Any [Term::ANSIColor](https://metacpan.org/pod/Term%3A%3AANSIColor) color sequence works.

# DESCRIPTION

When used alongside the [perldebug](https://metacpan.org/pod/default%20debugger), this provides the ability
to hilight the prompt in the given color.

# AUTHOR

Dee Newcum <deenewcum@cpan.org>

# CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

# LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.
