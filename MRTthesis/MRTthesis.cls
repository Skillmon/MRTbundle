\newcommand*\MRTthesis@version{0.1}
\newcommand*\MRTthesis@date{2018/04/22}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif,MRTsfacc} % absolutely necessary packages
\ProvidesExplClass
  {MRTthesis}          {\MRTthesis@date}
  {\MRTthesis@version} {thesis template for MRT - University of Bayreuth}


%% variables >>>
%%=============================================================================
% boxes >>>
\newbox\MRTthesis@TestBoxA
% <<<
% dimens >>>
\newdimen\MRTthesis@pageheadOffset
\newdimen\MRTthesis@headingsfix
% <<<
% ifs >>>
\newif\ifMRTbibliography
% <<<
% l3 variables >>>
% bool >>>
\bool_new:N \l_MRTthesis_minimal_bool
\bool_new:N \l_MRTthesis_mathsizes_bool
\bool_new:N \l_MRTthesis_tikzuline_bool
\bool_new:N \l_MRTthesis_UKenglish_bool
% <<<
% box >>>
\box_new:N \l_MRTthesis_tmpa_box
% <<<
% clist >>>
\clist_new:N \l_MRTthesis_tmpa_clist
% <<<
% seq >>>
\seq_new:N \g_MRTthesis_authors_seq
\seq_new:N \l_MRTthesis_tmpa_seq
% <<<
% tl >>>
\tl_new:N \l_MRTthesis_tmpa_tl
\tl_new:N \l_MRTthesis_tmpb_tl
\tl_new:N \l_MRTthesis_titlepage_von_tl
% <<<
% <<<
%%==========================================================================<<<

%% Class options and loading scrreprt >>>
%%=============================================================================
\DeclareOption{minimal}{\bool_set_true:N \l_MRTthesis_minimal_bool}
\DeclareOption{longtable}{\PassOptionsToPackage{longtable}{MRTtab}}
\DeclareOption{mathsizes}{\bool_set_true:N \l_MRTthesis_mathsizes_bool}
\DeclareOption{no mathsizes}{\bool_set_false:N \l_MRTthesis_mathsizes_bool}
\DeclareOption{tikzunderline}{\bool_set_true:N \l_MRTthesis_tikzuline_bool}
\DeclareOption{tUline}{\ExecuteOptions{tikzunderline}}
\DeclareOption{UKenglish}{\bool_set_true:N \l_MRTthesis_UKenglish_bool}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreprt}}
\ExecuteOptions{mathsizes}
\PassOptionsToClass
  {twoside,fontsize=11pt,a4paper,toc=listof,toc=bib,fleqn,ngerman}
  {scrreprt}
\ProcessOptions\relax
\LoadClass{scrreprt}
%%==========================================================================<<<

