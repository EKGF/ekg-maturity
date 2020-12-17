# EKG/MM

This repository contains the LaTeX based source documents of EKG/MM, the Maturity Model for the EKG.

## Where to find the content?

The "raw" LaTeX source documents (see LaTeX below for an explanation) can be found in the [/ekg-mm](./ekg-mm) directory
and more specifically in the [/ekg-mm/sections](./ekg-mm/sections) directory.

## LaTeX

[LaTeX](https://www.latex-project.org/about/), which is pronounced «Lah-tech» or «Lay-tech» (to rhyme 
ith «blech» or «Bertolt Brecht»), is a document preparation system for high-quality typesetting. 
It is most often used for medium-to-large technical or scientific documents but it can be used for 
almost any form of publishing.

LaTeX is not a word processor! Instead, LaTeX encourages authors not to worry too much about the appearance of 
their documents but to concentrate on getting the right content. 

See https://www.latex-project.org/about/

## Github

This repository resides on Github:

- [Github](https://github.com/EKGF/ekg-mm)

### clone

For advanced users who contribute often to this repository, it's best to create a so-called "clone" of this git
repository on the local drive which allows any given LaTeX editor to be used locally to create new content.

First, install git and/or Github Desktop.

How to create a clone of the github repo:

```
cd ~ # go to your home directory or the directory where you want your git clones to be
git clone https://github.com/EKGF/ekg-mm
cd kg-mm
```

## Create PDFs

Various PDF documents are generated from the content in this repository.

### Prerequisites

* Docker for Mac or Docker for Windows
* PDF viewer that can automatically reload the generated document so that you can keep the PDF viewer open in another window
    * use Preview.app on Mac
    * or install Skim (download [here](https://skim-app.sourceforge.io/))

### Docker

* From project root, run:
```
./build-all.sh
```
* The `./build-all.sh` command will build all documents using your local Docker installation.
  It can take a long time. Use the `./build.sh` command to build individual documents.
* The docker image is several GBs large so it will take time to download the first time.
  It will be cached on your machine's docker registry.
* The PDF files will be generated and stored in the [./out](./out) directory.

## Editors

### TexLive

Install texlive editor. On Mac:

```
brew cask install mactex
```

### IntelliJ

* IntelliJ has by far the best "git merge" options of any tool out there,if you're planning to write a lot of content
  then it makes sense to install the "community edition" (free) and get used to IntelliJ.
* [TeXiFy Intellij plugin](https://github.com/Hannah-Sten/TeXiFy-IDEA) - allow you to compile the document just like
  it's a source code of any programming language. It will launch the default PDF viewer after each "build" if you
  launch `./build.sh` or './build-all.sh' with the `--open' option.

## Build steps

One option to build the PDF file is to do it from the command line,
which should work in Windows as well but this example is just for
Mac OS X:

```
./build.sh --open <document name>
```

Where `<document name>` is any of the names of the top level documents
in this repository such as `ekg-mm`.

This executes the `build.sh` script (see [./build.sh](./build.sh)) which is a Bash script that executes the `lualatex`
command and some other LaTeX commands to product the final PDF file which, when successful (and when you used
the `--open` option) opens the PDF with the default PDF viewer installed on your system.

It is recommended to install the Adobe Acrobat Reader or Skim since those PDF viewers support automatic refresh when you
generated a new version of the document.

### Other options for `./build.sh`

* `--local`
  The `--local` option instructs the build script to not use your
  local Docker installation to run the build but to use your local
  installation of LaTeX which can decrease the build time by at
  least 10%. If you have a fast internet connection and enough
  diskspace then install the Mac OS X version of LaTeX,
  see instructions [here](http://www.tug.org/mactex/).
* `--draft` and `--final`
  You can instruct the build script to only build the 'final' version
  of a given document by using the `--final` option. If you then also
  want to build the draft version add `-draft` as well. If you leave
  both options out then you only get the draft version.
* `--customer <customer code>`
  This command instructs the build script to not assume `agnos` as
  the customer code but `ekgf` or something else. Some customer specific
  documents will then be generated with the right logo and styling.

# Build with arara

Another way to build the PDF document is by using the `arara` tool which
should be installed on your machine if you have installed TexLive.

```
cd kg-mm
arara -v kg-mm.tex
```

# Build from IntelliJ

Install the Texify plugin which will allow you to compile the document
just like it's a source code of any programming language. It will launch
the default PDF viewer after each compile. You need a PDF viewer that
can automatically reload the generated document so that you can keep
the PDF viewer open in another window. The standard Mac OS X PDF viewer
(called Preview.app) can do that or install Skim.

### Cleaning up

There's also a `clean.sh` script that removes all temporary files:

```
./clean.sh
```

