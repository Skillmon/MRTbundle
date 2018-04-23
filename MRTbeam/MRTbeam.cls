\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\RequirePackage{helvet}
\RequirePackage{MRTsfacc}
\RequirePackage{xparse}
\LoadClass{beamer}
\ProvidesClass{MRTbeam}
  [2018/04/21 beamer template for MRT - University of Bayreuth]

\usetheme{MRTbeam}

\ExplSyntaxOn
\NewDocumentCommand \ProgressBarStyle { s m }% >>>
  {%
    \IfBooleanT { #1 } { \ProgressBartrue }
    \str_case:nnF { #2 }
      {
        { Spratte } { \SetProgressBar{c}{\paperwidth}{2pt}{3pt} }
        { spratte } { \SetProgressBar{c}{\paperwidth}{2pt}{3pt} }
      }
      {
        \ClassError{MRTbeam}{The~style~'#1'~is~unknown.}{}
      }
  }% <<<
\ExplSyntaxOff

\endinput
% vim: ft=tex fdm=marker foldmarker=>>>,<<<
