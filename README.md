# EKG Maturity

This repository contains the [Markdown](https://en.wikipedia.org/wiki/Markdown)
based source documents of EKG Maturity, the Maturity Model for the EKG.

![quadrant](customer-assets/quadrant.jpg)

## Website

The content in this repository is used to generate a website ([https://maturity.ekgf.org](https://maturity.ekgf.org))
using the [MkDocs](https://squidfunk.github.io/mkdocs-material/) tool.
All content is in Markdown format and can be found in the [./docs](./docs) 
or [./docs-fragments](./docs-fragments) directories.

## License

[![GitHub](https://img.shields.io/github/license/EKGF/ekg-maturity?style=for-the-badge)](http://creativecommons.org/licenses/by-sa/4.0/)

```text
Copyright (c) 2026 EDMCouncil Inc., d/b/a Enterprise Data Management Association ("EDMA")
```

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

When using or sharing this content, please provide attribution to:

- EDMCouncil Inc., d/b/a Enterprise Data Management Association ("EDMA")

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

## Where is this published?

From this git repository we generate a PDF document.
Two in fact: the "editors-version" which contains annotations and "todo's" 
and the "release-version" without those annotations.

You can find the published version
at [https://ekgf.org/maturitymodel](https://ekgf.org/maturitymodel).

!!! note

    Please note that we're in the process of generating a website for the
    maturity model here: [https://maturity-model.ekgf.org](https://maturity-model.ekgf.org)

For members of the EKGF there's also a Slack channel called
[#ekg-mm-latest](https://ekgf.slack.com/archives/C01TEL6GWEN)
where both PDFs are published every time someone pushes
a change into this repository.

!!! note

    Soon we'll also be publishing this content as HTML.

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
make install
```

## Editors

Any text editor will do. Edit the `.md` files in this repository, they're just
ASCII files.

### IntelliJ Idea or CLion

* IntelliJ has by far the best "git merge" options of any tool out there,
  if you're planning to write a lot of content then it makes sense to
  install the "community edition" (free) and get used to IntelliJ.

## Install components

If you want to run the website on your local
machine to see your content before committing
it to GitHub you can do so by first installing
all the components around "MkDocs" which is a
Python program with a lot of sub-components.

You can install this as follows:

```shell
make docs-install
```

The above command assumes you're doing this
on a MacOS machine. It has not been tested
on Windows or Linux (but it may work).

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

