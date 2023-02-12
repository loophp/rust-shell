![GitHub stars][github stars] [![Donate!][donate github]][5]

# Rust shell

## Description

This package provides a `Nix flake` ready to use for Rust development, using the
[`Nix` package manager][50] which can be installed on (_almost_) any operating
system.

Each available environment provides the following tools:

- Rust,
- Cargo

Available Rust versions are:

- `stable`
- `beta`

Available Rust profiles are:

- `default`
- `minimal`

## Usage

To work with `Rust beta with default profile`:

```shell
nix develop github:loophp/rust-shell#beta-default
```

Available Rust shells are:

- `stable-default`
- `stable-minimal`
- `beta-default`
- `beta-minimal`

### With direnv

To use it in your Rust project with nix-direnv, just create a file `.envrc` with
the following content:

```
use flake github:loophp/rust-shell
```

## Contributing

Feel free to contribute by sending pull requests. We are a usually very
responsive team and we will help you going through your pull request from the
beginning to the end.

For some reasons, if you can't contribute to the code and willing to help,
sponsoring is a good, sound and safe way to show us some gratitude for the hours
we invested in this package.

Sponsor me on [Github][5] and/or any of [the contributors][6].

## Changelog

See [CHANGELOG.md][43] for a changelog based on [git commits][44].

For more detailed changelogs, please check [the release changelogs][45].

[latest stable version]:
  https://img.shields.io/packagist/v/loophp/rust-shell.svg?style=flat-square
[github stars]:
  https://img.shields.io/github/stars/loophp/rust-shell.svg?style=flat-square
[total downloads]:
  https://img.shields.io/packagist/dt/loophp/rust-shell.svg?style=flat-square
[github workflow status]:
  https://img.shields.io/github/workflow/status/loophp/rust-shell/Unit%20tests?style=flat-square
[code quality]:
  https://img.shields.io/scrutinizer/quality/g/loophp/rust-shell/master.svg?style=flat-square
[3]: https://scrutinizer-ci.com/g/loophp/rust-shell/?branch=master
[type coverage]:
  https://img.shields.io/badge/dynamic/json?style=flat-square&color=color&label=Type%20coverage&query=message&url=https%3A%2F%2Fshepherd.dev%2Fgithub%2Floophp%2Fcollection%2Fcoverage
[4]: https://shepherd.dev/github/loophp/rust-shell
[code coverage]:
  https://img.shields.io/scrutinizer/coverage/g/loophp/rust-shell/master.svg?style=flat-square
[license]:
  https://img.shields.io/packagist/l/loophp/rust-shell.svg?style=flat-square
[donate github]:
  https://img.shields.io/badge/Sponsor-Github-brightgreen.svg?style=flat-square
[34]: https://github.com/loophp/rust-shell/issues
[2]: https://github.com/loophp/rust-shell/actions
[35]: http://www.phpspec.net/
[36]: https://github.com/phpro/grumphp
[37]: https://github.com/infection/infection
[38]: https://github.com/phpstan/phpstan
[39]: https://github.com/vimeo/psalm
[5]: https://github.com/sponsors/drupol
[6]: https://github.com/loophp/rust-shell/graphs/contributors
[43]: https://github.com/loophp/rust-shell/blob/master/CHANGELOG.md
[44]: https://github.com/loophp/rust-shell/commits/master
[45]: https://github.com/loophp/rust-shell/releases
[46]: https://nixos.org/guides/nix-pills/developing-with-rust-shell.html
[50]: https://nixos.org/download.html
