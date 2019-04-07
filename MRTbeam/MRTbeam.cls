\newcommand*\MRTbeam@version{0.0.6}
\newcommand*\MRTbeam@date{2019-02-28}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse}

%% options and class loading >>=
%%=============================================================================
\newif\if@MRTbeam@sfacc@height@
\ExplSyntaxOn
\input{MRTfonts.forward.keys.tex}
\MRTfonts_setup_forwarded_from:n { MRTbeam }
\keys_define:nn { MRTbeam / loadtime }%>>=
  {
    unknown .code:n = { \PassOptionsToClass { \CurrentOption } { beamer } }
  }%=<<
\DeclareOption* { \keys_set:nV { MRTbeam / loadtime } \CurrentOption }
\ProcessOptions\relax
\ExplSyntaxOff
\LoadClass{beamer}
\usefonttheme{professionalfonts} % so that MRTfonts can do its stuff
%%===========================================================================<<

\ProvidesExplClass
  {MRTbeam}          {\MRTbeam@date}
  {\MRTbeam@version} {beamer template for MRT - University of Bayreuth}

\prop_gput:Nnn \g_msg_module_type_prop { MRTbeam } { Class }

\RequirePackage{MRTfonts}

\usetheme{MRTbeam}

\NewDocumentCommand \ProgressBarStyle { s m }% >>=
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
  }% =<<

\ExplSyntaxOff

\endinput

% vim: ft=tex fdm=marker fmr=>>=,=<< sw=2 ts=2 tw=80
