# Mix Bump

This is a simple mix task to version bump a mix project.

## Installation

```
  mix archive.install hex mix_bump
```

## Usage

```
  mix bump [major | minor | patch | <newversion>]

  options:
    -m, --message  <message>
                     Commit message
    -p, --publish    Publish package to hex
    -t, --tag <name> Specify a tag
    -a, --annotated  Use annotated tags ( Enabled by default --no-annotated to use simple tags)
```
