\newcommand*\MRTbeam@version{0.0.1}
\newcommand*\MRTbeam@date{2018/06/01}

\NeedsTeXFormat{LaTeX2e}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\RequirePackage{helvet,MRTsfacc,expl3,xparse}
\LoadClass{beamer}
\ProvidesExplClass
  {MRTbeam}          {\MRTbeam@date}
  {\MRTbeam@version} {beamer template for MRT - University of Bayreuth}

\usetheme{MRTbeam}

\NewDocumentCommand \ProgressBarStyle { s m }% >>>
  {%
    \IfBooleanT { #1 } { \ProgressBartrue }
    \str_case:nnF { #2 }
      {
        { default } { \SetProgressBar{c}{30pt}{\f@size pt}{-1.65ex} }
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
