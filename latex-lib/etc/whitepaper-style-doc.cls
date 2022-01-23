%
% whitepaper-style-doc.cls
%
% Can be configured via options in the calling doc like this:
%
% \documentclass[draft,book]{whitepaper-style-doc}
%
% or, if no options like 'draft' and 'book' are given, it takes
% the values from these vars (which may be set in the .latexmkrc file)
%
% \documentMode{draft} or \documentMode{final}
% \documentClass{book} or \documentClass{article}
%
% It also assumes that \customerCode is set (default is 'agnos-ai')
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{whitepaper-style-doc}[2019/09/30 A document class for a large kg-whitepaper style doc]

\PassOptionsToPackage{final}{graphicx} % this line needs to be here if we want pictures to show up in editors-version
                                       % some packages load graphicx without options so we need to pass the final
                                       % option to graphicx with PassOptionsToPackage

\RequirePackage{xkeyval}% supports \DeclareOptionX, \ExecuteOptionsX, \ProcessOptionsX\
\RequirePackage{ifthen}
\RequirePackage{agnos-keywords}
\RequirePackage{text-box-stuff}

\providecommand{\documentMode}{draft}
\providecommand{\documentClass}{book}
\providecommand{\customerCode}{agnos-ai}
\providecommand{\documentName}{\jobname}% provide a default for \documentName

\DeclareOptionX{final}{
  \typeout{whitepaper-style-doc.cls: Building the release-version of the document}
  \renewcommand{\documentMode}{release-version}
}
\DeclareOptionX{draft}{
  \typeout{whitepaper-style-doc.cls: Building the editors-version of the document}
  \renewcommand{\documentMode}{editors-version}
}
\DeclareOptionX{book}{
  \typeout{whitepaper-style-doc.cls: Using document class 'book'}
  \renewcommand{\documentClass}{book}
}
\DeclareOptionX{article}{
  \typeout{whitepaper-style-doc.cls: Using document class 'article'}
  \renewcommand{\documentClass}{article}
}
\DeclareOption*{\PackageWarning{whitepaper-style-doc}{Unknown ‘\CurrentOption’}}

%\DeclareOptionX*{\PackageWarning{use-case-standalone}{`\CurrentOption' ignored}}% For unknown options
%
% Process the above options, passing 'draft' as a default
%
\ExecuteOptionsX{}
\ProcessOptionsX\relax

\RequirePackage{path-stuff}% is dependent on \customerCode and \documentName

%\ifthenelse{\equal{\documentClassOptionFinal}{final}}{\typeout{xxx}}{\typeout{yyy}}

\typeout{whitepaper-style-doc.cls: jobname=\jobname}
\typeout{whitepaper-style-doc.cls: documentName=\documentName}
\typeout{whitepaper-style-doc.cls: documentMode=\documentMode}
\typeout{whitepaper-style-doc.cls: documentClass=\documentClass}
\typeout{whitepaper-style-doc.cls: customerCode=\customerCode}

%
% Any fontsize smaller than 10pt is not supported by the standard classes book, report and article.
% For smaller sizes use the extsizes package which gives extbook, extarticle etc.
%
\LoadClass[\documentMode,10pt,oneside]{\documentClass}

\RequirePackage{release-stuff}
\RequirePackage{paper-stuff}
\RequirePackage{font-stuff}
\RequirePackage{color-stuff}
\RequirePackage{listing-stuff}
\RequirePackage{header-stuff}
\RequirePackage{user-story-stuff}

\RequirePackage{todo-stuff}

\RequirePackage{fancyvrb}

\RequirePackage{tikz-stuff}
\RequirePackage{link-stuff}
\RequirePackage{table-stuff}
\RequirePackage{index-stuff}
\RequirePackage{picture-stuff}

\providecommand{\customerCode}{agnos-ai}% set the default

\RequirePackage{header-and-footer-stuff}%
\RequirePackage{xkeyval}
% \RequirePackage{release-stuff}
\RequirePackage{index-stuff}
\RequirePackage{picture-stuff}
\RequirePackage{xstring}
\RequirePackage{subfiles}
\RequirePackage{use-case-subfile}
\RequirePackage{label-stuff}
\RequirePackage{titling}
\RequirePackage{customer-assets}
\RequirePackage{glossary-stuff}
\RequirePackage{bibliography-stuff}
\RequirePackage{version-history-stuff}

%
% Quotations
%
\newcommand{\somequote}[3]{%
  \begin{quote}\itshape\large\enquote{#1}\end{quote}%
  \begin{flushright}\footnotesize- #2\footnote{\url{#3}}\end{flushright}%
}
\newcommand{\citequote}[2]{%
  \begin{quote}\itshape\large\enquote{#1}\end{quote}%
  \begin{flushright}\textcite{#2}\end{flushright}%
}

%%
%% Convoluted way to convert the value of \jobname (which has a different "Catcode" than normal strings, see
%% docs of xstring package) to a normal string before we use \StrSubstitute on it.
%%
\begingroup
  \everyeof{\noexpand}
  \endlinechar=-1
  \xdef\normaljobname{\scantokens\expandafter{\jobname}}
\endgroup


\newcommand{\insertTitlePage}{
  \importTitlePage
}

\newcommand{\insertTableOfContents}{%
  \setcounter{tocdepth}{3}%
  \renewcommand\contentsname{Contents}%
  \tableofcontents%
  \clearpage%
}
%
% Insert the following at the beginning of the document
%
% NOTE: The line below is commented out because \loadGlossaries is already doing this and it does it BEFORE
%       the title page vars are set which MAY use glossary terms. The line below would define the terms too
%       late for that to work.
% \AtBeginDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertGlossaries{}\typeout{Inserting Glossary}}
\AtBeginDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertTitlePage{}\typeout{Inserting Title Page}}
\AtBeginDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertTableOfContents{}\typeout{Inserting Table of Contents}}
%
% Insert the following at the end of the document
%
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintGlossary} % \insertPrintGlossary is defined in glossary-stuff.cls
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintBibliography}
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintIndex}
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintTodos}
%
%
% \ifdocumentname{ekg-manifesto}{
%    do nothing
% }{
%    As a reference, we include the manifesto chapter here...
% }
%
\newcommand{\ifdocumentname}[3]{%
  \ifthenelse{\equal{\detokenize{#1}}{\detokenize{\documentName}}}{#2}{#3}%
}

