\newcommand*\MRTbeam@version{0.0.5}
\newcommand*\MRTbeam@date{2019-02-05}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif}

%% options and class loading >>>
%%=============================================================================
\newif\if@MRTbeam@sfacc@height@
\ExplSyntaxOn
\bool_const:Nn \c_MRTbeam_xetex_or_luatex_bool%>>>
  { \sys_if_engine_luatex_p: || \sys_if_engine_xetex_p: }%<<<
\bool_new:N \l_MRTbeam_lmscale_bool
\bool_new:N \l_MRTbeam_new_math_bool
\fp_new:N \l_MRTbeam_new_math_scale_fp
\msg_new:nnn { MRTbeam } { wrong~engine }%>>>
  {
    The ~ used ~ #1 ~ is ~ not ~ available ~ under ~ \c_sys_engine_str. ~ You ~
    have ~ to ~ use ~ #2.
  }%<<<
\msg_new:nnn { MRTbeam } { no~float }%>>>
  {
    Parsing~says~you~didn't~provide~a~valid~float.~Please~provide~a
    valid~float.\\
    If~you're~sure~that~you~entered~a~valid~float,~please~report~the~bug
    to~the\\
    package~maintainer.\\
    Error~occured~while~parsing~#1.%
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
    \clist_map_inline:nn { scale maths, new maths }
      {
        \keys_define:nn { MRTbeam / loadtime }
          {
            #1 .code:n =
              {
                \msg_error:nnnn { MRTbeam } { wrong~engine } { key ~ `#1` }
                  { pdftex }
              }
          }
      }
    \keys_define:nn { MRTbeam / loadtime }
      {
         font        .tl_set:N = \l_MRTbeam_font_tl
        ,font        .initial:n = { texgyreheros-regular.otf }
        ,serif font  .tl_set:N = \l_MRTbeam_serif_font_tl
        ,serif font  .initial:n = { lmroman10-regular.otf }
        ,mono font   .tl_set:N = \l_MRTbeam_mono_font_tl
        ,mono font   .initial:n = { lmmono10-regular.otf }
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
    \keys_define:nn { MRTbeam / loadtime }
      {
        scale maths .code:n =%>>>
          {
            \tl_if_empty:nTF { #1 }
              {
                \bool_set_true:N \l_MRTbeam_lmscale_bool
              }
              {
                \str_case:nnF { #1 }
                  {
                    { off   } { \bool_set_false:N \l_MRTbeam_lmscale_bool }
                    { false } { \bool_set_false:N \l_MRTbeam_lmscale_bool }
                    { on    } { \bool_set_true:N  \l_MRTbeam_lmscale_bool }
                    { true  } { \bool_set_true:N  \l_MRTbeam_lmscale_bool }
                  }
                  {
                    \bool_set_true:N \l_MRTbeam_lmscale_bool
                    \PassOptionsToPackage { #1 } { MRTlmscale }
                  }
              }
          }%<<<
        ,scale maths .initial:n = {}
        ,new maths .code:n = %>>>
          {
            \tl_if_empty:nTF { #1 }
              { \bool_set_true:N \l_MRTbeam_new_math_bool }
              {
                \str_case:nnF { #1 }
                  {
                    { off   } { \bool_set_false:N \l_MRTbeam_new_math_bool }
                    { false } { \bool_set_false:N \l_MRTbeam_new_math_bool }
                    { on    } { \bool_set_true:N  \l_MRTbeam_new_math_bool }
                    { true  } { \bool_set_true:N  \l_MRTbeam_new_math_bool }
                  }
                  {
                    \bool_set_true:N \l_MRTbeam_new_math_bool
                    \MRTifFloatTF { #1 }
                      {
                        \fp_set:Nn \l_MRTbeam_new_math_scale_fp { #1 }
                      }
                      {
                        \msg_error:nnn { MRTbeam } { no~float }
                          {
                            the~value~\exp_not:n { #1 }~you~provided~to~
                            `new~math`.
                          }
                      }
                  }
              }
          }%<<<
        ,new maths .initial:n = { 1.05 }
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

\prop_gput:Nnn \g_msg_module_type_prop { MRTbeam } { Class }

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
    \bool_if:NT \l_MRTbeam_lmscale_bool { \RequirePackage { MRTlmscale } }
    \RequirePackage{helvet}
  }%<<<
\bool_if:NT \l_MRTbeam_new_math_bool
  {
    \RequirePackage[upint,slantedGreek]{newpxmath}
    \DeclareSymbolFont{letters}{OML}{ztmcm}{m}{it}
    \DeclareFontFamily{OML}{ztmcm}{\skewchar \font =127}
    \DeclareFontShape{OML}{ztmcm}{m}{it}
      { <-> s*[\fp_use:N \l_MRTbeam_new_math_scale_fp ] zptmcm7m }{}
    \DeclareFontShape{OML}{ztmcm}{m}{sl}{<->ssub * ztmcm/m/it}{}
  }
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
