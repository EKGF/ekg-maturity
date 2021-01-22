\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{use-case-standalone}[2019/09/17 A document class for showing one top-level use case]

\LoadClass[final,12pt,oneside]{article}

\RequirePackage{xkeyval}
\RequirePackage{import}
\RequirePackage[\documentMode]{ifdraft}
\RequirePackage{paper-stuff}
\RequirePackage{font-stuff}
\RequirePackage{color-stuff}
\RequirePackage{listing-stuff}
\RequirePackage{tikz-stuff}
\RequirePackage{link-stuff}
\RequirePackage{table-stuff}
\ifthenelse{\equal{\customerCode}{somecust}}
{\RequirePackage{header-and-footer-stuff-somecust}}
{\RequirePackage{header-and-footer-stuff}}%
\RequirePackage{index-stuff}
\RequirePackage{todo-stuff}
\RequirePackage{picture-stuff}
\RequirePackage{xstring}
\RequirePackage{subfiles}
\RequirePackage{label-stuff}
\RequirePackage{use-case-tikz-stuff}
\RequirePackage{titling}
\RequirePackage{customer-assets}
\RequirePackage{glossary-stuff}
\RequirePackage{bibliography-stuff}
%
% Convoluted way to convert the value of \jobname (which has a different "Catcode" than normal strings, see
% docs of xstring package) to a normal string before we use \StrSubstitute on it.
%
\begingroup
  \everyeof{\noexpand}
  \endlinechar=-1
  \xdef\normaljobname{\scantokens\expandafter{\jobname}}
\endgroup

%
% Strip the "use-case-" postfix from the job name to calculate the default usecaseLabel value
%
\StrSubstitute{\normaljobname}{use-case-}{}[\defaultUsecaseLabel]

\typeout{use-case-standalone.cls: use case label is \defaultUsecaseLabel}

\newcommand{\usecaseLabel}{\defaultUsecaseLabel}
\newcommand{\usecaseTitle}{Unknown Title}

%\DeclareOptionX{usecaseLabel}{\renewcommand{\usecaseLabel}{#1}}
%\DeclareOptionX*{\PackageWarning{use-case-standalone}{`\CurrentOption' ignored}}% For unknown options
%
% Process the above options
%
%\ExecuteOptionsX{usecaseLabel=\defaultUsecaseLabel}
%\ProcessOptionsX\relax

\typeout{use-case-standalone.cls: A1 \usecaseLabel, title=\usecaseTitle}
\readUseCaseTitleFromFile{\usecaseLabel}
\typeout{use-case-standalone.cls:  A2 \usecaseLabel, title=\usecaseTitle}

%
% Title page variables
%
\title{\usecaseTitle}
\def\subtitleLineA{a description of the use case}
\def\subtitleLineB{}
\author{\agnos}
\date{\today}

\newcommand{\importMainUseCaseDocument}{\input{../use-cases/\usecaseLabel/\usecaseLabel.tex}}

\newcommand{\importUseCaseSubFile}[1]{%
  \import{../use-cases/\usecaseLabel/}{#1}%
}

\begin{document}
%
% Not that we actually generate a glossary but we need to import the glossary regardless because otherwise
% all \glsxtrshort{someterm} commands fail.
%
\import{../../}{glossary.tex}
\import{../../}{glossary-concepts.tex}
\import{../../}{glossary-ontologies.tex}
\importTitlePage
\typeout{use-case-standalone A1}
Title is \usecaseTitle\par
\typeout{use-case-standalone A2}

\importMainUseCaseDocument
\typeout{use-case-standalone A3}
\end{document}
