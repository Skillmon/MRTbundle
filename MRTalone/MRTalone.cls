\newcommand*\MRTalone@version{0.0.2}
\newcommand*\MRTalone@date{2018-11-07}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse}
\ProvidesExplClass
  {MRTalone}          {\MRTalone@date}
  {\MRTalone@version} {standalone matching MRTthesis}

%% variables >>>
%%=============================================================================
% l3 variables >>>
% bool >>>
\bool_new:N \l_MRTthesis_minimal_bool
\bool_new:N \l_MRTthesis_mathsizes_bool
\bool_new:N \l_MRTthesis_british_bool
\bool_new:N \l_MRTthesis_sfacc_height_bool
% <<<
% <<<
%%==========================================================================<<<

\NewDocumentCommand \MRTaloneSetup { +m }%>>>
  {
    \keys_set:nn { MRTalone/setup } { #1 }
  }%<<<

%% Class options and loading standalone >>>
%%=============================================================================
\DeclareOption{longtable}{\PassOptionsToPackage{longtable}{MRTtab}}
\DeclareOption{mathsizes}{\bool_set_true:N \l_MRTthesis_mathsizes_bool}
\DeclareOption{minimal}{\bool_set_true:N \l_MRTthesis_minimal_bool}
\DeclareOption{no mathsizes}{\bool_set_false:N \l_MRTthesis_mathsizes_bool}
\DeclareOption{tikzunderline}{\PassOptionsToPackage{tUline}{MRTwuline}}
\DeclareOption{tUline}{\ExecuteOptions{tikzunderline}}
\DeclareOption{british}{\bool_set_true:N \l_MRTthesis_british_bool}
\DeclareOption{UKenglish}{\ExecuteOptions{british}}
\DeclareOption{english}{\ExecuteOptions{british}}
\DeclareOption{sfacc = height}{\bool_set_true:N \l_MRTthesis_sfacc_height_bool}
\DeclareOption{sfacc = list}{\bool_set_false:N \l_MRTthesis_sfacc_height_bool}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{standalone}}
\ExecuteOptions{mathsizes}
\PassOptionsToClass{11pt}{standalone}
\ProcessOptions\relax
\LoadClass{standalone}
%%==========================================================================<<<

%% additional packages to achieve template formatting >>>
%%=============================================================================
\RequirePackage{MRTtab,MRTwuline}
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
\bool_if:NTF \l_MRTthesis_british_bool
  {% true >>>
    \RequirePackage[main=british,ngerman]{babel}
    \tl_set:Nn \l_MRTthesis_titlepage_von_tl { from }
  }% <<<
  {% false >>>
    \RequirePackage[ngerman]{babel}
    \tl_set:Nn \l_MRTthesis_titlepage_von_tl { von }
  }% <<<
\RequirePackage{setspace}
\RequirePackage{enumitem}
\RequirePackage[fleqn]{mathtools}
% bad math fonts 
\RequirePackage[italic,defaultmathsizes]{mathastext}
\RequirePackage{isomath}
\bool_if:NTF \l_MRTthesis_sfacc_height_bool
  {
    \RequirePackage[height]{MRTsfacc}
  }
  {
    \RequirePackage[list]{MRTsfacc}
    \MRTsfaccLoadShiftList{helvet}
  }
\bool_if:NT \l_MRTthesis_mathsizes_bool%>>>
  {
    \DeclareMathSizes{10.95pt}{10.95pt}{9pt}{7pt}
  }%<<<
\bool_if:NF \l_MRTthesis_minimal_bool%>>>
  {
    \cs_new:Nn \MRTalone_range_phrase:n
      {
        \mode_if_math:TF { \text { ~#1~ } } { ~#1~ }
      }
    \RequirePackage{siunitx}
    \sisetup{% set options of the siunitx package
        ,detect-all%
        ,per-mode=reciprocal-positive-first%
    }%
    \addto\extrasngerman
      { \sisetup{ locale=DE, range-phrase=\MRTalone_range_phrase:n { bis } } }
    \addto\extrasbritish
      { \sisetup{ locale=UK, range-phrase=\MRTalone_range_phrase:n { to } } }
  }%<<<
%%==========================================================================<<<

%% setup options >>>
%%=============================================================================
\keys_define:nn { MRTalone/setup }% >>>
  {
    ,caption~above   .code:n     = { \MRTtabSetup { caption~above } }
    ,caption~above   .value_forbidden:n = true
    ,caption~below   .code:n     = { \MRTtabSetup { caption~below } }
    ,caption~below   .value_forbidden:n = true
    ,stretch~caption .code:n     = {}
      %{% >>>
        %\setkomafont { caption }      { \setstretch { #1 } \normalfont }
        %\setkomafont { captionlabel } { \setstretch { #1 } \normalfont }
      %}% <<<
    ,stretch~cap     .meta:n     = { stretch~caption={#1} }
    ,stretch~tabular .code:n     = { \MRTtabSetup { stretch~tab={#1} } }
    ,stretch~tab     .meta:n     = { stretch~tabular={#1} }
    ,stretch~text    .code:n     = { \setstretch { #1 } }
    ,stretches       .meta:n     =
      { stretch~cap={#1}, stretch~tab={#1}, stretch~text={#1} }
    ,table~spacing   .bool_set:N = \l_MRTthesis_table_spacing_bool
    ,table~spacing   .default:n  = { true }
    ,tab~spacing     .meta:n     = { table~spacing={#1} }
    ,tab~spacing     .default:n  = { true }
  }% <<<
% defaults >>>
\keys_set:nn { MRTalone/setup }% >>>
  {
    ,caption~below
    ,stretches = 1.408
    ,tab~spacing
  }% <<<
% <<<
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

% Setting up MRTtab to work in standalone by default
\MRTtabSetup{in~text~sep=\c_zero_skip,no~float}
