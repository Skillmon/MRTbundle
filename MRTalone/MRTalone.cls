\newcommand*\MRTalone@version{0.0.11}
\newcommand*\MRTalone@date{2021-06-04}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif}
\ProvidesExplClass
  {MRTalone}          {\MRTalone@date}
  {\MRTalone@version} {standalone matching MRTthesis}

\@ifpackagelater{expl3}{2018/10/10}
  { \prop_gput:Nnn \g_msg_module_type_prop { MRTalone } { Class } } {}

%% variants of external macros >>=
%%=============================================================================
\cs_generate_variant:Nn \keys_set:nn { nV }
%%===========================================================================<<

%% variables >>=
%%=============================================================================
% l3 variables >>=
% bool >>=
\bool_new:N \l_MRTalone_minimal_bool
\bool_new:N \l_MRTalone_british_bool
% =<<
% tl >>=
\tl_const:Nn \c_MRTalone_setup_file_name_tl { ./MRTalone.setup.tex }
\tl_const:Nn \c_MRTalone_options_file_name_tl { ./MRTalone.option.tex }
% =<<
% =<<
%%===========================================================================<<

%% constants >>=
%%=============================================================================
\bool_const:Nn \c_MRTalone_xetex_or_luatex_bool
  { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }
%%===========================================================================<<

%% messages >>=
%%=============================================================================
\msg_new:nnn { MRTalone } { wrong~engine }%>>=
  {
    The ~ used ~ #1 ~ is ~ not ~ available ~ under ~ \c_sys_engine_str. ~ You ~
    have ~ to ~ use ~ #2.
  }%=<<
\msg_new:nnn { MRTalone } { options~too~late }%>>=
  {
    \token_to_str:N \MRTaloneOptions \c_space_tl may ~ only ~ be ~ used ~ in ~
    the ~ file ~ '\c_MRTalone_options_file_name_tl'.
  }%=<<
\msg_new:nnn { MRTalone } { no~float }%>>=
  {
    Parsing~says~you~didn't~provide~a~valid~float.~Please~provide~a
    valid~float.\\
    If~you're~sure~that~you~entered~a~valid~float,~please~report~the~bug
    to~the\\
    package~maintainer.\\
    Error~occured~while~parsing~#1.%
  }%=<<
%%===========================================================================<<

