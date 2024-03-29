package DB::ColorPrompt;

our $VERSION = 0.01;

=pod

=head1 NAME

DB::ColorPrompt - Use ANSI colors to highlight your prompt within the Perl debugger

=head1 SYNOPSIS

In your F<~/.perldb> file, add this:

 use DB::ColorPrompt 'black on_blue';

Any L<Term::ANSIColor> color sequence works.

There's actually a second color for typeahead prompts (see below). That can be
specified like this:

 use DB::ColorPrompt 'black on_blue', 'green';

The typeahead prompt defaults to foreground-blue.

=head1 DESCRIPTION

When used alongside the L<default debugger|perldebug>, this provides the ability
to hilight the prompt in the given color.

=head2 What's this "typeahead" thing?

L<perl5db.pl> doesn't have a way to directly do something like:

 DB::run_debugger_command('b my_subroutine');

=head1 COMPATIBILITY

This has been tested with Perl 5.6.0 through Perl 5.36.0, and it's anticipated
to work as far back as Perl 5.004 at least.

It also works without I<any> extra dependencies, so installation could be as
simple as just downloading DB/ColorPrompt.pm to the right place. (however,
before Perl 5.6.0, Term::ANSIColor wasn't included in Perl core, and in that
case it would need to be installed separately).

=head1 SEE ALSO

There are several other modules that are designed to be C<use>d from within
F<~/.perldb>:

=over

=item * L<DB::Color> -- Provides syntax highlighting using ANSI sequences, within
the Perl debugger.

=back

=head1 AUTHOR

Dee Newcum <deenewcum@cpan.org>

=head1 CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

use strict;
use warnings;

use Carp;                       # core Perl, as of Perl 5.000
use Term::ANSIColor ();         # core Perl, as of Perl 5.6.0

our $interactive_color;        # the color we use when there's no typeahead
our $typeahead_color;   # the color we use when there is typeahead

my $original_readline = \&DB::readline;

sub import {
    my $class = shift;

    if (@_) {
        $interactive_color = shift;
        if (defined($interactive_color) && !_colorvalid($interactive_color)) {
            carp "'$interactive_color' isn't a valid color attribute per Term::ANSIColor";
            # Normally perl5db.pl fastidiously avoids exiting. Tell it to stop
            # doing that and actually let us exit.
            $DB::inhibit_exit = 0;
            exit(1);
        }

        if (@_) {
            $typeahead_color = shift;
            if (defined($typeahead_color) && !_colorvalid($typeahead_color)) {
                carp "'$typeahead_color' isn't a valid color attribute per Term::ANSIColor";
                # Normally perl5db.pl fastidiously avoids exiting. Tell it to
                # stop doing that and actually let us exit.
                $DB::inhibit_exit = 0;
                exit(1);
            }
        } else {
            # default values
            $typeahead_color = 'blue';
        }
    } else {
        # default values
        $interactive_color = 'on_blue';
        $typeahead_color = 'blue';
    }

    # monkey-patch the DB::readline() function
    no warnings 'redefine';
    *DB::readline = \&DB::ColorPrompt::_readline;
}


# Copied from Term::ANSIColor v2.2+.
#
# Unfortunately, Term::ANSIColor v2.2 wasn't introduced until Perl 5.11.0, which
# was released in Oct 2009. I would really like our module to be easily
# compatible with previous Perls.
sub _colorvalid {
    if ($Term::ANSIColor::VERSION ge '3.0') {
        return Term::ANSIColor::colorvalid(@_);
    }
    my @codes = map { split } @_;
    for (@codes) {
        # %attributes became %ATTRIBUTES in Term::ANSIColor v2.0
        if ($Term::ANSIColor::VERSION le '2.0') {
            unless (defined $Term::ANSIColor::attributes{lc $_}) {
                return;
            }
        } else {
            unless (defined $Term::ANSIColor::ATTRIBUTES{lc $_}) {
                return;
            }
        }
    }
    return 1;
}


sub _readline {
    my ($prompt) = @_;

    # Usually there's a space at the end of the prompt. If it's there, then
    # avoid coloring it.
    my $append = '';
    if ($prompt =~ s/( )$//) {
        $append = $1;
    }

    if (@DB::typeahead) {
        if (defined($typeahead_color)) {
            return $original_readline->(
                Term::ANSIColor::colored($prompt, $typeahead_color)
                . $append);
        } else {
            return $original_readline->($prompt . $append);
        }
    } else {
        if (defined($interactive_color)) {
            return $original_readline->(
                Term::ANSIColor::colored($prompt, $interactive_color)
                . $append);
        } else {
            return $original_readline->($prompt . $append);
        }
    }
}

1;
