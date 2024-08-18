# Hacking

This section provides some notes on how to hack on Hydra. To get the
latest version of Hydra from GitHub:

```console
$ git clone git://github.com/NixOS/hydra.git
$ cd hydra
```

To enter a shell in which all environment variables (such as `PERL5LIB`)
and dependencies can be found:

```console
$ nix develop
```

To build Hydra, you should then do:

```console
[nix-shell]$ just setup
[nix-shell]$ just install
```

You start a local database, the webserver, and other components with
foreman:

```console
$ foreman start
```

The Hydra interface will be available on port 63333, with an admin user named "alice" with password "foobar"

You can run just the Hydra web server in your source tree as follows:

```console
$ ./src/script/hydra-server
```

You can run Hydra's test suite with the following:

```console
[nix-shell]$ just test
[nix-shell]$ # or run yath directly:
[nix-shell]$ yath test
[nix-shell]$ # to run as many tests as you have cores:
[nix-shell]$ yath test -j $NIX_BUILD_CORES
```

**Warning**: Currently, the tests can fail
if run with high parallelism [due to an issue in
`Test::PostgreSQL`](https://github.com/TJC/Test-postgresql/issues/40)
causing database ports to collide.

## Working on the Manual

By default, `foreman start` runs mdbook in "watch" mode. mdbook listens
at [http://localhost:63332/](http://localhost:63332/), and
will reload the page every time you save.

## Building

To build Hydra and its dependencies:

```console
$ nix-build release.nix -A build.x86_64-linux
```

## Development Tasks

### Connecting to the database

Assuming you're running the default configuration with `foreman start`,
open an interactive session with Postgres via:

```console
$ psql --host localhost --port 64444 hydra
```

### Runinng the builder locally

For `hydra-queue-runner` to successfully build locally, your
development user will need to be "trusted" by your Nix store.

Add yourself to the `trusted_users` option of `/etc/nix/nix.conf`.

On NixOS:

```nix
{
  nix.settings.trusted-users = [ "YOURUSER" ];
}
```

Off NixOS, change `/etc/nix/nix.conf`:

```conf
trusted-users = root YOURUSERNAME
```

### Updating schema bindings

```
just update-dbix
```

### Find the builds with the highest number of build steps:

        select id, (select count(*) from buildsteps where build = x.id) as n from builds x order by n desc;

