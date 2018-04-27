\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif,MRTsfacc} % absolutely necessary packages
\ProvidesExplClass
  {MRTthesis} {2018/04/22}
  {0.1}       {thesis template for MRT - University of Bayreuth}


%% variables >>>
%%=============================================================================
% boxes >>>
\newbox\MRTthesis@TestBoxA
\newbox\MRTthesis@TestBoxB
\newbox\MRTthesis@TestBoxC
% <<<
% dimens >>>
\newdimen\MRTthesis@pageheadOffset
% <<<
% counts >>>
\newcount\MRTthesis@countA
\newcount\MRTthesis@countB
\newcount\MRTthesis@authorcount
\newcount\MRTthesis@authorpos
% <<<
% ifs >>>
\newif\ifMRTthesis@minimal@
\newif\ifMRTthesis@longtabs@
\newif\ifMRTthesis@mathsizes@
\newif\ifMRTthesis@tikzuline@
\newif\ifMRTthesis@UKenglish@
\newif\ifMRTbibliography
% <<<
%%==========================================================================<<<

%% Class options and loading scrreprt >>>
%%=============================================================================
\DeclareOption{minimal}{\MRTthesis@minimal@true}
\DeclareOption{longtabs}{\MRTthesis@longtabs@true}
\DeclareOption{mathsizes}{\MRTthesis@mathsizes@true}
\DeclareOption{no mathsizes}{\MRTthesis@mathsizes@false}
\DeclareOption{tikzunderline}{\MRTthesis@tikzuline@true}
\DeclareOption{tUline}{\ExecuteOptions{tikzunderline}}
\DeclareOption{UKenglish}{\MRTthesis@UKenglish@true}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreprt}}
\ExecuteOptions{mathsizes}
\PassOptionsToClass
  {twoside,fontsize=11pt,paper=a4,toc=listof,toc=bib,fleqn,ngerman}
  {scrreprt}
\ProcessOptions\relax
\LoadClass{scrreprt}
%%==========================================================================<<<

%% additional packages to achieve template formatting >>>
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
\ifMRTthesis@UKenglish@
  \RequirePackage[main=UKenglish,ngerman]{babel}
\else
  \RequirePackage[ngerman]{babel}
\fi
\RequirePackage{scrlayer-scrpage}
\RequirePackage[left=25mm,right=25mm,top=8.4mm,bottom=10.7mm%
    ,includeheadfoot,headsep=15.4mm,marginparwidth=18mm,marginparsep=4mm]
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

