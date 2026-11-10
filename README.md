# homebrew-tap

Homebrew tap for tools published by [flushwhy](https://github.com/flushwhy).

## Install Fe

Requires macOS and [Homebrew](https://brew.sh/).

The unversioned formula tracks the newest stable Fe release:

```sh
brew tap flushwhy/tap
brew install fe
```

### Install a specific release line

Versioned formulae stay on their minor release line while receiving its latest
patch and security updates:

```sh
brew install flushwhy/tap/fe@0.8
brew install flushwhy/tap/fe@0.7
```

These versioned formulae are keg-only so they can coexist with each other and
the main `fe` formula without replacing the `fe` command on your PATH. Run a
versioned install directly with:

```sh
"$(brew --prefix fe@0.7)/bin/fe" --help
```

Or add that version to your PATH:

```sh
export PATH="$(brew --prefix fe@0.7)/bin:$PATH"
```

Formula updates are generated from Fe's published GitHub release assets and
submitted as pull requests for review.