%% additional packages to achieve template formatting >>>
%%=============================================================================
\RequirePackage{MRTtab}
\bool_if:nTF { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }
  {% true >>>
    \RequirePackage{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
  }% <<<
  {% false >>>
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
  }%<<<
\RequirePackage{lmodern}
\RequirePackage{helvet}
\renewcommand\familydefault{\sfdefault}
\RequirePackage{textcomp}
\bool_if:NTF \l_MRTthesis_UKenglish_bool
  {% true >>>
    \RequirePackage[main=UKenglish,ngerman]{babel}
    \tl_set:Nn \l_MRTthesis_titlepage_von_tl { from }
  }% <<<
  {% false >>>
    \RequirePackage[ngerman]{babel}
    \tl_set:Nn \l_MRTthesis_titlepage_von_tl { von }
  }% <<<
\RequirePackage[singlespacing=true]{scrlayer-scrpage}
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
\bool_if:NT \l_MRTthesis_mathsizes_bool%>>>
  {
    \DeclareMathSizes{10.95pt}{10.95pt}{9pt}{7pt}
  }%<<<
% 
\AtBeginDocument{\RequirePackage{hyperref}\MRTthesis@after@hyperref}
\bool_if:NF \l_MRTthesis_minimal_bool%>>>
  {
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
  }%<<<
%%==========================================================================<<<

%% setup options >>>
%%=============================================================================
\keys_define:nn { MRTthesis/setup }% >>>
  {
    ,advisor         .tl_set:N   = \l_MRTthesis_advisor_tl
    ,author          .tl_set:N   = \l_MRTthesis_authors_tl
    ,degree          .tl_set:N   = \l_MRTthesis_degree_tl
    ,caption~above   .code:n     = { \MRTtabSetup { caption~above } }
    ,caption~above   .value_forbidden:n = true
    ,caption~below   .code:n     = { \MRTtabSetup { caption~below } }
    ,caption~below   .value_forbidden:n = true
    ,examinor        .tl_set:N   = \l_MRTthesis_examinor_tl
    ,logoL           .tl_set:N   = \l_MRTthesis_logoL_tl
    ,logoL~height    .dim_set:N  = \l_MRTthesis_logoL_height_dim
    ,logoR           .tl_set:N   = \l_MRTthesis_logoR_tl
    ,logoR~height    .dim_set:N  = \l_MRTthesis_logoR_height_dim
    ,no~advisor      .bool_set:N = \l_MRTthesis_no_advisor_bool
    ,no~advisor      .default:n  = { true }
    ,no~citation     .bool_set:N = \l_MRTthesis_no_citation_bool
    ,no~citation     .default:n  = { true }
    ,no~degree       .bool_set:N = \l_MRTthesis_no_degree_bool
    ,no~degree       .default:n  = { true }
    ,no~examinor     .bool_set:N = \l_MRTthesis_no_examinor_bool
    ,no~examinor     .default:n  = { true }
    ,no~institute    .bool_set:N = \l_MRTthesis_no_institute_bool 
    ,no~institute    .default:n  = { true } 
    ,no~logos        .meta:n     = { logoL={},logoR={} }
    ,no~thesis       .bool_set:N = \l_MRTthesis_no_thesis_bool
    ,no~thesis       .default:n  = { true }
    ,no~usage        .bool_set:N = \l_MRTthesis_no_usage_bool
    ,no~usage        .default:n  = { true }
    ,number          .tl_set:N   = \l_MRTthesis_number_tl
    ,pos~figure      .tl_set:N   = \fps@figure
    ,pos~float       .meta:n     = { pos~figure={#1}, pos~table={#1} }
    ,pos~MRTtable    .code:n     = { \MRTtabSetup { pos = { #1 } } }
    ,pos~table       .tl_set:N   = \fps@table
    ,short~advisor   .tl_set:N   = \l_MRTthesis_s_advisor_tl
    ,sadvisor        .meta:n     = { short~advisor={#1} }
    ,short~author    .tl_set:N   = \l_MRTthesis_s_author_tl
    ,sauthor         .meta:n     = { short~author={#1} }
    ,short~examinor  .tl_set:N   = \l_MRTthesis_s_examinor_tl
    ,sexaminor       .meta:n     = { short~examinor={#1} }
    ,sign~height     .dim_set:N  = \l_MRTthesis_sign_height_dim
    ,sign~seperation .dim_set:N  = \l_MRTthesis_sign_seperation_dim
    ,sign~sep        .meta:n     = { sign~seperation={#1} }
    ,sign~width~max  .dim_set:N  = \l_MRTthesis_sign_width_max_dim
    ,sign~width~min  .dim_set:N  = \l_MRTthesis_sign_width_dim
    ,stretch~caption .code:n     =
      {% >>>
        \setkomafont { caption }      { \setstretch { #1 } \normalfont }
        \setkomafont { captionlabel } { \setstretch { #1 } \normalfont }
      }% <<<
    ,stretch~cap     .meta:n     = { stretch~caption={#1} }
    ,stretch~tabular .code:n     = { \MRTtabSetup { stretch~tab={#1} } }
    ,stretch~tab     .meta:n     = { stretch~tabular={#1} }
    ,stretch~text    .code:n     = { \setstretch { #1 } }
    ,stretches       .meta:n     =
      { stretch~cap={#1}, stretch~tab={#1}, stretch~text={#1} }
    ,subtitle        .tl_set:N   = \l_MRTthesis_subtitle_tl
    ,table~spacing   .bool_set:N = \l_MRTthesis_table_spacing_bool
    ,table~spacing   .default:n  = { true }
    ,tab~spacing     .meta:n     = { table~spacing={#1} }
    ,tab~spacing     .default:n  = { true }
    ,thesis          .tl_set:N   = \l_MRTthesis_thesis_tl
    ,title           .tl_set:N   = \l_MRTthesis_title_tl
    ,toc~ChapIndent  .tl_set:N   = \l_MRTthesis_toc_chapter_indent_tl
    ,toc~SecIndent   .tl_set:N   = \l_MRTthesis_toc_section_indent_tl
    ,toc~sSecIndent  .tl_set:N   = \l_MRTthesis_toc_subsection_indent_tl
    ,toc~ssSecIndent .tl_set:N   = \l_MRTthesis_toc_subsubsection_indent_tl
    ,with~subtitle   .bool_set:N = \l_MRTthesis_with_subtitle_bool
  }% <<<
% defaults >>>
\keys_set:nn { MRTthesis/setup }% >>>
  {
    ,advisor = {\textcolor{blue}{Mein~Betreuer}}
    ,examinor = {Univ.-Professor~Dr.-Ing.~Gerhard~Fischerauer}
    ,caption~below
    ,logoL = {MRTthesis_logo_UBT2.pdf}
    ,logoR = {MRTthesis_logo_MRT2.pdf}
    ,logoL~height = 10.85mm
    ,logoR~height = 11.9mm
    ,number = {\textcolor{blue}{XX-00-00-0}}
    ,pos~float = tbp
    ,sadvisor = {\textcolor{blue}{M.~Betreuer}}
    ,sauthor  = {}
    ,sexaminor = {G.~Fischerauer}
    ,sign~height = 9mm
    ,sign~width~min = 7cm
    ,sign~width~max = 0pt
    ,sign~seperation = 2em
    ,stretch~cap = 1.408
    ,stretch~tab = 1.408
    ,stretch~text = 1.408
    ,tab~spacing
    ,thesis = {\textcolor{blue}{Meine~Arbeit}}
    ,title  = {\textcolor{blue}{UNTERSUCHUNG~ZU ...}}
    ,toc~ChapIndent = 0.01em
    ,toc~SecIndent  = 1.32em
    ,toc~sSecIndent = 3.38em
    ,toc~ssSecIndent = 6.38em
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
% auxiliary like>>>
\long\def\@firstofthree#1#2#3{#1}
\long\def\@secondofthree#1#2#3{#2}
\long\def\@thirdofthree#1#2#3{#3}
\NewDocumentCommand \ifNoWidthTF { +m }% >>>
  {%
    \bgroup
    \setbox\MRTthesis@TestBoxA\hbox{#1}%
    \ifdim\wd\MRTthesis@TestBoxA=0pt
      \egroup
      \expandafter\@firstoftwo
    \else
      \egroup
      \expandafter\@secondoftwo
    \fi
  }% <<<
\NewExpandableDocumentCommand \vfillmult { m }% >>>
  {%
    \vskip 0pt plus #1fill\relax
  }% <<<
\NewExpandableDocumentCommand \hfillmult { m }% >>>
  {%
    \hskip 0pt plus #1fill\relax
  }% <<<
\cs_new:Nn \MRTthesis_display_logo:n% >>>
  {
    \exp_args:Nx \tl_if_empty:nF { \tl_use:c { l_MRTthesis_logo #1 _tl } }
      {
        \MRTthesis_display_logo_expanded:xx
          { \dim_use:c { l_MRTthesis_logo #1 _height_dim } }
          { \tl_use:c { l_MRTthesis_logo #1 _tl } }
      }
  }% <<<
\cs_new:Nn \MRTthesis_display_logo_expanded:nn% >>>
  {
    \includegraphics[height=#1]{#2}
  }% <<<
\cs_generate_variant:Nn \MRTthesis_display_logo_expanded:nn { xx }
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
\newcommand*\MRTthesis@fntsel[2]{\fontsize{#1bp}{#2bp}\selectfont}
% ToC related >>>
\NewDocumentCommand \DeclareTOCStyleEntryMRTSectionLike% >>>
  { O{\l_MRTthesis_toc_section_indent_tl} m }
  {%
    \expandafter\DeclareTOCStyleEntry\expandafter
      [%
        \MRTthesis@toc@default@section
        ,indent=#1%
      ]
      {tocline}{#2}%
  }% <<<
\NewDocumentCommand \DeclareTOCStyleEntryMRTChapterLike% >>>
  { O{\l_MRTthesis_toc_chapter_indent_tl} m }
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
\bool_if:NT \l_MRTthesis_tikzuline_bool% >>>
  {
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
  }% <<<
\def\MRTthesis@HeadingsUline{\WUline}
\NewExpandableDocumentCommand \WUline { s o m }% >>>
  {
    \IfBooleanTF { #1 }
      { \MRTthesis@star@WUline   { #2 } { #3 } }
      { \MRTthesis@nostar@WUline { #2 } { #3 } }
  }% <<<
\newcommand*\MRTthesis@star@WUline[2]% >>>
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
\newcommand*\MRTthesis@nostar@WUline[2]% >>>
  {%
    \IfNoValueTF { #1 }
      { \MRTthesis@WUline@setheight }
      { \MRTthesis@WUline@height=#1 }
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
% title, author, ... >>>
\RenewDocumentCommand \title { +m }%>>>
  {
    \keys_set:nn { MRTthesis/setup } { title={#1} }
  }%<<<
\RenewDocumentCommand \subtitle { +m }%>>>
  {
    \keys_set:nn { MRTthesis/setup } { subtitle={#1} }
  }%<<<
\RenewDocumentCommand \author { o m }%>>>
  {
    \keys_set:nn { MRTthesis/setup } { author = { #2 } }
    \IfNoValueF { #1 }
      {
        \keys_set:nn { MRTthesis/setup } { short~author = { #1 } }
      }
  }%<<<
% <<<
\NewDocumentCommand \sethead { m } { \markboth{#1}{#1} }
%% MRTtable
%\NewDocumentEnvironment { MRTtable } { O{} }% >>>
  %{% >>>
    %\MRTthesis_provide_head:
  %}% <<<
  %{% >>>
  %}% <<<
%% <<<
%\cs_new_protected_nopar:Nn \MRTthesis_provide_head:% >>>
  %{
    %\DeclareExpandableDocumentCommand \head { +m }
      %{
        %\l__MRTthesis_table_head_start_tl
        %\tl_set:Nn \l_MRTthesis_head_cont_tl { ##1 }
        %\tl_if_in:NnT \l_MRTthesis_head_cont_tl { \\ }
          %{
            %\exp_args:NnV \regex_match:nnTF { \c{\\}\s*\[.*?\] }
              %\l_MRTthesis_head_cont_tl
              %{
                %\regex_replace_all:nnN { (\c{\\}\s*\[.*?\]) }
                  %{ \1 \c{l__MRTthesis_table_head_start_tl} }
                  %\l_MRTthesis_head_cont_tl
              %}
              %{
                %\regex_replace_all:nnN { (\c{\\}) }
                  %{ \1 \c{l__MRTthesis_table_head_start_tl} }
                  %\l_MRTthesis_head_cont_tl
              %}
          %}
        %\l_MRTthesis_head_cont_tl \\
        %\hline
      %}
  %}% <<<
%\tl_new:N \l__MRTthesis_table_head_start_tl
%\tl_set:Nn \l__MRTthesis_table_head_start_tl
  %{
    %\rowcolor{tablegray}
    %\bool_if:NT \l_MRTthesis_table_spacing_bool { \l__MRTthesis_table_strut }
  %}
%\tl_new:N \l_MRTthesis_strut_add_tl
%\tl_set:Nn \l_MRTthesis_strut_add_tl { .8ex }
%\tl_new:N \l__MRTthesis_table_strut
%\tl_set:Nn \l__MRTthesis_table_strut% >>>
  %{
    %\vrule height \dimexpr 1ex + \l_MRTthesis_strut_add_tl \relax
           %depth \l_MRTthesis_strut_add_tl
           %width 0pt
  %}% <<<
%
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
\MRTthesis@headingsfix=2pt
\renewcommand\chapterlinesformat[3]% >>>
  {%
    \MRTthesis@headingsformat {} { #2 } { \MRTthesis@HeadingsUline { #3 } }
  }
% <<<
\renewcommand\sectionlinesformat[4]% >>>
  {%
    \begingroup
    \MRTifStringsMatchTF{#1}{paragraph}
      {%
        \let\MRTthesis@HeadingsUline\relax
      }
      {%
        \MRTifStringsMatchT{#1}{subparagraph}%
          {%
            \let\MRTthesis@HeadingsUline\relax
          }%
      }%
    \MRTthesis@headingsformat { #2 } { #3 } { #4 }
    \endgroup
  }
% <<<
\newcommand\MRTthesis@headingsformat[3]%>>>
  {
    \begingroup
    \setbox \MRTthesis@TestBoxA \hbox
      {
        \MRTifEmptyF { #1 } { \hskip#1 }
        \ifNoWidthTF { #2 } { \kern \MRTthesis@headingsfix }
          {
            \MRTthesis@HeadingsUline
              {
                #2
                \kern 0.1em
                \kern \MRTthesis@headingsfix
              }
          }
      }
    \usebox \MRTthesis@TestBoxA
    \kern -\MRTthesis@headingsfix
    \parbox[t]
      {
        \dimexpr
          \textwidth - \wd \MRTthesis@TestBoxA + \MRTthesis@headingsfix
        \relax
      }
      { #3 }
    \endgroup
  }%<<<
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
\setkomafont{pageheadfoot}%>>>
  {
    \mbox{}\vspace{-4.4pt}
    \selectfont\normalfont\small
  }%<<<
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
\RenewDocumentCommand \appendix {}% >>>
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
\NewDocumentCommand \mainpart {}% >>>
  {%
    \cleardoublepage
    \pagenumbering{arabic}%
  }% <<<
%%==========================================================================<<<

%% bibliography >>>
%%=============================================================================
\bool_if:NTF \l_MRTthesis_minimal_bool
  {% true >>>
    \MRTbibliographyfalse
  }% <<<
  {% false >>>
    \MRTbibliographytrue
    \renewcommand*{\newunitpunct}{, }% between each unit in one bib-entry
    \DefineBibliographyStrings{ngerman}
      {%
        ,bibliography={Literaturverzeichnis}%
        ,in={}% removes 'In:' infront of journal name
        ,andothers={et\,al\adddot}%
      }
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
  }% <<<
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
\ExplSyntaxOff%>>>
\newcommand*\affidavittext@base% >>>
  {%
    Hiermit versichere ich an Eides statt, dass ich die vorliegende Arbeit
    selbst\"andig und unter Angabe aller Hilfsmittel und Referenzen angefertigt
    habe. Eine Ausnahme bilden die pers\"onlichen Mitteilungen der Betreuer der
    Arbeit, die st\"andig eingeflossen sind und daher nicht im Einzelnen
    nachgewiesen werden.%
  }% <<<
\newcommand*\affidavittext@usagerights% >>>
  {%
    Der Universit\"at Bayreuth, vertreten durch den Lehrstuhl f\"ur Mess- und
    Regeltechnik (Prof. Dr.-Ing. Fischerauer), habe ich das Nutzungs- und
    Verwertungsrecht an dieser Arbeit zu Zwecken der Lehre und Forschung, f\"ur
    Gutachten und Publikationen erteilt. Bei einer Ver\"offentlichung von
    Inhalten oder Ausz\"ugen der Arbeit ist in angemessener Weise auf meinen
    Beitrag hinzuweisen. Mit der Ver\"offentlichung meines Namens und des Themas
    der Arbeit in der Liste der am Lehrstuhl angefertigten Arbeiten bin ich
    einverstanden. Ich erkl\"are ferner, dass ich die Inhalte der Arbeit
    meinerseits nicht ohne Zustimmung des Lehrstuhls publizieren werde.%
  }% <<<
\newcommand*\affidavittext@degree% >>>
  {%
    Hiermit erkl\"are ich, dass ich die vorliegende Arbeit mit dem Thema
    „\csname l_MRTthesis_title_tl\endcsname“ noch nicht anderweitig zur
    Erlangung eines akademischen Grades eingereicht habe.%
  }% <<<
\ExplSyntaxOn%<<<
\NewExpandableDocumentCommand \affidavittext {}% >>>
  {
    \affidavittext@base
    \bool_if:NF \l_MRTthesis_no_usage_bool { \par \affidavittext@usagerights }
    \bool_if:NF \l_MRTthesis_no_degree_bool { \par \affidavittext@degree }
  }% <<<
\NewDocumentCommand \affidavit {}% >>>
  {
    \cleardoublepage
    \chapter*{Eidesstattliche~Erkl\"arung}
    \sethead{Eidesstattliche~Erkl\"arung}
    \strut
    \noindent\affidavittext
    \par
    \vspace{2.38cm}
    \noindent
    \hbox_set:Nn \l_MRTthesis_tmpa_box { Bayreuth,~den~\@date }
    \dim_compare:nNnTF { \l_MRTthesis_sign_width_max_dim } = { 0pt }
      {
        \dim_set:Nn \l_MRTthesis_sign_width_max_dim
          { \box_wd:N \l_MRTthesis_tmpa_box }
      }
      {
        \dim_compare:nNnT
          \l_MRTthesis_sign_width_max_dim < \l_MRTthesis_sign_width_dim
          {
            \dim_set_eq:NN \l_MRTthesis_sign_width_dim
              \l_MRTthesis_sign_width_max_dim
          }
      }
    \hbox_unpack_clear:N \l_MRTthesis_tmpa_box
    \MRTthesis_affidavit_get_sign_width:
    \seq_map_function:NN \g_MRTthesis_authors_seq
      \MRTthesis_affidavit_sign_authors:n
  }% <<<
\cs_new_protected:Nn \MRTthesis_affidavit_sign_authors:n% >>>
  {
    \mbox{}\hfill
    \parbox[t]{\l_MRTthesis_sign_width_dim}
      {
        \setstretch{1}
        \vskip.4pt\rule{\l_MRTthesis_sign_width_dim}{.4pt}
        \vskip-.5em
        \hfill
        \parbox[t]{\l_MRTthesis_sign_width_dim}
          {
            \footnotesize
            \MRTthesis_typeout_author:n { #1 }
            \hfill
          }
      }
    \vskip\l_MRTthesis_sign_height_dim
  }% <<<
\cs_new:Nn \MRTthesis_affidavit_get_sign_width:% >>>
  {
    \seq_map_inline:Nn \g_MRTthesis_authors_seq
      {
        \hbox_set:Nn \l_MRTthesis_tmpa_box
          {
            \footnotesize
            \MRTthesis_typeout_author:n { ##1 }
          }
        \dim_set:Nn \l_MRTthesis_sign_width_dim
          {
            \dim_min:nn { \l_MRTthesis_sign_width_max_dim }
              {
                \dim_max:nn { \l_MRTthesis_sign_width_dim }
                  { \box_wd:N \l_MRTthesis_tmpa_box }
              }
          }
      }
  }% <<<
%%==========================================================================<<<

%% title page >>>
%%=============================================================================
\RenewDocumentCommand \maketitle {}% >>>
  {%
    \thispagestyle{empty}
    \newgeometry{left=25mm,right=25mm,top=9mm,bottom=23.4mm}
    \MRTthesis_parse_authors:
    \setbox\MRTthesis@TestBoxA\vbox
      {% >>>
        \setstretch{1}
        \noindent
        \MRTthesis_display_logo:n { L }
        \hfill
        \MRTthesis_display_logo:n { R }
        \vfillmult{9}
        \begin{center}% >>>
          \group_begin:% >>>
            \bfseries
            \MRTthesis_titlepage_place_title:\\
            \vfillmult{3}
            \MRTthesis@fntsel{12}{12}\l_MRTthesis_titlepage_von_tl\\
            \vfillmult{2}
            \MRTthesis_titlepage_place_authors:
          \group_end:% <<<
          \vfillmult{4}
          \bool_if:nF
            {
              \l_MRTthesis_no_thesis_bool
              || \tl_if_empty_p:N \l_MRTthesis_thesis_tl
            }
            { \MRTthesis_titlepage_place_thesis_block: }
          \vfillmult{5}
          \bool_if:NF \l_MRTthesis_no_examinor_bool% ausgegeben von >>>
            {
              \group_begin:
                \MRTthesis@fntsel{12}{16}
                Ausgegeben~von\\
                \textbf{\l_MRTthesis_examinor_tl}
                \bool_if:nF
                  {
                    \l_MRTthesis_no_advisor_bool
                    || \tl_if_empty_p:N \l_MRTthesis_advisor_tl
                  }
                  {
                    ,\\mitbetreut~von\\
                    \textbf{\l_MRTthesis_advisor_tl}\\
                  }
              \group_end:
            }% <<<
          \vfillmult{5}
          \bool_if:NF \l_MRTthesis_no_institute_bool% institute >>>
            {
              \group_begin:
                \MRTthesis@fntsel{12}{16}
                Lehrstuhl~f\"ur~Mess-~und~Regeltechnik\\
                Fakult\"at~f\"ur~Ingenieurwissenschaften,~Universität~Bayreuth\\
              \group_end:
            }% <<<
          \vfillmult{2}
          \MRTthesis@fntsel{12}{16}\textbf{\@date}\\
        \end{center}% <<<
        \vfillmult{5}
        \MRTthesis_titlepage_place_citation:
      }% <<<
    \ifdim\ht\MRTthesis@TestBoxA>.9622879\textheight
      \msg_error:nn { MRTthesis } { titlepage~too~long }
    \else
      \vbox to \textheight{\unvbox\MRTthesis@TestBoxA}
    \fi
    \cleardoublepage
    \restoregeometry
  }% <<<
\cs_new_protected_nopar:Nn \MRTthesis_parse_authors:% >>>
  {
    \seq_gset_split:NnV \g_MRTthesis_authors_seq
      { \and } \l_MRTthesis_authors_tl
    \tl_if_empty:NTF \l_MRTthesis_s_author_tl
      {
        \seq_set_eq:NN \l_MRTthesis_tmpa_seq \g_MRTthesis_authors_seq
        \tl_gset:Nn \g_MRTthesis_s_author_tl
          {
            \bool_while_do:nn { !\seq_if_empty_p:N \l_MRTthesis_tmpa_seq }
              {
                \seq_pop:NN \l_MRTthesis_tmpa_seq \l_MRTthesis_tmpa_tl
                \tl_if_in:NnTF \l_MRTthesis_tmpa_tl { , }
                  {
                    \clist_set:NV \l_MRTthesis_tmpa_clist \l_MRTthesis_tmpa_tl
                    \tl_set:Nx \l_MRTthesis_tmpb_tl
                      {
                        \clist_item:Nn \l_MRTthesis_tmpa_clist { \c_two }
                      }
                    \seq_set_split:NnV \l_MRTthesis_tmpb_seq
                      { ~ } \l_MRTthesis_tmpb_tl
                    \bool_while_do:nn
                      { !\seq_if_empty_p:N \l_MRTthesis_tmpb_seq }
                      {
                        \seq_pop:NN \l_MRTthesis_tmpb_seq \l_MRTthesis_tmpb_tl
                        \tl_if_in:NnTF \l_MRTthesis_tmpb_tl { - }
                          {
                            \seq_set_split:NnV \l_MRTthesis_tmpc_seq
                              { - } \l_MRTthesis_tmpb_tl
                            \bool_while_do:nn
                              { !\seq_if_empty_p:N \l_MRTthesis_tmpc_seq }
                              {
                                \seq_pop:NN
                                  \l_MRTthesis_tmpc_seq \l_MRTthesis_tmpc_tl
                                \exp_after:wN \MRTthesis_only_first_token:w
                                  \l_MRTthesis_tmpc_tl \q_nil.\@
                                \seq_if_empty:NTF \l_MRTthesis_tmpc_seq
                                  { 
                                    \seq_if_empty:NTF \l_MRTthesis_tmpb_seq
                                      { ~ }
                                      { \, }
                                  }
                                  { - }
                              }
                          }
                          {
                            \exp_after:wN \MRTthesis_only_first_token:w
                              \l_MRTthesis_tmpb_tl \q_nil.\@
                            \seq_if_empty:NTF \l_MRTthesis_tmpb_seq { ~ } { \, }
                          }
                      }
                    \clist_item:Nn \l_MRTthesis_tmpa_clist { \c_one }
                  }
                  {
                    \seq_set_split:NnV \l_MRTthesis_tmpb_seq
                      { ~ } \l_MRTthesis_tmpa_tl
                    \int_step_inline:nn
                      { \seq_count:N \l_MRTthesis_tmpb_seq - \c_one }
                      {
                        \tl_set:Nx \l_MRTthesis_tmpb_tl
                          { \seq_item:Nn \l_MRTthesis_tmpb_seq { ##1 } }
                        \tl_if_in:NnTF \l_MRTthesis_tmpb_tl { - }
                          {
                            \seq_set_split:NnV \l_MRTthesis_tmpc_seq
                              { - } \l_MRTthesis_tmpb_tl
                            \bool_do_while:nn
                              { !\seq_if_empty_p:N \l_MRTthesis_tmpc_seq }
                              {
                                \seq_pop:NN
                                  \l_MRTthesis_tmpc_seq \l_MRTthesis_tmpc_tl
                                \exp_after:wN \MRTthesis_only_first_token:w
                                  \l_MRTthesis_tmpc_tl \q_nil.\@
                                \seq_if_empty:NTF \l_MRTthesis_tmpc_seq
                                  {
                                    \int_compare:nNnTF
                                      { ##1 + \c_one } <
                                      { \seq_count:N \l_MRTthesis_tmpb_seq }
                                      { \, } { ~ }
                                  }
                                  { - }
                              }
                          }
                          {
                            \exp_after:wN \MRTthesis_only_first_token:w
                              \l_MRTthesis_tmpb_tl \q_nil.\@
                            \int_compare:nNnTF
                              { ##1 + \c_one } <
                              { \seq_count:N \l_MRTthesis_tmpb_seq }
                              { \, } { ~ }
                          }
                      }
                    \seq_item:Nn \l_MRTthesis_tmpb_seq
                      { \seq_count:N \l_MRTthesis_tmpb_seq }
                  }
                  \seq_if_empty:NF \l_MRTthesis_tmpa_seq { ,~ }
              }
          }
      }
      { \tl_gset_eq:NN \g_MRTthesis_s_author_tl \l_MRTthesis_s_author_tl }
  }% <<<
\cs_new:Npn \MRTthesis_only_first_token:w #1#2\q_nil { #1 }
\cs_new_nopar:Nn \MRTthesis_titlepage_place_title:% >>>
  {
    \MRTthesis@fntsel{20}{34.5}
    \ifcsname MRTFirstTitle\endcsname
      \MRTFirstTitle
    \else
      \l_MRTthesis_title_tl
    \fi
    \bool_if:NT \l_MRTthesis_with_subtitle_bool
      {
        \vfill
        \group_begin:
        \MRTthesis@fntsel{15}{15}
        \l_MRTthesis_subtitle_tl
        \group_end:
      }
  }% <<<
\cs_new_nopar:Nn \MRTthesis_titlepage_place_authors:% >>>
  {
    \seq_set_eq:NN \l_MRTthesis_tmpa_seq \g_MRTthesis_authors_seq
    \MRTthesis@fntsel{12}{12}
    \bool_while_do:nn { !\seq_if_empty_p:N \l_MRTthesis_tmpa_seq }
      {
        \seq_pop:NN \l_MRTthesis_tmpa_seq \l_MRTthesis_tmpa_tl
        \MRTthesis_typeout_author:V \l_MRTthesis_tmpa_tl
        \\\vfill
      }
  }% <<<
\cs_new_nopar:Nn \MRTthesis_titlepage_place_thesis_block:% >>>
  {
    \MRTthesis@fntsel{12}{15}\textbf{\l_MRTthesis_thesis_tl}
    \bool_if:NF \l_MRTthesis_no_degree_bool
      {
        \\\MRTthesis@fntsel{12}{16}
        zur~Erlangung~des~akademischen~Grades\\
        \MRTthesis@fntsel{12}{16}
        \tl_if_empty:NTF \l_MRTthesis_degree_tl
          {
            \str_case:onF { \l_MRTthesis_thesis_tl }
              {
                { Masterarbeit }    { Master~of~Science }
                { Bachelorarbeit }  { Bachelor~of~Science }
                { Diplomarbeit }    { Diplom~Ingenieur }
                { Master thesis }   { Master~of~Science }
                { Bachelor thesis } { Bachelor~of~Science }
              }
              {
                \msg_error:nn { MRTthesis } { degree~undefined }
                \textcolor{blue}{Mein akademischer Grad}
              }
          }
          { \l_MRTthesis_degree_tl }
        \\
      }
  }% <<<
\cs_new_nopar:Nn \MRTthesis_titlepage_place_citation:% >>>
  {
    \bool_if:NTF \l_MRTthesis_no_citation_bool
      {
        \group_begin:
        \MRTthesis@fntsel{10}{13.24}
        \vspace*{4\baselineskip}
        \group_end:
      }
      {
        \parbox[b]{.5\textwidth}
          {
            \MRTthesis@fntsel{10}{13.24}
            Zitierhinweis:\\
            \group_begin:
              \cs_set:Npn \and { \unskip,~ }
              \g_MRTthesis_s_author_tl
            \group_end:
            \bool_if:nF
              {
                \l_MRTthesis_no_advisor_bool
                || \tl_if_empty_p:N \l_MRTthesis_s_advisor_tl
                || \tl_if_empty_p:N \l_MRTthesis_advisor_tl
              }
              { ,~\l_MRTthesis_s_advisor_tl }
            \bool_if:nF
              {
                \l_MRTthesis_no_examinor_bool
                || \tl_if_empty_p:N \l_MRTthesis_s_examinor_tl
              }
              { ,~\l_MRTthesis_s_examinor_tl }
            \c_colon_str\\
            \l_MRTthesis_title_tl;\\
            MRT-Bericht~Nr.~\l_MRTthesis_number_tl;~Bayreuth~(\the\year)
          }
      }
  }% <<<
\cs_new:Nn \MRTthesis_typeout_author:n%>>>
  {
    \tl_if_in:nnTF { #1 } { , }
      {
        \clist_set:Nn \l_MRTthesis_tmpa_clist { #1 }
        \clist_item:Nn \l_MRTthesis_tmpa_clist { 2 }~
        \clist_item:Nn \l_MRTthesis_tmpa_clist { 1 }
      }
      {
        #1
      }
  }%<<<
\cs_generate_variant:Nn \MRTthesis_typeout_author:n { V }
%%==========================================================================<<<

\endinput

% vim: ft=tex fdm=marker fmr=>>>,<<< sw=2 ts=2 tw=80
