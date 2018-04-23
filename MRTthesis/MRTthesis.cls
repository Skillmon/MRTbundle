\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif} % absolutely necessary packages
\ProvidesExplClass
  {MRTthesis} {2018/04/22}
  {v0.1}      {thesis template for MRT - University of Bayreuth}


%% Class options and loading scrreprt >>>
%%=============================================================================
\newif\ifMRTthesis@minimal@
\newif\ifMRTthesis@longtabs@
\newif\ifMRTthesis@mathsizes@
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreprt}}
\DeclareOption{minimal}{\MRTthesis@minimal@true}
\DeclareOption{longtabs}{\MRTthesis@longtabs@true}
\DeclareOption{mathsizes}{\MRTthesis@mathsizes@true}
\PassOptionsToClass
  {twoside,fontsize=11pt,paper=a4,toc=listof,toc=bib,fleqn,ngerman}
\ProcessOptions\relax
\LoadClass{scrreprt}
%%==========================================================================<<<

%% Additional packages to achieve template formatting >>>
%%=============================================================================
\bool_if:nTF { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }
  {
    \RequirePackage{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
  }
  {
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
  }
\RequirePackage{lmodern}
\RequirePackage{helvet}
\renewcommand\familydefault{\sfdefault}
\RequirePackage{textcomp}
\RequirePackage[ngerman]{babel}
\RequirePackage{scrlayer-scrpage}
\RequirePackage[left=25mm,right=25mm,top=8.4mm,bottom=10.7mm%
    ,includeheadfoot,headsep=15.4mm,marginparwidth=18mm,marginparsep=4mm]%
    {geometry}
\RequirePackage{setspace}
\RequirePackage[normalem]{ulem}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{enumitem}
\RequirePackage{amsmath}
% bad math fonts 
\RequirePackage[italic,defaultmathsizes]{mathastext}
\RequirePackage{isomath}
\ifMRTthesis@mathsizes@
  \DeclareMathSizes{10.95pt}{10.95pt}{9pt}{7pt}
\fi
% 
\AtBeginDocument{\RequirePackage{hyperref}\MRTthesis@after@hyperref}
\ifMRTthesis@longtabs@
  \RequirePackage{longtable}
\fi
\ifMRTthesis@minimal@
\else
  \RequirePackage{siunitx}
  \sisetup{% set options of the siunitx package
      ,detect-all%
      ,locale=DE%
      ,per-mode=reciprocal-positive-first%
      ,range-phrase={\ifmmode\text{ bis }\else\ bis \fi}%
  }%
  \RequirePackage[% I don't know yet how they want me to cite correctly...
      backend=biber%
      %,style=authoryear%
      %,sortlocale=de_DE%
      %,natbib=true%
      %,url=false%
      %,doi=true%
      %,eprint=false%
      ,natbib=true%
      ,citestyle=numeric%
      ,bibstyle=numeric%
      ,sorting=none%
      ,giveninits=true%
      ,sortcites
  ]{biblatex}
  \RequirePackage{csquotes}
\fi
%%==========================================================================<<<

%% messages >>>
%%=============================================================================
\msg_new:nnnn { MRTthesis } { afterafterhyperref }
  {
    \exp_not:N \MRTafterhyperref
    ~used~too~late.~It~has~to~be~used~before~\exp_not:N \begin \{document\}.
  }
  { Seriously,~which~information~do~you~miss~from~the~above? }
%%==========================================================================<<<

%% macros >>>
%%=============================================================================
% \MRTafterhyperref >>>
\NewDocumentCommand \MRTafterhyperref { +m }%>>>
  {
    \xdef \MRTthesis@after@hyperref 
      { \unexpanded \expandafter { \MRTthesis@after@hyperref #1 } }
  }%<<<
\newcommand*\MRTthesis@after@hyperref{}
\MRTafterhyperref% redefine itself after hyperref to throw an error >>>
  {
    \cs_set:Npn \MRTafterhyperref #1
      { \msg_error:nn { MRTthesis } { afterafterhyperref } }
  }% <<<
% <<<
\newcommand*{\MRTthesis@fntsel}[2]{\fontsize{##1bp}{##2bp}\selectfont}%
%%==========================================================================<<<

%% labels and other ngerman stuff >>>
%%=============================================================================
\renewcommand*\theequation{\hbox{(\thechapter-\arabic{equation})}}
\renewcommand*\thefigure  {\hbox{\thechapter-\arabic{figure}}}
\renewcommand*\thetable   {\hbox{\thechapter-\arabic{table}}}
\newcommand*\MRTthesis@setautorefnames% >>>
  {%
    \addto\extrasngerman
      {%
        \gdef\figureautorefname{Bild}%
        \gdef\equationautorefname{Gl.}%
      }%
  }% <<<
\MRTafterhyperref{\MRTthesis@setautorefnames}
\addto\captionsngerman% >>>
  {%
    \renewcommand*\figurename{\bfseries Bild}%
    \renewcommand*\tablename{\bfseries Tabelle}%
    \renewcommand*\listfigurename{Bildverzeichnis}%
  }% <<<
%correctly set the equation labels
\def\tagform@#1{\maketag@@@{\ignorespaces#1\unskip\@@italiccorr}\hspace{6.7mm}}
\long\def\eqref#1% >>>
  {%
    \textup{\maketag@@@{\ignorespaces\ref{#1}\unskip\@@italiccorr}}%
  }% <<<
%% Ugly stuff which resembles the word template
\renewcommand*\captionformat{\normalfont:\ }% no bold colon
\setcapindent{0pt}% no indent in captions beneath the label
\setcapdynwidth[c]{0.905\textwidth}% reduce the maximum width of captions
%%==========================================================================<<<

%% lengths >>>
%%=============================================================================
\setlength{\arrayrulewidth}{0.6pt}
\setlength{\parindent}{13pt} % default 15pt
\setlength{\parskip}{6pt plus 6pt minus 1pt}
\setlength{\mathindent}{10.45mm}
\AtBeginDocument
  {
    \setlength{\abovedisplayskip}{4.2pt plus .2pt minus .1pt}
    \setlength{\belowdisplayskip}{4.2pt plus .2pt minus .1pt}
    \setlength{\abovedisplayshortskip}{4.2pt plus .2pt minus .1pt}
    \setlength{\belowdisplayshortskip}{4.2pt plus .2pt minus .1pt}
  }
\setlist[itemize]{itemsep=-0pt, parsep=2pt plus .2pt minus .1pt}
\setlist[enumerate]{itemsep=-0pt, parsep=2pt plus .2pt minus .1pt}
%%==========================================================================<<<


\endinput

% vim: ft=tex fdm=marker fmr=>>>,<<< sw=2 ts=2 tw=80