\NewDocumentCommand \MRTaloneSetup { +m }%>>=
  {
    \keys_set:nn { MRTalone/setup } { #1 }
  }%=<<

%% Class options and loading standalone >>=
%%=============================================================================
\input{MRTfonts.forward.keys.tex}
\MRTfonts_setup_forwarded_from:n { MRTalone }
\DeclareOption{longtable}{\PassOptionsToPackage{longtable}{MRTtab}}
\DeclareOption{mathsizes}{\bool_set_true:N \l_MRTalone_mathsizes_bool}
\DeclareOption{minimal}{\bool_set_true:N \l_MRTalone_minimal_bool}
\DeclareOption{no mathsizes}{\bool_set_false:N \l_MRTalone_mathsizes_bool}
\DeclareOption{tikzunderline}{\PassOptionsToPackage{tUline}{MRTwuline}}
\DeclareOption{tUline}{\ExecuteOptions{tikzunderline}}
\DeclareOption{british}{\bool_set_true:N \l_MRTalone_british_bool}
\DeclareOption{UKenglish}{\ExecuteOptions{british}}
\DeclareOption{english}{\ExecuteOptions{british}}
\DeclareOption{tikz}
  {\PassOptionsToPackage{table}{xcolor}\PassOptionsToClass{tikz}{standalone}}
\keys_define:nn { MRTalone / loadtime }%>>=
  {
     languages .tl_set:N = \l_MRTalone_add_languages_tl
    ,langs   .meta:n = { languages = { #1 } }
    ,unknown .code:n =
      { \exp_args:No \PassOptionsToClass \CurrentOption { standalone } }
  }%=<<
\DeclareOption* { \keys_set:nV { MRTalone / loadtime } \CurrentOption }
\PassOptionsToClass{11pt}{standalone}
\file_if_exist:nT { \c_MRTalone_options_file_name_tl }
  {
    \cs_new:Npn \MRTaloneOptions #1
      {
        \ExecuteOptions { #1 }
      }
    \ExplSyntaxOff
    \file_input:n { \c_MRTalone_options_file_name_tl }
    \ExplSyntaxOn
  }
\cs_set:Npn \MRTaloneOptions #1
  {
    \msg_error:nn { MRTalone } { options~too~late }
  }
\ProcessOptions\relax
\bool_if:NTF \l_MRTalone_british_bool
  {}
  { \tl_put_left:Nn \@classoptionslist { ngerman, } }
\LoadClass{standalone}
%%===========================================================================<<

%% additional packages to achieve template formatting >>=
%%=============================================================================
\RequirePackage{MRTtab}
\bool_if:NTF \l_MRTalone_british_bool
  {% true >>=
    \exp_last_unbraced:NNV
    \RequirePackage[\l_MRTalone_add_languages_tl,ngerman,main=british]{babel}
  }% =<<
  {% false >>=
    \exp_last_unbraced:NNV
    \RequirePackage[\l_MRTalone_add_languages_tl,british,main=ngerman]{babel}
    \RequirePackage[british,main=ngerman]{babel}
  }% =<<
\RequirePackage{setspace}
\RequirePackage{enumitem}
\RequirePackage[fleqn]{mathtools}
\RequirePackage{MRTfonts,MRTwuline}
\bool_if:NF \l_MRTalone_minimal_bool%>>=
  {
    \cs_new:Npn \MRTalone_range_phrase:n #1
      {
        \mode_if_math:TF { \text { ~#1~ } } { ~#1~ }
      }
    \RequirePackage{siunitx}
    \DeclareSIUnit\ohm{\text{$\upOmega$}}
    \sisetup{% set options of the siunitx package
        ,detect-all%
        ,per-mode=reciprocal-positive-first%
    }%
    \addto\extrasngerman
      { \sisetup{ locale=DE, range-phrase=\MRTalone_range_phrase:n { bis } } }
    \addto\extrasbritish
      { \sisetup{ locale=UK, range-phrase=\MRTalone_range_phrase:n { to } } }
  }%=<<
%%===========================================================================<<

%% setup options >>=
%%=============================================================================
\keys_define:nn { MRTalone/setup }% >>=
  {
    ,caption~above   .code:n     = { \MRTtabSetup { caption~above } }
    ,caption~above   .value_forbidden:n = true
    ,caption~below   .code:n     = { \MRTtabSetup { caption~below } }
    ,caption~below   .value_forbidden:n = true
    ,stretch~caption .code:n     = {}
      %{% >>=
        %\setkomafont { caption }      { \setstretch { #1 } \normalfont }
        %\setkomafont { captionlabel } { \setstretch { #1 } \normalfont }
      %}% =<<
    ,stretch~cap     .meta:n     = { stretch~caption={#1} }
    ,stretch~tabular .code:n     = { \MRTtabSetup { stretch~tab={#1} } }
    ,stretch~tab     .meta:n     = { stretch~tabular={#1} }
    ,stretch~text    .code:n     = { \setstretch { #1 } }
    ,stretches       .meta:n     =
      { stretch~cap={#1}, stretch~tab={#1}, stretch~text={#1} }
    ,table~spacing   .bool_set:N = \l_MRTalone_table_spacing_bool
    ,table~spacing   .default:n  = { true }
    ,tab~spacing     .meta:n     = { table~spacing={#1} }
    ,tab~spacing     .default:n  = { true }
  }% =<<
% defaults >>=
\keys_set:nn { MRTalone/setup }% >>=
  {
    ,caption~below
    ,stretches = 1.408
    ,tab~spacing
  }% =<<
% =<<
%%===========================================================================<<

%% lengths >>=
%%=============================================================================
\setlength{\arrayrulewidth}{0.6pt}
\setlength{\parindent}{13pt} % default 15pt
\setlength{\parskip}{6pt plus .3pt minus .15pt}
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
% we need to fix an issue that setspace introduces, making the display skips
% unstretchable. Code from https://tex.stackexchange.com/a/523552/117050
\MRTutil@def\MRTalone@addstretchshrink#1%
  {%
    \if\relax\displayskipstretch\relax
      % there is no factor, don't add plus and minus
    \else
      plus \displayskipstretch\gluestretch#1
      minus \displayskipstretch\glueshrink#1
    \fi
  }
\AtBeginDocument
  {%
    \begingroup
    \def\fix#1\abovedisplayskip#2\displayskipstretch\belowdisplayshortskip#3\fix
      {%
        \endgroup
        \everydisplay
          {%
            #1#3%
            \abovedisplayskip=%
              \displayskipstretch       \abovedisplayskip
              \MRTalone@addstretchshrink\abovedisplayskip
            \belowdisplayskip=%
              \displayskipstretch       \belowdisplayskip
              \MRTalone@addstretchshrink\belowdisplayskip
            \abovedisplayshortskip=%
              \displayskipstretch       \abovedisplayshortskip
              \MRTalone@addstretchshrink\abovedisplayshortskip
            \belowdisplayshortskip=%
              \displayskipstretch       \belowdisplayshortskip
              \MRTalone@addstretchshrink\belowdisplayshortskip
          }%
      }%
    \expandafter\fix\the\everydisplay\fix
  }
%%===========================================================================<<

%% set page dimensions >>=
%% equal to the ones in MRTthesis 
%%=============================================================================
%% Using geometry doesn't lead to the exact same dimensions, so we do it by hand
%% Only set paper and text block dimensions, rest shouldn't be necessary
\paperheight=845.04694pt
\paperwidth=597.50793pt
\textwidth=455.24417pt
\textheight=682.285pt
%%===========================================================================<<

%% Setting up MRTtab to work in standalone by default >>=
%%=============================================================================
\MRTtabSetup{in~text~sep=\c_zero_skip,no~float}
%%===========================================================================<<

%% look for a setup file >>=
%%=============================================================================
\file_if_exist:nT { \c_MRTalone_setup_file_name_tl }
  {
    \ExplSyntaxOff
    \file_input:n { \c_MRTalone_setup_file_name_tl }
    \ExplSyntaxOn
  }
%%===========================================================================<<

% vim: ft=tex fdm=marker fmr=>>=,=<< sw=2 ts=2 tw=80
