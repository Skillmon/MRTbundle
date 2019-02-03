\newcommand*\MRTalone@version{0.0.4}
\newcommand*\MRTalone@date{2018-02-03}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse}
\ProvidesExplClass
  {MRTalone}          {\MRTalone@date}
  {\MRTalone@version} {standalone matching MRTthesis}

%% variants of external macros >>>
%%=============================================================================
\cs_generate_variant:Nn \keys_set:nn { nV }
%%==========================================================================<<<

%% variables >>>
%%=============================================================================
% l3 variables >>>
% bool >>>
\bool_new:N \l_MRTalone_minimal_bool
\bool_new:N \l_MRTalone_mathsizes_bool
\bool_new:N \l_MRTalone_british_bool
\bool_new:N \l_MRTalone_sfacc_height_bool
% <<<
% <<<
%%==========================================================================<<<

%% constants >>>
%%=============================================================================
\bool_const:Nn \c_MRTalone_xetex_or_luatex_bool
  { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }
%%==========================================================================<<<

%% messages >>>
%%=============================================================================
\msg_new:nnn { MRTalone } { wrong~engine }%>>>
  {
    The ~ used ~ #1 ~ is ~ not ~ available ~ under ~ \c_sys_engine_str. ~ You ~
    have ~ to ~ use ~ #2.
  }%<<<
%%==========================================================================<<<

\NewDocumentCommand \MRTaloneSetup { +m }%>>>
  {
    \keys_set:nn { MRTalone/setup } { #1 }
  }%<<<

%% Class options and loading standalone >>>
%%=============================================================================
\DeclareOption{longtable}{\PassOptionsToPackage{longtable}{MRTtab}}
\DeclareOption{mathsizes}{\bool_set_true:N \l_MRTalone_mathsizes_bool}
\DeclareOption{minimal}{\bool_set_true:N \l_MRTalone_minimal_bool}
\DeclareOption{no mathsizes}{\bool_set_false:N \l_MRTalone_mathsizes_bool}
\DeclareOption{tikzunderline}{\PassOptionsToPackage{tUline}{MRTwuline}}
\DeclareOption{tUline}{\ExecuteOptions{tikzunderline}}
\DeclareOption{british}{\bool_set_true:N \l_MRTalone_british_bool}
\DeclareOption{UKenglish}{\ExecuteOptions{british}}
\DeclareOption{english}{\ExecuteOptions{british}}
%% Additional KV-options >>>
\keys_define:nn { MRTalone / loadtime }%>>>
  {
    sfacc .choice:
    ,sfacc / height .code:n = { \bool_set_true:N \l_MRTalone_sfacc_height_bool}
    ,sfacc / list .code:n = { \bool_set_false:N \l_MRTalone_sfacc_height_bool }
    ,unknown .code:n = { \PassOptionsToClass { \CurrentOption } { standalone } }
  }%<<<
\bool_if:NTF \c_MRTalone_xetex_or_luatex_bool
  {%>>>
    \keys_define:nn { MRTalone / loadtime }
      {
         font       .tl_set:N = \l_MRTalone_font_tl
        ,serif~font .tl_set:N = \l_MRTalone_serif_font_tl
        ,mono~font  .tl_set:N = \l_MRTalone_mono_font_tl
      }
  }%<<<
  {%>>>
    \clist_map_inline:nn { font, serif~font, mono~font }
      {
        \keys_define:nn { MRTalone / loadtime }
          {
            #1 .code:n =
              {
                \msg_error:nnnn { MRTalone } { wrong~engine } { key ~ `#1` }
                  { xetex ~ or ~ luatex }
              }
          }
      }
  }%<<<
%% <<<
\DeclareOption* { \keys_set:nV { MRTalone / loadtime } \CurrentOption }
\ExecuteOptions{mathsizes}
\PassOptionsToClass{11pt}{standalone}
\ProcessOptions\relax
\LoadClass{standalone}
%%==========================================================================<<<

%% additional packages to achieve template formatting >>>
%%=============================================================================
\RequirePackage{MRTtab,MRTwuline}
\bool_if:NTF \c_MRTalone_xetex_or_luatex_bool
  {% true >>>
    \RequirePackage[no-math]{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
    \tl_if_empty:NTF \l_MRTalone_font_tl
      {
        \msg_new:nnn { MRTalone } { no~font }
          {
            You ~ did ~ not ~ specify ~ any ~ sans ~ font ~ using ~ the ~
            `font` ~ key. ~ I'll ~ use ~ the ~ default ~ font ~ but ~ you ~
            should ~ use ~ a ~ system ~ font ~ looking ~ like ~ Arial ~ or ~
            Helvetica.
          }
        \msg_warning:nn { MRTalone } { no~font }
      }
      { \exp_args:NV \setsansfont \l_MRTalone_font_tl }
    \tl_if_empty:NF \l_MRTalone_serif_font_tl
      { \exp_args:NV \setmainfont \l_MRTalone_serif_font_tl }
    \tl_if_empty:NF \l_MRTalone_mono_font_tl
      { \exp_args:NV \setmonofont \l_MRTalone_mono_font_tl }
  }% <<<
  {% false >>>
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage{lmodern}
    \RequirePackage{helvet}
  }%<<<
\renewcommand\familydefault{\sfdefault}
\bool_if:NTF \l_MRTalone_british_bool
  {% true >>>
    \RequirePackage[main=british,ngerman]{babel}
  }% <<<
  {% false >>>
    \RequirePackage[ngerman]{babel}
  }% <<<
\RequirePackage{setspace}
\RequirePackage{enumitem}
\RequirePackage[fleqn]{mathtools}
% bad math fonts 
\RequirePackage[italic,defaultmathsizes]{mathastext}
\RequirePackage{isomath}
\bool_if:NTF \l_MRTalone_sfacc_height_bool
  {
    \RequirePackage[height]{MRTsfacc}
  }
  {
    \RequirePackage[list]{MRTsfacc}
    \MRTsfaccLoadShiftList{helvet}
  }
\bool_if:NT \l_MRTalone_mathsizes_bool%>>>
  {
    \DeclareMathSizes{10.95pt}{10.95pt}{9pt}{7pt}
  }%<<<
\bool_if:NF \l_MRTalone_minimal_bool%>>>
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
    ,table~spacing   .bool_set:N = \l_MRTalone_table_spacing_bool
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

%% set page dimensions >>>
%% equal to the ones in MRTthesis 
%%=============================================================================
\RequirePackage
  [
    ,paperheight=845.04694pt
    ,paperwidth=597.50793pt
    ,left=25mm
    ,right=25mm
    ,top=8.4mm
    ,bottom=10.7mm
    ,includeheadfoot
    ,headsep=15.4mm
    ,marginparwidth=18mm
    ,marginparsep=4mm
  ]
  {geometry}
\textwidth=455.24417pt
\textheight=682.285pt
%%==========================================================================<<<

% Setting up MRTtab to work in standalone by default
\MRTtabSetup{in~text~sep=\c_zero_skip,no~float}
