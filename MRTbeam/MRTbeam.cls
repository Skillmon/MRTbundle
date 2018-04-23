\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\RequirePackage{helvet}
\RequirePackage{MRTif}
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

% stupid package for math font is stupid. Have to cure the sickness >>>
\newbox\MRTMathAccentBox
\newcommand*\MRT@PatchMathaccentV
  {%
    \let\mathaccentV@orig\mathaccentV
    \renewcommand*\mathaccentV[4]% >>>
      {%
        \def\mathaccentV@args{{##1}{##2}{##3}{##4}}%
        \futurelet\next\mathaccentV@a
      }% <<<
    \newcommand*\mathaccentV@a[1]% >>>
      {%
        \expandafter\ifx\next!%
          \expandafter\@firstofthree
        \else
          \expandafter\ifx\next*%
            \expandafter\expandafter\expandafter\@secondofthree
          \else
            \expandafter\expandafter\expandafter\@thirdofthree
          \fi
        \fi
        {\expandafter\mathaccentV@orig\mathaccentV@args}
        {\expandafter\mathaccentV@shifted\mathaccentV@args}
        {\expandafter\mathaccentV@b\mathaccentV@args{##1}}%
      }% <<<
    \newcommand*\mathaccentV@b[5]% >>>
      {%
        \MRTIfLetterGTF{##5}
          {\mathaccentV@shifted{##1}{##2}{##3}{##4}{##5}}
          {\mathaccentV@orig{##1}{##2}{##3}{##4}{##5}}
      }% <<<
    \newcommand*\mathaccentV@shifted[5]% >>>
      {%
        \mathchoice%
          {\mathaccentV@shifted@a{display}{##1}{##2}{##3}{##4}{##5}}%
          {\mathaccentV@shifted@a{text}{##1}{##2}{##3}{##4}{##5}}%
          {\mathaccentV@shifted@a{script}{##1}{##2}{##3}{##4}{##5}}%
          {\mathaccentV@shifted@a{scriptscript}{##1}{##2}{##3}{##4}{##5}}%
      }% <<<
    \newcommand*\mathaccentV@shifted@a[6]% >>>
      {%
        \setbox\MRTMathAccentBox\hbox{$\csname ##1style\endcsname##6$}%
        \mathaccentV@orig{##2}{##3}{##4}{##5}
          {##6\kern0.36\ht\MRTMathAccentBox}\kern-0.36\ht\MRTMathAccentBox
      }% <<<
  }
\AtBeginDocument{\MRT@PatchMathaccentV}
% <<<

\endinput
% vim: fdm=marker foldmarker=>>>,<<< ft=tex
