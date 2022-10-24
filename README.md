# birdclef-eda-f22

This repository is to track progress of projects done in the [BirdCLEF EDA F22
project][proposal] with the Data Science at Georgia Tech club (DS@GT).

This is effectively a mono-repo to capture the work of a handful of contributors
to the project. As such, we will be utilizing a user directory prefixed with the
users gatech (or github) handle. For example, the directory for @acmiyaguchi is
`users/acmiyaguchi`.

All changes should be made on separate branches, and merged via pull requests
onto the main branch. The separate user directories should prevent most
conflicts, but there may be useful shared utilities that can be placed into a
centralized directory.

[proposal]: https://docs.google.com/document/d/1LlIJ82Qw142Avfo3VcVhkK1kq9XD4p2I1_3FBLE5acc

## quickstart

To get started, clone the repository and install the dependencies:

```bash
# if you don't have pre-commit installed
pip install pre-commit

# ensure that you have pre-commit rules installed
pre-commit install
```
