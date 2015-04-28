package Pulp::Folio {
    use Moose;
    use Path::Tiny;

    has 'original_filename' => (
        is => 'ro',
        predicate => 'has_original_filename',
    );

    has "content" => (
        isa => 'Str',
        is => 'rw',
        lazy => 1,
        default => sub {
            my $self = shift;

            return '' unless $self->has_original_filename;

            path($self->original_filename)->slurp;
        },
    );

    has "filename" => (
        isa => 'Str',
        is => 'rw',
        lazy => 1,
        default => sub { $_[0]->original_filename },
    );

    sub write {
        my $self = shift;
        my $p = path($self->filename);
        $p->parent->mkpath;
        $p->spew($self->content);
    }

    # TODO don't copy when you don't need to
    sub copy {
        my $self = shift;
        return __PACKAGE__->new(
            map { $_ => $self->$_ } qw/ original_filename filename content /
        );
    }

};

1;

