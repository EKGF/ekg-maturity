# EKG/Maturity

This repository contains all the content that we have for the Maturity Model
for the Enterprise Knowledge Graph (EKG/Maturity). It is used to generate
this website: [https://maturity.ekgf.org](https://maturity.ekgf.org).

![quadrant](customer-assets/quadrant.jpg)

## License

[![GitHub](https://img.shields.io/github/license/EKGF/ekg-maturity?style=for-the-badge)](http://creativecommons.org/licenses/by-sa/4.0/)

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

For members of the [EKGF](https://www.ekgf.org) there are a number of Slack channels:

- [#ekg-maturity-general](https://ekgf.slack.com/archives/C016DU529DE)
- [#ekg-maturity-pillar-business](https://ekgf.slack.com/archives/C01JF3MJQBX)
- [#ekg-maturity-pillar-organization](https://ekgf.slack.com/archives/C01JWRDL6P3)
- [#ekg-maturity-pillar-data](https://ekgf.slack.com/archives/C01JF3XKDN1)
- [#ekg-maturity-pillar-technology](https://ekgf.slack.com/archives/C01J3DC930F)

## Where to find the content?

The "raw" Markdown source documents (see Markdown below for an explanation) can be
found in the [/docs](docs) directory and more specifically in the
[/docs-fragments](docs-fragments) directory.

## Markdown

Markdown is a lightweight markup language for creating formatted text using a plain-text editor.

For a quick overview of what you need to understand of Markdown look at this ["Markdown cheat sheet"](https://www.markdownguide.org/cheat-sheet/).

## Github

This repository resides on GitHub as https://github.com/EKGF/ekg-maturity.

### How to clone?

For advanced users who often contribute to this repository, it's best to
create a so-called `git clone` of this git repository on the local drive which
allows any given LaTeX editor to be used locally to create new content.

First, install git and/or GitHub Desktop.

How to create a clone of the GitHub repo:

```shell
cd ~ # go to your home directory or the directory where you want your git clones to be
git clone https://github.com/EKGF/ekg-maturity
cd ekg-maturity
make docs-install
```

## Editors

Any text editor will do. Edit the `.md` files in this repository, they're just
ASCII files.

### IntelliJ Idea or CLion

* IntelliJ has by far the best "git merge" options of any tool out there,
  if you're planning to write a lot of content then it makes sense to
  install the "community edition" (free) and get used to IntelliJ.

## Build steps

To construct the website from all the various Markdown documents in this repository we use
the `mkdocs` command which can be installed by executing `make docs-install` from the
root directory of your git clone.

Then building the static HTML website can be done with this command:
```shell
make docs-build
```

Then serving the static HTML website locally on your own computer:
```shell
make docs-serve
```

