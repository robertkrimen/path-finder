package Path::Finder::Match;

use warnings;
use strict;

use Moose;
use Path::Finder::Carp;

has _slots => qw/is ro required 1 isa HashRef/, default => sub { {} };
has found => qw/is rw required 1 isa Int default 0/;

sub slot {
    my $self = shift;
    my $slot = shift;
    $slot = '' unless defined $slot;
    return $self->_slots->{$slot} ||= Path::Finder::Match::Slot->new;
}

sub add {
    my $self = shift;
    my $target = shift;
    $self->slot($target->slot)->add($target);
    $self->found($self->found + 1);
}

package Path::Finder::Match::Slot;

use warnings;
use strict;

use Moose;
use Path::Finder::Carp;

has targets => qw/reader _targets required 1 isa ArrayRef/, default => sub { [] };

sub add {
    my $self = shift;
    my $target = shift;
    push @{ $self->_targets }, $target;
}

sub all {
    my $self = shift;
    return @{ $self->_targets };
}

sub first {
    my $self = shift;
    $self->_targets->[0];
}

sub last {
    my $self = shift;
    $self->_targets->[-1];
}

1;
