# EKG/MM

This repository contains the [LaTeX](https://www.latex-project.org/about/)
based source documents of EKG/MM, the Maturity Model for the EKG.

## License

![shield](https://img.shields.io/github/license/EKGF/ekg-mm.svg)

[x](http://creativecommons.org/licenses/by-sa/4.0/)

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

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

## Where to find the content?

The "raw" LaTeX source documents (see LaTeX below for an explanation) can be
found in the [/ekg-mm](ekg-mm) directory and more specifically in the
[/ekg-mm/sections](ekg-mm/sections) directory.

## LaTeX

[LaTeX](https://www.latex-project.org/about/), which is pronounced «Lah-tech»
or «Lay-tech» (to rhyme with «blech» or «Bertolt Brecht»), is a document
preparation system for high-quality typesetting.
It is most often used for medium-to-large technical or scientific documents
but it can be used for almost any form of publishing.

LaTeX is not a word processor! Instead, LaTeX encourages authors not to worry
too much about the appearance of their documents but to concentrate on getting
the right content.

!!! note

    See also https://www.latex-project.org/about/

## Github

This repository resides on GitHub as https://github.com/EKGF/ekg-mm.

### How to clone?

For advanced users who often contribute to this repository, it's best to
create a so-called `git clone` of this git repository on the local drive which
allows any given LaTeX editor to be used locally to create new content.

First, install git and/or GitHub Desktop.

How to create a clone of the GitHub repo:

```shell
cd ~ # go to your home directory or the directory where you want your git clones to be
git clone https://github.com/EKGF/ekg-mm
cd ekg-mm
make install
```

### How to create a new version of the PDFs?

Various PDF documents are generated from the content in this repository.

### How to view generated PDFs?

Get a PDF viewer that can automatically reload the generated document
so that you can keep the PDF viewer open in another window while it
is being regenerated continuously during editing.

#### Mac OS

* use Preview.app on Mac
* or install Skim(download [here](https://skim-app.sourceforge.io/) or type `make install`)

#### Linux

TODO

#### Windows

TODO

## Editors

Any text editor will do. Edit the `.tex` files in this repository, they're just
ASCII files.

### IntelliJ Idea or CLion

* IntelliJ has by far the best "git merge" options of any tool out there,
  if you're planning to write a lot of content then it makes sense to
  install the "community edition" (free) and get used to IntelliJ.
* [TeXiFy Intellij plugin](https://github.com/Hannah-Sten/TeXiFy-IDEA) - allows
  you to compile the document just like it's a source code of any programming language.

## Build steps

To construct the PDF from all the various LaTex documents in this repository we use
the `latexmk` command which is bundled with your LaTeX installation.

To launch the default PDF viewer after each "build" if you run the `latexmk` command
with the `-pvc` option:

For instance, for the `release-version` of EKGF's `ekg-mm` document:

```shell
make release-version
```


