package Hydra::Plugin::GiteaPulls;

use strict;
use warnings;
use parent 'Hydra::Plugin';
use HTTP::Request;
use LWP::UserAgent;
use JSON::MaybeXS;
use Hydra::Helper::CatalystUtils;
use File::Temp;
use POSIX qw(strftime);

sub supportedInputTypes {
    my ($self, $inputTypes) = @_;
    $inputTypes->{'giteapulls'} = 'Open Gitea Pull Requests';
}

sub _iterate {
    my ($url, $page, $auth, $pulls, $ua) = @_;
    my $req = HTTP::Request->new('GET', "$url&page=$page");
    $req->header('Accept' => 'application/json');
    $req->header('Authorization' => $auth) if defined $auth;
    my $res = $ua->request($req);
    my $content = $res->decoded_content;
    die "Error pulling from the gitea pulls API: $content\n"
        unless $res->is_success;
    my $pulls_list = decode_json $content;
    # TODO Stream out the json instead
    foreach my $pull (@$pulls_list) {
        $pulls->{$pull->{number}} = $pull;
    }
    _iterate($url, $page + 1, $auth, $pulls, $ua) unless !@$pulls_list;
}

sub fetchInput {
    my ($self, $type, $name, $value, $project, $jobset) = @_;
    return undef if $type ne "giteapulls";
    # TODO Allow filtering of some kind here?
    (my $domain, my $owner, my $repo) = split ' ', $value;
    my $auth = $self->{config}->{gitea_authorization}->{$owner};
    my %pulls;
    my $ua = LWP::UserAgent->new();
    _iterate("https://$domain/api/v1/repos/$owner/$repo/pulls?status=open&per_page=100", 1, $auth, \%pulls, $ua);
    my $tempdir = File::Temp->newdir("gitea-pulls" . "XXXXX", TMPDIR => 1);
    my $filename = "$tempdir/gitea-pulls.json";

    open(my $fh, ">", $filename) or die "Cannot open $filename for writing: $!";
    print $fh JSON->new->utf8->canonical->encode(\%pulls);
    close $fh;

    my $storePath = trim(`nix-store --add "$filename"`
        or die "cannot copy path $filename to the Nix store.\n");
    chomp $storePath;
    my $timestamp = time;
    return { storePath => $storePath, revision => strftime "%Y%m%d%H%M%S", gmtime($timestamp) };
}

1;
