\newcommand*\MRTbeam@version{0.0.13}
\newcommand*\MRTbeam@date{2021-06-04}

\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3,xparse,MRTif}

%% options and class loading >>=
%%=============================================================================
\newif\if@MRTbeam@sfacc@height@
\newif\if@MRTbeam@aspect@
\ExplSyntaxOn
\input{MRTfonts.forward.keys.tex}
\msg_new:nnn { MRTbeam } { bad~aspect~component }%>>=
  {
    The ~ specified ~ aspect ~ component ~ '#1' ~ is ~ no ~
    unsigned ~ integer. ~ Ignoring ~ option.
  }%=<<
\cs_new_protected:Npn \MRTbeam_handle_aspect:n #1%>>=
  {
    \MRTbeam_handle_aspect_aux:x { \tl_to_str:n { #1 } }
  }%=<<
\cs_new_protected:Npn \MRTbeam_handle_aspect_aux:n #1%>>=
  {
    \str_if_in:nnTF { #1 } { : }
      {
        \MRTbeam_handle_aspect:w #1 \q_stop
      }
      {
        \msg_new:nnn { MRTbeam } { bad~aspect }
          {
            The ~ specified ~ aspect ~ '#1' ~ doesn't ~ contain ~
            a ~ colon. ~ Ignoring ~ option.
          }
        \msg_error:nn { MRTbeam } { bad~aspect }
        \@MRTbeam@aspect@false
      }
  }%=<<
\cs_generate_variant:Nn \MRTbeam_handle_aspect_aux:n { x }
\use:x 
  {
    \cs_set_protected:Npn
    \exp_not:N \MRTbeam_handle_aspect:w ##1 \c_colon_str ##2 \exp_not:N \q_stop
  }
  {
    \MRTifNumberNoSignTF { #1 }
      {
        \cs_set:Npn \MRTbeam@aspect@x { #1 }
        \MRTifNumberNoSignTF { #2 }
          { \cs_set:Npn \MRTbeam@aspect@y { #2 } }
          {
            \msg_error:nnn { MRTbeam } { bad~aspect~component } { #2 }
            \@MRTbeam@aspect@false
          }
      }
      {
        \msg_error:nnn { MRTbeam } { bad~aspect~component } { #1 }
        \@MRTbeam@aspect@false
      }
  }%=<<
\MRTfonts_setup_forwarded_from:n { MRTbeam }
\keys_define:nn { MRTbeam / loadtime }%>>=
  {
    ,aspect  .code:n = { \@MRTbeam@aspect@true \MRTbeam_handle_aspect:n { #1 } }
    ,unknown .code:n =
      { \exp_args:No \PassOptionsToClass \CurrentOption { beamer } }
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

\@ifpackagelater{expl3}{2018/10/10}
  { \prop_gput:Nnn \g_msg_module_type_prop { MRTbeam } { Class } } {}

\RequirePackage{MRTfonts,MRTutil}

\usetheme{MRTbeam}

\NewDocumentCommand \ProgressBarStyle { s m }% >>=
  {
    \IfBooleanT { #1 } { \ProgressBartrue }
    \str_case:nnF { #2 }
      {
        { default } { \SetProgressBar{c}{30pt}{\f@size pt}{-1.65ex} }
        { Spratte } { \SetProgressBar{c}{\paperwidth}{2pt}{3pt} }
        { spratte } { \SetProgressBar{c}{\paperwidth}{2pt}{3pt} }
      }
      {
        \ClassError{MRTbeam}{The~style~'\exp_not:n { #2 }'~is~unknown.}{}
      }
  }% =<<
\cs_new:Npn \MRTbeam_progress_bar_colors:nn #1 #2% >>=
  {
    \IfValueTF { #2 } { \definecolor { #1 } { #2 } } { \colorlet { #1 } }
  }% =<<
\NewDocumentCommand \ProgressBarColors { o m o m }% >>=
  {
    \MRTbeam_progress_bar_colors:nn { progressed } { #1 } { #2 }
    \MRTbeam_progress_bar_colors:nn { noprogress } { #3 } { #4 }
  }% =<<

\RenewDocumentCommand \maketitle
  { >{\MRTbeam@forwardOarg}O{\MRTutil@@mark} G{\MRTutil@@mark} G{\relax} }
  {
    \ifbeamer@inframe
      \titlepage
    \else
      \group_begin:
      \MRTutil@ifmark{#2}{\OnlyOneTopRuletrue}{}
      \begin{frame}#1{\MRTutil@ifmark{#2}{\relax}{#2}}{#3}
        \titlepage
      \end{frame}
      \group_end:
    \fi
  }
\protected\long\def\MRTbeam@forwardOarg#1
  {
    \MRTutil@ifmark{#1}
      {\def\ProcessedArgument{}}
      {\def\ProcessedArgument{[{#1}]}}
  }
\ExplSyntaxOff

\endinput

% vim: ft=tex fdm=marker fmr=>>=,=<< sw=2 ts=2 tw=80
