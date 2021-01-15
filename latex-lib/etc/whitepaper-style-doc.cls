\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{whitepaper-style-doc}[2019/09/30 A document class for a large kg-whitepaper style doc]

\PassOptionsToPackage{final}{graphicx} % this line needs to be here if we want pictures to show up in draft mode
                                       % some packages load graphicx without options so we need to pass the final
                                       % option to graphicx with PassOptionsToPackage

\RequirePackage{xkeyval}% supports \DeclareOptionX, \ExecuteOptionsX, \ProcessOptionsX\
\RequirePackage{ifthen}
\RequirePackage{agnos-keywords}
\RequirePackage{text-box-stuff}

\newcommand{\documentClassOptionFinal}{}
\newcommand{\documentClassOptionDraft}{}
\newcommand{\documentClassType}{book}

\DeclareOptionX{final}{\renewcommand{\documentClassOptionFinal}{final}}
\DeclareOptionX{draft}{\renewcommand{\documentClassOptionDraft}{draft}}
\DeclareOptionX{book}{\renewcommand{\documentClassType}{extbook}}
\DeclareOptionX{article}{\renewcommand{\documentClassType}{article}}

%\DeclareOptionX*{\PackageWarning{use-case-standalone}{`\CurrentOption' ignored}}% For unknown options
%
% Process the above options
%
\ExecuteOptionsX{final}
\ProcessOptionsX\relax

%\ifthenelse{\equal{\documentClassOptionFinal}{final}}{\typeout{xxx}}{\typeout{yyy}}

\typeout{whitepaper-style-doc: documentClassOptionFinal=\documentClassOptionFinal}
\typeout{whitepaper-style-doc: documentClassOptionDraft=\documentClassOptionDraft}

%
% Any fontsize smaller than 10pt is not supported by the standard classes book, report and article.
% For smaller sizes use the extsizes package which gives extbook, extarticle etc.
%
\LoadClass[\documentClassOptionFinal,10pt,oneside]{\documentClassType}

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

\providecommand{\customerCode}{agnos}% set the default

\ifthenelse{\equal{\customerCode}{somecust}}
{\RequirePackage{header-and-footer-stuff-somecust}}
{\RequirePackage{header-and-footer-stuff}}%

\RequirePackage{xkeyval}
%\RequirePackage{ifdraft}
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
  \begin{quote}\itshape\large``#1''\end{quote}%
  \begin{flushright}%
    - #2\footnote{\url{#3}}%
  \end{flushright}%
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
  \renewcommand\contentsname{Table of Contents}%
  \tableofcontents%
  \clearpage%
}
%
% Insert the following at the beginning of the document
%
\AtBeginDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertTitlePage{}\typeout{Inserting Title Page}}
\AtBeginDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertTableOfContents{}\typeout{Inserting Table of Contents}}
%
% Insert the following at the end of the document
%
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintGlossary} % \insertPrintGlossary is defined in glossary-stuff.cls
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintBibliography}
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintIndex}
\AtEndDocument{\global\expandafter\let \csname @nodocument\endcsname \relax\insertPrintTodos}