%% setup options >>>
%%=============================================================================
\keys_define:nn { MRTthesis/setup }% >>>
  {
    ,advisor         .tl_set:N   = \l_MRTthesis_advisor_tl
    ,author          .code:n     = \MRTthesis_parse_author:n { #1 }
    ,degree          .tl_set:N   = \l_MRTthesis_degree_tl
    ,caption~above   .multichoice:% >>>
    ,caption~above/true  .code:n  =
      {% >>>
        \KOMAoptions{captions=tableheading}
        \bool_set_true:N \l_MRTthesis_caption_above_bool
      }% <<<
    ,caption~above/false .code:n  =
      {% >>>
        \KOMAoptions{captions=tablesignature}
        \bool_set_false:N \l_MRTthesis_caption_above_bool
      }% <<<
    % <<<
    ,examinor        .tl_set:N   = \l_MRTthesis_examinor_tl
    ,logoL           .tl_set:N   = \l_MRTthesis_logoL_tl
    ,logoL~height    .dim_set:N  = \l_MRTthesis_logoL_height_dim
    ,logoR           .tl_set:N   = \l_MRTthesis_logoR_tl
    ,logoR~height    .dim_set:N  = \l_MRTthesis_logoR_height_dim
    ,no~advisor      .bool_set:N = \l_MRTthesis_no_advisor_bool
    ,no~advisor      .default:n  = { true }
    ,no~degree       .bool_set:N = \l_MRTthesis_no_degree_bool
    ,no~degree       .default:n  = { true }
    ,no~thesis       .bool_set:N = \l_MRTthesis_no_thesis_bool
    ,no~thesis       .default:n  = { true }
    ,number          .tl_set:N   = \l_MRTthesis_number_tl
    ,pos~figure      .tl_set:N   = \fps@figure
    ,pos~float       .code:n     = 
      \keys_set:nn { MRTthesis/setup } { pos~figure=#1, pos~table=#1 }
    ,pos~MRTtab      .tl_set:N   = \l_MRTthesis_MRTtab_pos_tl
    ,pos~table       .tl_set:N   = \fps@table
    ,short~advisor   .tl_set:N   = \l_MRTthesis_s_advisor_tl
    ,sadvisor        .meta:n     = { short~advisor }
    ,short~author    .tl_set:N   = \l_MRTthesis_s_author_tl
    ,sauthor         .meta:n     = { short~author }
    ,short~examinor  .tl_set:N   = \l_MRTthesis_s_examinor_tl
    ,sexaminor       .meta:n     = { short~examinor }
    ,sign~height     .dim_set:N  = \l_MRTthesis_sign_height_dim
    ,sign~seperation .dim_set:N  = \l_MRTthesis_sign_seperation_dim
    ,sign~sep        .meta:n     = { sign~seperation }
    ,sign~width~max  .dim_set:N  = \l_MRTthesis_sign_width_max_dim
    ,sign~width~min  .dim_set:N  = \l_MRTthesis_sign_width_min_dim
    ,stretch~caption .code:n     =
      {% >>>
        \setkomafont { caption }      { \setstretch { #1 } \normalfont }
        \setkomafont { captionlabel } { \setstretch { #1 } \normalfont }
      }% <<<
    ,stretch~cap     .meta:n     = { stretch~caption }
    ,stretch~tabular .tl_set:N   = \l_MRTthesis_stretch_tabular_tl
    ,stretch~tab     .meta:n     = { stretch~tabular }
    ,stretch~text    .code:n     = 
      {% >>>
        \dimen0=-4.08541473pt
        \MRTthesis@pageheadOffset=#1\dimen0\relax
        \advance\MRTthesis@pageheadOffset by -1.78452093pt\relax
        \setkomafont{pageheadfoot}
          {
            \setstretch{1.408}
            \mbox{}\vspace{\MRTthesis@pageheadOffset}
            \selectfont\normalfont\small
          }
        \setstretch{#1}
      }% <<<
    ,stretches       .meta:n     = { stretch~cap, stretch~tab, stretch~text }
    ,table~spacing   .bool_set:N = \l_MRTthesis_table_spacing_bool
    ,thesis          .tl_set:N   = \l_MRTthesis_thesis_tl
    ,title           .tl_set:N   = \l_MRTthesis_title_tl
    ,toc~ChapIndent  .tl_set:N   = \l_MRTthesis_toc_chapter_indent_tl
    ,toc~SecIndent   .tl_set:N   = \l_MRTthesis_toc_section_indent_tl
    ,toc~sSecIndent  .tl_set:N   = \l_MRTthesis_toc_subsection_indent_tl
    ,toc~ssSecIndent .tl_set:N   = \l_MRTthesis_toc_subsubsection_indent_tl
  }% <<<
% defaults >>>
\keys_set:nn { MRTthesis/setup }% >>>
  {
    ,advisor = {\textcolor{blue}{Mein~Betreuer}}
    ,examinor = {Univ.-Professor~Dr.-Ing.~Gerhard~Fischerauer}
    ,pos~float = tbp
    ,number = {\textcolor{blue}{XX-00-00-0}}
    ,sadvisor = {\textcolor{blue}{M.~Betreuer}}
    ,sauthor  = {\textcolor{blue}{A.~Student}}
    ,sexaminor = {G.~Fischerauer}
    ,stretch~cap = 1.408
    ,stretch~tab = 1.408
    ,stretch~text = 1.408
    ,thesis = {\textcolor{blue}{Meine~Arbeit}}
    ,title  = {\textcolor{blue}{UNTERSUCHUNG~ZU ...}}
    ,caption~above = false
    ,table~spacing = false
    ,toc~ChapIndent = 0.01em
    ,toc~SecIndent  = 1.32em
    ,toc~sSecIndent = 3.38em
    ,toc~ssSecIndent = 6.38em
    ,sign~height = 9mm
    ,sign~width~min = 7cm
    ,sign~width~max = 0pt
    %,sign~sep = 2em
    ,logoL = {MRTthesis_logo_UBT2.pdf}
    ,logoR = {MRTthesis_logo_MRT2.pdf}
    ,logoL~height = 10.85mm
    ,logoR~height = 11.9mm
  }% <<<
% <<<
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
\definecolor{tablegray}{gray}{0.85}
% auxiliary like>>>
\long\def\@firstofthree#1#2#3{#1}
\long\def\@secondofthree#1#2#3{#2}
\long\def\@thirdofthree#1#2#3{#3}
\newcommand{\ifNoWidthTF}[1]% >>>
  {%
    \bgroup
    \setbox\MRTTestBoxA\hbox{#1}%
    \ifdim\wd\MRTTestBoxA=0pt
      \egroup
      \expandafter\@firstoftwo
    \else
      \egroup
      \expandafter\@secondoftwo
    \fi
  }% <<<
\newcommand\multfill[2][v]% >>>
  {%
    \bgroup
      \MRTthesis@countA=#2
      \MRTthesis@countB=0
      \expandafter\let\expandafter\@multfillcmd\csname #1fill\endcsname
      \loop\ifnum\MRTthesis@countA>\MRTthesis@countB\relax
        \advance\MRTthesis@countB by 1
        \@multfillcmd
      \repeat
    \egroup
  }% <<<
\newcommand*\MRTthesis@display@logo[2]% >>>
  {%
    \MRTifEmptyNF{#2}{\includegraphics[height=#1]{#2}}%
  }% <<<
% <<<
% \MRTafterhyperref >>>
\NewDocumentCommand \MRTafterhyperref { +m }% >>>
  {
    \xdef \MRTthesis@after@hyperref 
      { \unexpanded \expandafter { \MRTthesis@after@hyperref #1 } }
  }% <<<
\newcommand*\MRTthesis@after@hyperref{}
\MRTafterhyperref% redefine itself after hyperref to throw an error >>>
  {
    \cs_set:Npn \MRTafterhyperref #1
      { \msg_error:nn { MRTthesis } { afterafterhyperref } }
  }% <<<
% <<<
\newcommand*\MRTthesis@fntsel[2]{\fontsize{##1bp}{##2bp}\selectfont}
% ToC related >>>
\newcommand*\DeclareTOCStyleEntryMRTSectionLike% >>>
  [2][\l_MRTthesis_toc_section_indent_tl]
  {%
    \expandafter\DeclareTOCStyleEntry\expandafter
      [%
        \MRTthesis@toc@default@section
        ,indent=#1%
      ]
      {tocline}{#2}%
  }% <<<
\newcommand*\DeclareTOCStyleEntryMRTChapterLike% >>>
  [2][\l_MRTthesis_toc_chapter_indent_tl]
  {%
    \expandafter\DeclareTOCStyleEntry\expandafter
      [%
        \MRTthesis@toc@default@chapter
        ,indent=#1%
      ]
      {tocline}{#2}%
  }% <<<
% <<<
% \WUline >>>
\ifMRTthesis@tikzuline@% >>>
  \RequirePackage{tikz}
  \usetikzlibrary{calc}
  \RequirePackage{tikzpagenodes}
  \newcommand*\MRTthesis@tUline@width{0.185ex}
  \newlength\MRTthesis@tUline@length
  \newcount\MRTthesis@tUline@count
  \newcommand*\MRTthesis@gettikzxy[3]% >>>
    % https://tex.stackexchange.com/a/58590/121799
    {%
      \tikz@scan@one@point\pgfutil@firstofone#1\relax
      \xdef#2{\the\pgf@x}%
      \xdef#3{\the\pgf@y}%
    }% <<<
  \tikzset{MRTthesis@tUline/.style={line width=\MRTthesis@tUline@width}}
  \newcommand*\MRTthesis@EmptyOProcessor[2]% >>>
    {%
      \MRTifEmptyTF{#2}%
        {\def\ProcessedArgument{#1}}%
        {\def\ProcessedArgument{#2}}%
    }% <<<
  \NewDocumentCommand{\tUline}% >>>
    {
      >{\MRTthesis@EmptyOProcessor{-0.35ex}}O{} % height
      >{\MRTthesis@EmptyOProcessor{0pt}}O{}     % overhang
      >{\MRTthesis@EmptyOProcessor{0.185ex}}O{} % line width
      +m
    }
    {%
      \def\MRTthesis@tUline@width{#3}%
      \tikz[remember picture,overlay, baseline=(Begin.base)]
        {%
          \node[anchor=base,inner sep=0pt,outer sep=0pt,xshift=-#2]
            (Begin) {\strut};
          \gettikzxy{($(Begin.base)-(current page.south west)$)}
            {\tUline@bx}{\tUline@by}%
        }%
      #4%
      \tikz[remember picture,overlay, baseline=(End.base)]
        {%
          \node[anchor=base,inner sep=0pt,outer sep=0pt,xshift=+#2]
            (End) {\strut};%
          \gettikzxy{($(End.base)-(current page.south west)$)}
            {\tUline@ex}{\tUline@ey}%
        }%
      \begin{tikzpicture}[overlay,remember picture]
        \ifdim\dimexpr\tUline@ey-\tUline@by = 0pt
          % one line
          \draw[MRTthesis@tUline] ($(Begin.base)+(0,#1)$)
            -- ($(End.base)+(0,#1)$);%
        \else
          % multiple lines
          \draw
            ($(current page text area.west)-(#2,0)$) node(WestLine){};
          \draw
            ($(current page text area.east)+(#2,0)$) node(EastLine){};
          \tUline@drawBtoE{#1}
          \ifdim\dimexpr\tUline@by-\tUline@ey>\baselineskip
            % more than two lines
            \bgroup
            \tUline@drawMultipleLines{#1}{\baselineskip}
            \egroup
          \fi
        \fi
      \end{tikzpicture}%
    }% <<<
  \newcommand*\tUline@drawMultipleLines[2]% >>>
    {%
      \MRTthesis@tUline@length=#2
      \MRTthesis@tUline@count=1
      \loop\ifdim
        \dimexpr\tUline@by-\MRTthesis@tUline@count\MRTthesis@tUline@length\relax
        >\tUline@ey
      \draw[MRTthesis@tUline]
        ($(Begin.base -| WestLine)+(0,#1)-
          (0,\MRTthesis@tUline@count\MRTthesis@tUline@length)$) --
        ($(Begin.base -| EastLine)+(0,#1)-
          (0,\MRTthesis@tUline@count\MRTthesis@tUline@length)$);
      \advance\MRTthesis@tUline@count by 1
      \repeat
    }% <<<
  \newcommand*\tUline@drawBtoE[1]% >>>
    {%
      \draw[MRTthesis@tUline]
        ($(Begin.base)+(0,#1)$) -- ($(Begin.base -| EastLine)+(0,#1)$)
        ($(End.base)+(0,#1)$) -- ($(End.base -| WestLine)+(0,#1)$);%
    }% <<<
\fi% <<<
\def\MRTthesis@HeadingsUline{\WUline}
\newcommand*\WUline{\@ifstar\MRTthesis@star@WUline\MRTthesis@nostar@WUline}%
\NewExpandableDocumentCommand{\MRTthesis@star@WUline}{ o m }% >>>
  {%
    \IfNoValueTF{#1}%
      {\MRTthesis@nostar@WUline{#2}}%
      {%
        \MRTthesis@WUline@setheight
        \bgroup
          \def\MRTthesis@WUline@phantomp% >>>
            {%
              \makebox[0pt][l]{\phantom{\text{#1}}}%
            }% <<<
          \MRTthesis@typeout@WUline{\MRTthesis@WUline@phantomp#2}%
        \egroup
      }%
  }% <<<
\newcommand*\MRTthesis@nostar@WUline[2][]% >>>
  {%
    \MRTifEmptyTF{#1}
      {\MRTthesis@WUline@setheight}
      {\MRTthesis@WUline@height=#1}%
    \MRTthesis@typeout@WUline{\MRTthesis@WUline@phantomp#2}%
  }% <<<
\newcommand*\MRTthesis@typeout@WUline% >>>
  {%
    \bgroup\markoverwith{\rule[\MRTthesis@WUline@height]{0.25ex}{0.185ex}}\ULon
  }% <<<
\edef\MRTthesis@WUline@phantomp% >>>
  {%
    \noexpand\makebox[0pt][l]{\noexpand\phantom{\text{p}}}%
  }% <<<
\newdimen\MRTthesis@WUline@height%
\newcommand*\MRTthesis@WUline@setheight
  {% >>>
    \relax\ifmmode
      \MRTthesis@WUline@height=\MRTthesis@WUline@mathheight\relax
    \else
      \MRTthesis@WUline@height=\MRTthesis@WUline@normalheight\relax
    \fi
  }% <<<
\newcommand*\MRTthesis@WUline@mathheight{-0.37ex}%
\newcommand*\MRTthesis@WUline@normalheight{-0.42ex}%
% <<<
\NewDocumentCommand \MRTthesisSetup { +m }%>>>
  {
    \keys_set:nn { MRTthesis/setup } { #1 }
  }%<<<
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
    \addto\extrasUKenglish
      {%
        \gdef\equationautorefname{eq.}%
      }%
  }% <<<
\MRTafterhyperref{\MRTthesis@setautorefnames}
\addto\captionsngerman% >>>
  {%
    \renewcommand*\figurename{\bfseries Bild}%
    \renewcommand*\tablename{\bfseries Tabelle}%
    \renewcommand*\listfigurename{Bildverzeichnis}%
  }% <<<
\addto\captionsUKenglish% >>>
  {%
    \renewcommand*\figurename{\bfseries Figure}%
    \renewcommand*\tablename{\bfseries Table}%
  }% <<<
%correctly set the equation labels
\def\tagform@#1{\maketag@@@{\ignorespaces#1\unskip\@@italiccorr}\hspace{6.7mm}}
\long\def\eqref#1% >>>
  {%
    \textup{\maketag@@@{\ignorespaces\ref{#1}\unskip\@@italiccorr}}%
  }% <<<
%% Ugly stuff which resembles the word template
\renewcommand*\captionformat{\normalfont :\ }% no bold colon
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

%% sectioning commands >>>
%%=============================================================================
\RedeclareSectionCommand[% chapter >>>
    ,beforeskip=-1.2em plus -1pt minus -1pt%
    ,afterskip=0.1em plus 1pt minus 1pt%
]{chapter}% <<<
\RedeclareSectionCommand[% section >>>
    ,beforeskip=-0.57em plus -1pt minus -1pt%
    ,afterskip=0.045em plus 1pt minus 1pt%
]{section}% <<<
\RedeclareSectionCommand[% subsection >>>
    ,beforeskip=-0.57em plus -1pt minus -1pt%
    ,afterskip=0.045em plus 1pt minus 1pt%
]{subsection}% <<<
\RedeclareSectionCommand[% subsubsection >>>
    ,beforeskip=-0.57em plus -1pt minus -1pt%
    ,afterskip=0.045em plus 1pt minus 1pt%
]{subsubsection}% <<<
\RedeclareSectionCommand[% paragraph >>>
    ,beforeskip=-0.57em plus -1pt minus -1pt%
    ,afterskip=1sp plus -1sp minus 1sp%0.045em plus 1pt minus 1pt%
]{paragraph}% <<<
\RedeclareSectionCommand[% subparagraph >>>
    ,beforeskip=-0.57em plus -1pt minus -1pt%
    ,afterskip=1sp plus -1sp minus 1sp%0.045em plus 1pt minus 1pt%
    ,indent=0pt%
]{subparagraph}% <<<
\renewcommand\chapterlinesformat[3]% >>>
  {%
    \setbox\MRTthesis@TestBoxA\hbox{\MRTthesis@HeadingsUline{#2}}%
    \usebox\MRTthesis@TestBoxA
    \parbox[t]{\dimexpr\textwidth-\wd\MRTthesis@TestBoxA}
      {%
        \MRTthesis@HeadingsUline{#3}%
      }%
  }
% <<<
\renewcommand\sectionlinesformat[4]% >>>
  {%
    \bgroup
    \ifstr{#1}{paragraph}
      {%
        \let\MRTthesis@HeadingsUline\relax
      }
      {%
        \ifstr{#1}{subparagraph}%
          {%
            \let\MRTthesis@HeadingsUline\relax
          }
          {}%
      }%
    \@hangfrom{\hskip #2\MRTthesis@HeadingsUline{#3}}%
    {#4}%
    \egroup
  }
% <<<
% sectioning fonts >>>
\setkomafont{chapter}{\large\sffamily\bfseries}
\setkomafont{section}{\sffamily\bfseries}
\setkomafont{subsection}{\sffamily\bfseries}
\setkomafont{subsubsection}{\sffamily\bfseries}
\setkomafont{paragraph}{\sffamily\bfseries}
\setkomafont{subparagraph}{\normalfont\sffamily\itshape}
% <<<
% Sectionformat >>>
\AtBeginDocument{\renewcommand*\Sectionformat[2]{\MRTthesis@HeadingsUline{#1}}}
% <<<
%%==========================================================================<<<

%% page layout from beginning >>>
%%=============================================================================
\pagenumbering{Roman}
\KOMAoptions{% >>>
    ,numbers=noendperiod%
    ,headsepline=0.5pt% line below pagehead
}% <<<
\ihead*{\headmark}%\headmark at the inner side of the page
\chead*{}%empty middle
\ohead*{\pagemark}%page numbers at the outer side
\ifoot*{}%empty foot
\cfoot*{}%empty foot
\ofoot*{}%empty foot
\automark[chapter]{chapter}%both right and left chapters
\automark*[section]{}%if there is a section right head containing section
\pagestyle{scrheadings}%use the aforesaid definition for the headers
\renewcommand*{\chapterpagestyle}{scrheadings}%first side of chapters, too
%%==========================================================================<<<

%% formatting switches for other parts >>>
%%=============================================================================
\renewcommand*\appendix% >>>
  {%
    \automark[chapter]{chapter}% from here on use chapters in headmark
    \renewcommand*{\thesection}{\Alph{section}}%
    \pgfkeys
      {%
        /MRTarbeit/MRTtab/default/.add style = {}{%
          nofloat,%
        }%
      }%
    \@addtoreset{figure}{section}%
    \@addtoreset{table}{section}%
    \@addtoreset{equation}{section}%
    \renewcommand*\thefigure{\hbox{\thesection-\arabic{figure}}}%
    \renewcommand*\thetable{\hbox{\thesection-\arabic{table}}}%
    \renewcommand*\theequation{\hbox{(\thesection-\arabic{equation})}}%
    \addtokomafont{section}{\large}%
  }% <<<
\newcommand*\mainpart% >>>
  {%
    \cleardoublepage
    \pagenumbering{arabic}%
  }% <<<
%%==========================================================================<<<

%% bibliography >>>
%%=============================================================================
\ifMRTthesis@minimal@% >>>
  \MRTbibliographyfalse% <<<
\else% >>>
  \MRTbibliographytrue
  \renewcommand*{\newunitpunct}{, }% between each unit in one bib-entry
  \DefineBibliographyStrings{ngerman}
    {%
      ,bibliography={Literaturverzeichnis}%
      ,in={}% removes 'In:' infront of journal name
      ,andothers={et\,al\adddot}%
    }
  %\if@mrtarbeit@bibfileused\else%
      %\def\@mrtarbeit@bibfile{works-cited.bib;}%
  %\fi%
  %\MRTifEmptyNF\@mrtarbeit@bibfile{
      %\expandafter\@mrtarbeit@parsebibfiles\@mrtarbeit@bibfile;
  %}
  % changing the order of units in article-entries. >>>
  % The definitions are taken from standard.bbx and altered
  \DeclareBibliographyDriver{article}% >>>
    {%
      \usebibmacro{bibindex}%
      \usebibmacro{begentry}%
      \usebibmacro{author/translator+others}%
      \setunit{\printdelim{nametitledelim}}\newblock
      \usebibmacro{title}%
      \newunit
      \printlist{language}%
      \newunit\newblock
      \usebibmacro{byauthor}%
      \newunit\newblock
      \usebibmacro{bytranslator+others}%
      \newunit\newblock
      \printfield{version}%
      \newunit\newblock
      \usebibmacro{in:}%
      \usebibmacro{MRT+journal+issuetitle}%
      \newunit
      \usebibmacro{byeditor+others}%
      \newunit
      \usebibmacro{date}%
      \newunit
      \usebibmacro{note+pages}%
      \newunit\newblock
      \iftoggle{bbx:isbn}
        {\printfield{issn}}
        {}%
      \newunit\newblock
      \usebibmacro{doi+eprint+url}%
      \newunit\newblock
      \usebibmacro{addendum+pubstate}%
      \setunit{\bibpagerefpunct}\newblock
      \usebibmacro{pageref}%
      \newunit\newblock
      \iftoggle{bbx:related}
          {\usebibmacro{related:init}%
              \usebibmacro{related}}
          {}%
      \usebibmacro{finentry}%
    }% <<<
  \newbibmacro*{MRT+journal+issuetitle}% >>>
    {%
      \usebibmacro{journal}%
      \setunit*{\addspace}%
      \iffieldundef{series}
          {}
          {\newunit
              \printfield{series}%
              \setunit{\addspace}}%
      \usebibmacro{volume+number+eid}%
      \setunit{\addspace}%
      \usebibmacro{MRT+issue}%
      \setunit{\addcolon\space}%
      \usebibmacro{issue}%
      \newunit
    }% <<<
  \newbibmacro*{MRT+issue}% >>>
    {%
      \iffieldundef{issue}
        {}
        {%
          \printtext[parens]
            {%
              {\printfield{issue}}%
              \newunit
            }
        }%
    }% <<<
  % <<<
\fi% <<<
%%==========================================================================<<<

%% tableofcontents/listof... formatting >>>
%%=============================================================================
\setcounter{tocdepth}{3}
\setcounter{secnumdepth}{3}
\AtBeginDocument% >>>
  {%
    \addtoeachtocfile{\mbox{}\hfill Seite\par}%
  }% <<<
\AtAddToTocList% >>>
  {%
    \setuptoc{\@currext}{totoc}%
  }% <<<
%\DeclareTOCStyleEntry[<options>]{<style>}{<section-layer>}
\newcommand*\MRTthesis@chapter@dotfill% >>>
  {%
    \def\@dotsep{0.072}\TOCLineLeaderFill[\textbf{.}]%
  }% <<<
\newcommand*\MRTthesis@section@dotfill% >>>
  {%
    \def\@dotsep{0.072}\TOCLineLeaderFill
  }% <<<
\newcommand*\MRTthesis@toc@default@all% >>>
  {%
    pagenumberbox=\makebox%
    ,dynnumwidth=true%
    ,numsep=0.29em%
    ,numwidth=0pt%
  }% <<<
\edef\MRTthesis@toc@default@section% >>>
  {%
    \unexpanded\expandafter{\MRTthesis@toc@default@all}%
    ,linefill=\noexpand\MRTthesis@section@dotfill
    ,beforeskip=0pt plus .2pt%
  }% <<<
\edef\MRTthesis@toc@default@chapter% >>>
  {%
    \unexpanded\expandafter{\MRTthesis@toc@default@all}%
    ,linefill=\noexpand\MRTthesis@chapter@dotfill
    ,beforeskip=1.16em plus 1pt%
  }% <<<
\DeclareTOCStyleEntryMRTChapterLike{chapter}
\DeclareTOCStyleEntryMRTSectionLike{section}
\DeclareTOCStyleEntryMRTSectionLike[\l_MRTthesis_toc_subsection_indent_tl]
  {subsection}
\DeclareTOCStyleEntryMRTSectionLike[\l_MRTthesis_toc_subsubsection_indent_tl]
  {subsubsection}
\DeclareTOCStyleEntryMRTSectionLike{table}
\DeclareTOCStyleEntryMRTSectionLike{figure}
%%==========================================================================<<<

%% affidavit >>>
%%=============================================================================
\ExplSyntaxOff
\newcommand*{\affidavittext}{% >>>
Hiermit versichere ich an Eides statt, dass ich die vorliegende Arbeit
selbständig und unter Angabe aller Hilfsmittel und Referenzen angefertigt habe.
Eine Ausnahme bilden die persönlichen Mitteilungen der Betreuer der Arbeit, die
ständig eingeflossen sind und daher nicht im Einzelnen nachgewiesen werden.

Der Universität Bayreuth, vertreten durch den Lehrstuhl für Mess- und
Regeltechnik (Prof. Dr.-Ing. Fischerauer), habe ich das Nutzungs- und
Verwertungsrecht an dieser Arbeit zu Zwecken der Lehre und Forschung, für
Gutachten und Publikationen erteilt. Bei einer Veröffentlichung von Inhalten
oder Auszügen der Arbeit ist in angemessener Weise auf meinen Beitrag
hinzuweisen. Mit der Veröffentlichung meines Namens und des Themas der Arbeit
in der Liste der am Lehrstuhl angefertigten Arbeiten bin ich einverstanden. Ich
erkläre ferner, dass ich die Inhalte der Arbeit meinerseits nicht ohne
Zustimmung des Lehrstuhls publizieren werde.

\if@mrtarbeit@nodegree\else
    Hiermit erkläre ich, dass ich die vorliegende Arbeit mit dem Thema
    „\@mrtarbeit@title“ noch nicht anderweitig zur Erlangung eines akademischen
    Grades eingereicht habe.
\fi
}% <<<
\newcommand*{\affidavit}{% >>>
    \clearpage%
    \chapter*{Eidesstattliche Erklärung}%
    \sethead{Eidesstattliche Erklärung}%
    \strut%\par
    %\vspace{-2.5pt}
    \noindent\affidavittext%
    \par%
    \vspace{2.38cm}%
    \noindent%
    \setbox\MRTTestBoxA\hbox{Bayreuth, den \@date}%
    \ifdim\MRT@signatureMaxWidth=0pt%
        \MRT@signatureMaxWidth=\dimexpr\textwidth-\wd\MRTTestBoxA-\MRT@signatureSep\relax%
    \else\ifdim\MRT@signatureMaxWidth<\MRT@signaturewidth\relax%
        \MRT@signaturewidth=\MRT@signatureMaxWidth\relax%
    \fi\fi%
    \unhbox\MRTTestBoxA%
    \MRTthesis@rewindauthors%
    \loop%
        \setbox\MRTTestBoxA\hbox{\footnotesize\getauthor}%
        \ifdim\wd\MRTTestBoxA>\MRT@signatureMaxWidth\relax%
            \global\MRT@signaturewidth=\MRT@signatureMaxWidth\relax%
        \else\ifdim\wd\MRTTestBoxA>\MRT@signaturewidth\relax%
            \global\MRT@signaturewidth=\wd\MRTTestBoxA\relax%
        \fi\fi%
        \ifMRTthesis@otherauthor@%
    \repeat%
    \MRTthesis@rewindauthors%
    \loop%
        \hfill\parbox[t]{\MRT@signaturewidth}{%
            \vskip0.4pt\rule{\MRT@signaturewidth}{0.4pt}%
            \vskip -1em%
            \hfill\parbox[t]{\MRT@signaturewidth}{%
                \footnotesize\setstretch{1}\getauthor\hfill%
            }%
        }%
        \ifMRTthesis@otherauthor@%
        \vskip\MRT@signatureheight%
    \repeat}
% <<<
\ExplSyntaxOn
%%==========================================================================<<<

\endinput

% vim: ft=tex fdm=marker fmr=>>>,<<< sw=2 ts=2 tw=80
