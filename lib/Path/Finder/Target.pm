package Path::Finder::Target;

use warnings;
use strict;

use Moose;
use Path::Finder::Carp;

has path => qw/is ro/;
has matcher => qw/is ro/;
has slot => qw/is ro isa Maybe[Str]/;
has rank => qw/is ro isa Int lazy_build 1/;
sub _build_rank {
    return 0;
}
has length => qw/is ro isa Int/;
has content => qw/is ro/;

sub BUILD {
    my $self = shift;
    my $given = shift;

    $self->{matcher} = $given->{match} if ! $self->matcher && defined $given->{match};
    $self->{matcher} = qr/@{[ $self->{matcher} ]}/ if $self->matcher && ! ref $self->{matcher};
    
    my $length = 0;
    if (my $path = $given->{path}) {
        $length = length($path.'');
        if (! $self->matcher) {
            $self->{matcher} = qr/^$path$/;
        }
    }
    $self->{length} = $length;

    unless (defined $self->matcher) {
        croak "Wasn't given a matcher for path"; 
    }
}

sub match {
    my $self = shift;
    my $path = shift;

    my $matcher = $self->matcher;
    if (ref $matcher eq 'CODE') {
        return $matcher->($path);
    }
    elsif (ref $matcher eq 'Regexp') {
        return $path =~ $matcher;
    }
    else {
        croak "Don't know how to match with $matcher";
    }
}

1;
