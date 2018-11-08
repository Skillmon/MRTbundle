\newcommand*\MRTbeam@version{0.0.3}
\newcommand*\MRTbeam@date{2018-11-08}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse}

%% options and class loading >>>
%%=============================================================================
\newif\if@MRTbeam@sfacc@height@
\ExplSyntaxOn
\bool_const:Nn \c_MRTbeam_xetex_or_luatex_bool%>>>
  { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }%<<<
\msg_new:nnn { MRTbeam } { wrong~engine }%>>>
  {
    The ~ used ~ #1 ~ is ~ not ~ available ~ under ~ \c_sys_engine_str. ~ You ~
    have ~ to ~ use ~ #2.
  }%<<<
%% Additional KV-options >>>
\keys_define:nn { MRTbeam / loadtime }%>>>
  {
    sfacc .choice:
    ,sfacc / height .code:n = { \@MRTbeam@sfacc@height@true }
    ,sfacc / list   .code:n = { \@MRTbeam@sfacc@height@false }
    ,unknown .code:n = { \PassOptionsToClass { \CurrentOption } { beamer } }
  }%<<<
\bool_if:NTF \c_MRTbeam_xetex_or_luatex_bool
  {%>>>
    \keys_define:nn { MRTbeam / loadtime }
      {
         font       .tl_set:N = \l_MRTbeam_font_tl
        ,serif~font .tl_set:N = \l_MRTbeam_serif_font_tl
        ,mono~font  .tl_set:N = \l_MRTbeam_mono_font_tl
      }
  }%<<<
  {%>>>
    \clist_map_inline:nn { font, serif~font, mono~font }
      {
        \keys_define:nn { MRTbeam / loadtime }
          {
            #1 .code:n =
              {
                \msg_error:nnnn { MRTbeam } { wrong~engine } { key ~ `#1` }
                  { xetex ~ or ~ luatex }
              }
          }
      }
  }%<<<
%% <<<
\DeclareOption* { \keys_set:nV { MRTbeam / loadtime } \CurrentOption }
\ProcessOptions\relax
\ExplSyntaxOff
\LoadClass{beamer}
%%==========================================================================<<<

\ProvidesExplClass
  {MRTbeam}          {\MRTbeam@date}
  {\MRTbeam@version} {beamer template for MRT - University of Bayreuth}

%% font loading >>>
%%=============================================================================
\ExplSyntaxOn
\bool_if:NTF \c_MRTbeam_xetex_or_luatex_bool
  {% true >>>
    \RequirePackage[no-math]{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
    \tl_if_empty:NTF \l_MRTbeam_font_tl
      {
        \msg_new:nnn { MRTbeam } { no~font }
          {
            You ~ did ~ not ~ specify ~ any ~ sans ~ font ~ using ~ the ~
            `font` ~ key. ~ I'll ~ use ~ the ~ default ~ font ~ but ~ you ~
            should ~ use ~ a ~ system ~ font ~ looking ~ like ~ Arial ~ or ~
            Helvetica.
          }
        \msg_warning:nn { MRTbeam } { no~font }
      }
      { \exp_args:NV \setsansfont \l_MRTbeam_font_tl }
    \tl_if_empty:NF \l_MRTbeam_serif_font_tl
      { \exp_args:NV \setmainfont \l_MRTbeam_serif_font_tl }
    \tl_if_empty:NF \l_MRTbeam_mono_font_tl
      { \exp_args:NV \setmonofont \l_MRTbeam_mono_font_tl }
  }% <<<
  {% false >>>
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage{lmodern}
    \RequirePackage{helvet}
  }%<<<
\if@MRTbeam@sfacc@height@
  \RequirePackage[height]{MRTsfacc}
\else
  \RequirePackage[list]{MRTsfacc}
  \MRTsfaccLoadShiftList{helvet}
\fi
\ExplSyntaxOff
%%==========================================================================<<<

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
        \ClassError{MRTbeam}{The~style~'\exp_not:n { #1 }'~is~unknown.}{}
      }
  }% <<<

\ExplSyntaxOff

\endinput
% vim: ft=tex fdm=marker foldmarker=>>>,<<<
