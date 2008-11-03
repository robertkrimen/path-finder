package Path::Finder;

use warnings;
use strict;

=head1 NAME

Path::Finder -

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

=cut

use Moose;

use Path::Finder::Target;
use Path::Finder::Match;

has targets => qw/reader _targets required 1 isa ArrayRef/, default => sub { [] };
has __sorted_targets => qw/is rw isa Maybe[ArrayRef]/;

sub target {
    my $self = shift;
    my $target = Path::Finder::Target->new(@_);
    push @{ $self->_targets }, $target;
    $self->__sorted_targets(undef);
}

sub _sorted_targets {
    my $self = shift;

    my $sorted = $self->__sorted_targets;
    return @$sorted if $sorted;

    my @sorted =
    sort {
        $b->rank cmp $a->rank or
        $b->length cmp $a->length
    }
    @{ $self->_targets };

    $self->__sorted_targets(\@sorted);

    return @sorted;
}

sub find {
    my $self = shift;
    my $path = shift;

    my $match = Path::Finder::Match->new;
    my @targets = $self->_sorted_targets;
    for my $target (@targets) {
        if ($target->match($path)) {
            $match->add($target);
        }
    }
    return $match if $match->found;
    return undef;
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 SOURCE

You can contribute or fork this project via GitHub:

L<http://github.com/robertkrimen/path-finder/tree/master>

    git clone git://github.com/robertkrimen/path-finder.git Path-Finder

=head1 BUGS

Please report any bugs or feature requests to C<bug-path-finder at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Path-Finder>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Path::Finder


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Path-Finder>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Path-Finder>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Path-Finder>

=item * Search CPAN

L<http://search.cpan.org/dist/Path-Finder>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Path::Finder
