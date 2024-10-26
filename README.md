### About ###

This LaTeX bundle contains three classes, one for theses and the like, one for
presentations, and one for small LaTeX graphics to include in the thesis
template. The two former classes aim to recreate the corresponding MS Office
templates in use at the Chair of Measurement and Control Engineering (Lehrstuhl
für Mess- und Regeltechnik; MRT) of the University of Bayreuth. Along those
classes there are several other small packages contained, which provide shared
macros used by both of the classes, or might be interesting on their own.

Furthermore there are small example projects included, which show a basic usage
example of the classes. There is also a hopefully comprehensive documentation of
every package contained in the bundle included. The experiences I gathered with
the last template is, that no one reads readmes. As a result I provide the
documentation in the form of a PDF in the hopes that more people will read this,
though I'll miss the enjoyment of creating the finest ASCII-art.

For a more exhaustive example of an exotic use of MRTthesis you can take a look
at the sources of the documentation.

### Installation ###

There are several possibilities of installation. The easiest but unfortunately
least favourable possibility would be to place every file needed in the top
level of your project. Whilst working for a single project this results in an
unclean folder structure of your project *and* has to be redone for any future
project.

The perhaps best way would be local user wide install. This is done by placing
the bundle's folders `MRTalone`, `MRTbeam`, `MRTcirc`, `MRTfonts`, `MRTif`,
`MRTlmscale`, `MRTresources`, `MRTsfacc`, `MRTtab`, `MRTthesis`, `MRTutil`, and
`MRTwuline` in your local TeX-tree. For TeX Live on Unix this would by default
be `/home/<user>/texmf/` therein the packages should belong in
`tex/latex/MRTbundle`. For other OSes and TeX distributions the paths may vary.
You can get the correct path to your user specific folder by running `kpsewhich
-var TEXMFHOME` in your terminal (at least if you're running TeX Live).

The third option would be a system wide installation. For this you need admin
rights. Place the files in the system wide TeX-tree (again in Unix with TeX Live
located in `/usr/local/texlive/texmf-local/`) therein put all folders belonging
to an included package or class in `tex/latex/MRTbundle`.  The correct folder
can be determined by running `kpsewhich -var TEXMFLOCAL`. After you placed the
files in the system folders you'd have to update your directory indices by
running `mktexlsr` as root. The correct installation can be checked by running
`kpsewhich MRTthesis.cls` or for any other provided package or class.

Installing the documentation in the respective `doc` folder can be done but
there is no benefit to it, so why bother.

### Licensing ###

Copyright (C) 2018-2021, 2024 Jonathan P. Spratte

These files are distributed in the hope that they will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.

You might redistribute it to fellow students working at the MRT, provided that
you clearly mark any changes you made to the copy originally distributed to you.
The responsibility for the formatting of ones own thesis or presentation remains
at the individual student.

I (the author of this work) don't take any responsibility for mismatching
formatting compared to the latest template for MS Word. I don't assure that the
provided files match the latest official template of the chair. The LaTeX
template is not considered official in any means, I'll maintain it at least as
long as I'm a student at the University of Bayreuth on a voluntary basis. I'm
not willing to teach everybody how to use LaTeX, but you might ask questions if
you encounter any issues *related to this bundle*. If you ask something that is
stated in the documentation, you might get a RTFM as response, however.
