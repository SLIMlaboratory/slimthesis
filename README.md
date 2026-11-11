# slimthesis

A LaTeX template for bachelor's and master's theses supervised at the
[SLIM laboratory](https://slim.di.unimi.it) of the Università degli Studi di
Milano.

The whole layout is in a single file, `slimthesis.sty`: cover page,
typography (Libertinus for text, Figtree for headings, STIX Two for
mathematics), chapter headings, running headers, theorem environments,
bibliography and PDF/A output. The thesis itself (`main.tex` and the files it
includes) only contains the thesis data and the text, so that the style can
be updated without touching your work, and your work never needs to touch
the style.

This README is a complete guide to the template. The same content, with
every example typeset, is in the
[documentation PDF](https://github.com/SLIMlaboratory/slimthesis/releases/latest/download/slimthesis-documentation.pdf),
which is produced by compiling the template itself: its source is the
starting point for a new thesis.

[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf)](https://www.overleaf.com/docs?snip_uri=https://github.com/SLIMlaboratory/slimthesis/releases/latest/download/slimthesis-overleaf.zip&engine=lualatex)
[![Build](https://github.com/SLIMlaboratory/slimthesis/actions/workflows/build.yml/badge.svg)](https://github.com/SLIMlaboratory/slimthesis/actions/workflows/build.yml)

## Contents

- [Starting a new thesis](#starting-a-new-thesis)
- [Requirements](#requirements)
- [Compiling](#compiling)
- [Files](#files)
- [Setting up the thesis](#setting-up-the-thesis)
- [Structure of the document](#structure-of-the-document)
- [Writing the thesis](#writing-the-thesis)
- [Citations and links](#citations-and-links)
- [PDF/A](#pdfa)
- [Before submitting](#before-submitting)
- [Customising the style](#customising-the-style)
- [License](#license)

## Starting a new thesis

**On Overleaf.** Click the *Open in Overleaf* button above: a new project
is created in your Overleaf account with a copy of the latest version of the
template, set to compile with LuaLaTeX. Then follow
[Setting up the thesis](#setting-up-the-thesis). If the compiler is ever
changed, set it back to LuaLaTeX (or XeLaTeX) in the *Menu* of the project.

**On your computer.** Download the
[latest release](https://github.com/SLIMlaboratory/slimthesis/releases/latest)
(`slimthesis-overleaf.zip` contains just the template files), or clone the
repository:

```sh
git clone https://github.com/SLIMlaboratory/slimthesis.git my-thesis
```

then check the [requirements](#requirements) and [compile](#compiling).

## Requirements

The style relies on OpenType fonts, therefore the thesis must be compiled
with **LuaLaTeX** or **XeLaTeX**; pdfLaTeX is not supported. Besides a recent
TeX Live (or MiKTeX / MacTeX) distribution, you need:

- the **STIX Two Math** font, used for mathematics;
- the **Libertinus** fonts, used for text;
- the **Figtree** font, used for headings, which is shipped with the
  template in `fonts/Figtree/`;
- a few LaTeX packages that minimal installations may lack, such as
  `apptools`, `ocgx2` and `pdfx`;
- **biber**, which processes the bibliography.

On Fedora, the packages not included in a basic TeX Live installation are:

```sh
sudo dnf install texlive-libertinus-fonts stix-fonts \
                 texlive-apptools texlive-ocgx2 texlive-pdfx
```

Full TeX Live and MacTeX installations already contain everything; MiKTeX
installs missing packages automatically on first use.

## Compiling

A complete build runs LuaLaTeX, then biber, then LuaLaTeX twice more, so that
the bibliography, the table of contents and all cross-references are
resolved:

```sh
lualatex main && biber main && lualatex main && lualatex main
```

Alternatively, `latexmk` runs all the required steps automatically; the file
`latexmkrc` shipped with the template tells it to use LuaLaTeX and biber, so
that it is enough to type

```sh
latexmk main
```

and `latexmk -c` removes the auxiliary files. XeLaTeX can be used in the same
way, replacing `lualatex` with `xelatex` (in `latexmkrc`, set
`$pdf_mode = 5;`).

## Files

```
main.tex              main file: programme, thesis data, list of chapters
slimthesis.sty        the style (normally not modified)
latexmkrc             latexmk configuration
bibliography.bib      bibliographic references
chapters/             one file per chapter, plus the appendix
frontmatter/          dedication, epigraph, acknowledgements, list of symbols
style/symbols.tex     your own macros for the notation
style/colors.tex      colours for figures
images/               figures; logos for the cover and the last page
                      (images/coverPage/); Creative Commons buttons
                      (images/license/)
fonts/Figtree/        the heading font
```

`main.xmpdata` is generated at each compilation from the thesis data, to
store the metadata of the PDF/A file: do not edit it. `pdfa.xmpi` is also
written at each compilation, by the `pdfx` package; unlike the other
auxiliary files it is not removed by `latexmk -c`, but it can be deleted at
any time.

## Setting up the thesis

Setting up a new thesis only requires editing the preamble of `main.tex`:
choose the degree programme, then fill in the thesis data.

### Degree programme

The degree programme is the main option of the style:

```latex
\usepackage[programme=dse]{slimthesis}
```

It determines the cover (logo, faculty and course), the language of the
document and all the fixed labels:

| Value            | Degree     | Programme                             | Language |
|------------------|------------|---------------------------------------|----------|
| `inf` (default)  | Bachelor's | Informatica                           | Italian  |
| `inf-lm`         | Master's   | Informatica                           | Italian  |
| `cs`             | Master's   | Computer Science                      | English  |
| `dse`            | Master's   | Data Science for Economics            | English  |
| `dseh`           | Master's   | Data Science for Economics and Health | English  |

The language affects chapter labels ("Capitolo"/"Chapter"), the titles of
the table of contents and of the bibliography, the names of theorem-like
environments and the labels on the cover. If some passages are written in
another language, add it to babel *before* loading the style, and switch to
it where needed:

```latex
\PassOptionsToPackage{italian}{babel}
\usepackage[programme=dse]{slimthesis}
...
\foreignlanguage{italian}{Questa frase è in italiano.}
```

### Package options

The other options of the style are rarely needed:

| Option              | Effect                                                                  |
|---------------------|-------------------------------------------------------------------------|
| `madeinslim=false`  | omits the closing "Made in SLIM" page                                   |
| `pdfa=false`        | ordinary PDF instead of PDF/A-2b; links are then blue on screen and black in print (see [Links](#links)) |
| `mathfont=<name>`   | OpenType math font (default `STIX Two Math`)                            |
| `fontdir=<dir>`     | directory of the Figtree fonts (default `fonts/Figtree/`)               |
| `logodir=<dir>`     | directory of the cover logos (default `images/coverPage/`)              |
| `licensedir=<dir>`  | directory of the Creative Commons buttons (default `images/license/`)   |

Any installed math font can be used, for instance `Libertinus Math`,
`Latin Modern Math` or `TeX Gyre Pagella Math`; it is automatically scaled
to match the size of the text font. Options are separated by commas; a font
name containing spaces needs no quotes:

```latex
\usepackage[programme=cs, mathfont=Libertinus Math]{slimthesis}
```

### Thesis data and cover

The cover is produced by `\maketitle`, using the data given in the preamble:

```latex
\title{Learning Curves of Ensemble Classifiers}
\author{Ada Lovelace}
\academicyear{2025/26}
\studentid{123456}
\keywords{ensemble methods, random forests, learning curves}
\supervisor{Prof.~Super Visor}
\cosupervisor{Prof.~Cosu Pervisor}
\cosupervisor{Dr.~Other Supervisor}
```

- `\academicyear` only takes the years: "Anno Accademico" or "Academic Year"
  is added according to the language.
- `\studentid` is optional; when present, the student ID is printed below
  the author's name.
- `\keywords` is optional too: the keywords are not printed, but stored in
  the metadata of the PDF file, together with title, author and degree
  course, so that search engines and repositories can index the thesis.
- `\cosupervisor` can be repeated, or omitted: the label is singular or
  plural depending on the number of co-supervisors, and disappears if there
  are none.
- Write `Prof.~` and `Dr.~` with a tie, so that no sentence-ending space is
  added after the abbreviation and title and name stay on the same line.

For the Informatica programmes the cover shows the official logo, which
already contains faculty and course. For the other programmes the faculty
and course are typeset under the university seal; interfaculty programmes
(DSE and DSEH) list both faculties, at the same size. These lines can be
changed with

```latex
\faculty{Facoltà di Scienze e Tecnologie}
\course{Master's Degree in Data Science\\for Economics and Health}
```

The first `\faculty` replaces the default faculties, further calls add
lines. A course name that is too long is wrapped automatically; use `\\` to
choose where it breaks.

### License

A thesis can be released under a license, which tells readers what they are
allowed to do with it. The license is printed at the bottom of the page
following the cover. For Creative Commons licenses, give their type:

```latex
\license{by-sa}
```

| Type        | License                                  |
|-------------|------------------------------------------|
| `by`        | Attribution                              |
| `by-sa`     | Attribution-ShareAlike                   |
| `by-nd`     | Attribution-NoDerivatives                |
| `by-nc`     | Attribution-NonCommercial                |
| `by-nc-sa`  | Attribution-NonCommercial-ShareAlike     |
| `by-nc-nd`  | Attribution-NonCommercial-NoDerivatives  |
| `zero`      | CC0 (public domain dedication)           |

An optional argument selects a version other than 4.0, as in
`\license[3.0]{by}`. The page shows the official button of the license, a
copyright line with the current year and the author's name (except for CC0,
which waives copyright), and the name and address of the license, in the
language of the document. Any other license or notice can be given as free
text:

```latex
\customlicense{\textcopyright\ 2026 Ada Lovelace. All rights reserved.}
```

Without `\license` or `\customlicense`, the page is omitted.

## Structure of the document

The body of `main.tex` follows the usual structure of a book:

```latex
\begin{document}
\frontmatter
\maketitle
\input{frontmatter/dedication}
\input{frontmatter/epigraph}
\input{frontmatter/acknowledgements}
\tableofcontents
\listoffigures
\listoftables
\listofalgorithms
\input{frontmatter/symbols}

\mainmatter
\include{chapters/introduction}
\include{chapters/c1}
...
\include{chapters/conclusions}

\appendix
\include{chapters/appendix}

\printthesisbibliography
\end{document}
```

Pages in the front matter are numbered with roman numerals and have no
running header; `\mainmatter` restarts the numbering from 1 and switches on
headers and one-and-a-half line spacing; `\appendix` starts the appendices.

The lists of figures, tables and algorithms collect their captions with the
page numbers, and are themselves listed in the table of contents. They are
optional: remove the corresponding line if the thesis has few figures,
tables or algorithms. A caption that is too long for these lists can be
given a shorter version as optional argument, which is used in the lists in
place of the full caption:

```latex
\caption[Learning curves]{Learning curves: F1 score on the test set ...}
```

### Front matter

The dedication and the epigraph have their own commands, which typeset them
on a separate page:

```latex
\dedication{To my family.}
\epigraphpage{The best way to predict the future\\
              is to invent it.}{--- Alan Kay}
```

Both are optional: remove the corresponding `\input` line in `main.tex` if
you do not want them. The acknowledgements are an unnumbered chapter (see
[below](#unnumbered-chapters-and-sections)).

### List of symbols

A thesis with much notation benefits from a list of symbols, placed after
the other lists. It is written by hand in `frontmatter/symbols.tex`, with
one `\item` per symbol inside the `listofsymbols` environment, which starts
an unnumbered chapter titled "List of Symbols" ("Elenco dei simboli" in
Italian) and aligns the meanings in a column:

```latex
\begin{listofsymbols}
  \item[$\R$]                 the set of real numbers
  \item[$\bx_i$]              the $i$-th point of a dataset
  \item[$\lVert \bx \rVert$]  Euclidean norm of $\bx$
\end{listofsymbols}
```

Symbols are listed in the order in which they are written, so that related
notation can be kept together. The column of symbols is 2.5 cm wide; a
different width can be given as optional argument, as in
`\begin{listofsymbols}[4cm]`. If the list is not needed, remove from
`main.tex` the line that inputs `frontmatter/symbols.tex`.

### Unnumbered chapters and sections

The starred commands `\chapter*`, `\section*` and `\subsection*` produce
headings without number. Unlike standard LaTeX, they are nevertheless
listed in the table of contents, and `\chapter*` also sets the running
header. Unnumbered chapters are the right choice for the introduction, the
acknowledgements and the conclusions:

```latex
\chapter*{Acknowledgements}
\section*{Requirements}
```

As for numbered headings, an optional argument gives a shorter title for the
table of contents and the header:
`\chapter*[Notation]{Notation and abbreviations}`. An unnumbered chapter,
such as the introduction, should not contain sections: use `\paragraph`
headings instead, which start a paragraph and are not listed in the table of
contents.

### Chapters

Each chapter is a separate file in `chapters/`, included with `\include`.
To add a chapter, create the file and add the corresponding line to
`main.tex`. To compile only the chapter you are working on, add
`\includeonly{chapters/c2}` to the preamble: page numbers and references to
the other chapters are preserved.

### Appendices

Material that supports the thesis but would interrupt its flow, such as long
proofs, additional experimental results, the full description of a dataset
or a user manual, belongs in one or more appendices, placed after the
conclusions and before the bibliography. The command `\appendix` in
`main.tex` marks their beginning; each of them is then an ordinary chapter,
in its own file:

```latex
\include{chapters/conclusions}

\appendix
\include{chapters/appendix}

\printthesisbibliography
```

After `\appendix`, chapters are labelled "Appendix" ("Appendice" in Italian)
instead of "Chapter", both in their heading and in the running header, and
are numbered with capital letters: the first appendix is Appendix A, its
first section is Section A.1, and its figures, tables, theorems and
algorithms are numbered accordingly (Table A.1, …). Cross-references work as
in the rest of the thesis. An appendix should be referred to from the main
text, at the point where its content is relevant: material that is never
referred to probably does not belong in the thesis.

### Two-sided printing

The template is set up for one-sided printing, which is the most common
choice for a thesis. For a thesis printed on both sides of the sheet,
replace `oneside` with `twoside` in the first line of `main.tex`:

```latex
\documentclass[12pt, a4paper, twoside]{book}
```

The style then adapts the layout: running headers and page numbers move to
the outer side of the page, on the left of even pages and on the right of
odd ones; chapters, as well as dedication, epigraph and lists, start on a
right-hand page, and the pages left blank for this reason have neither
header nor page number; the license is printed on the back of the cover, and
the "Made in SLIM" page on the back cover. If the sheets are bound, some
space can be reserved for the binding on the inner side of the pages, adding
to the preamble, for instance, `\geometry{bindingoffset=1cm}`.

## Writing the thesis

### Headings and cross-references

The thesis is divided into chapters, sections and subsections:

```latex
\chapter{Writing the thesis}  \label{ch2}
\section{Headings}            \label{sec:headings}
\subsection{Labels}
```

Subsubsections (`\subsubsection`) are available too, but they are neither
numbered nor listed in the table of contents: if you feel the need for them,
the section is probably too long. `\paragraph` gives a run-in heading at the
start of a paragraph.

Every numbered element can be given a `\label` and referred to with `\ref`
(or `\eqref` for equations). A non-breaking space (`~`) avoids a line break
between the word and the number:

```latex
as discussed in Section~\ref{sec:headings}
```

References are hyperlinks (see [Links](#links)).

### Mathematics

Mathematics is typeset with the STIX Two Math font (see the `mathfont`
option). Inline formulas are enclosed in dollar signs: `$\bx_i \in \R^d$`.
Displayed formulas that need a number use the `equation` environment, and
can be referred to with `\eqref{eq:risk}`:

```latex
\begin{equation} \label{eq:risk}
  \min_{\bw, b} \; \frac{1}{n} \sum_{i=1}^n
    \ell\bigl(y_i, \bw^\top \bx_i + b\bigr) + \lambda \lVert \bw \rVert^2
\end{equation}
```

A displayed formula that is never referred to does not need a number:
enclose it between `\[` and `\]`, which centre it on a line of its own
exactly as `equation` does, but without number; the environment `equation*`
is equivalent. Number only the formulas you actually refer to: a thesis in
which every formula is numbered is harder to read, not easier.

```latex
\[
  \sigma(z) = \frac{1}{1 + e^{-z}}
\]
```

Several formulas aligned on a common symbol use `align`:

```latex
\begin{align}
  \pr  &= \frac{\TP}{\TP + \FP}, &
  \rec &= \frac{\TP}{\TP + \FN}, \label{eq:prec-rec} \\
  \F_1 &= 2 \, \frac{\pr \cdot \rec}{\pr + \rec}. \label{eq:f1}
\end{align}
```

Its starred version `align*` aligns the formulas without numbering any of
them, while `\notag` at the end of a line of `align` omits the number of
that line only:

```latex
\begin{align*}
  \sigma(z)  &= \frac{1}{1 + e^{-z}}, \\
  \sigma'(z) &= \sigma(z) \bigl(1 - \sigma(z)\bigr).
\end{align*}
```

#### Notation

Notation used throughout the thesis is best defined once, as macros in
`style/symbols.tex`. The file already contains, among others, bold vectors
and matrices (`\bx`, `\bw`, `\bX`), number sets (`\R`) and the operators used
above (`\pr`, `\rec`, `\sgn`). Edit it freely: it belongs to your thesis, not
to the style. Note also that `\epsilon` is redefined as `\varepsilon`. The
meaning of the notation can be summarised in the
[list of symbols](#list-of-symbols).

#### Theorems and definitions

The style defines the following theorem-like environments, whose headings
follow the language of the programme:

| Environment       | English     | Italian       |
|-------------------|-------------|---------------|
| `thm`             | Theorem     | Teorema       |
| `lem`             | Lemma       | Lemma         |
| `prop`            | Proposition | Proposizione  |
| `cor`             | Corollary   | Corollario    |
| `defn`, `defn*`   | Definition  | Definizione   |
| `fact`            | Fact        | Fatto         |
| `proof`           | Proof       | Dimostrazione |

Each numbered environment has its own counter, which restarts at each
chapter: they are numbered as chapter and progressive number, so that the
first definition and the first proposition of Chapter 2 are Definition 2.1
and Proposition 2.1, the second definition is Definition 2.2, and so on.

```latex
\begin{defn} \label{def:convex}
  A function $f \colon \R^d \to \R$ is \emph{convex} if ...
\end{defn}

\begin{prop} \label{prop:hinge}
  For every $y \in \{-1, +1\}$, the hinge loss ... is convex.
\end{prop}

\begin{proof}
  It is the maximum of two affine functions of $z$, ...
\end{proof}
```

Definitions that are never referred to, for instance when recalling a
standard notion, can use `defn*`: it has the same heading as `defn`, but no
number, and does not advance the counter of definitions. Since there is no
number, it cannot be the target of a `\ref`.

```latex
\begin{defn*}
  The \emph{Euclidean norm} of $\bx \in \R^d$ is
  $\lVert \bx \rVert = \sqrt{x_1^2 + \dots + x_d^2}$.
\end{defn*}
```

Unnumbered versions of the other environments can be added in the preamble
with the `\newtheorem*` command of the `amsthm` package; their heading,
however, does not change with the language of the programme:

```latex
\newtheorem*{thm*}{Theorem}
```

### Tables

Tables are placed in a floating `table` environment, with the caption
*above* the table. Use the rules of the `booktabs` package (`\toprule`,
`\midrule`, `\bottomrule`) and no vertical lines. For numbers, the `S` column
of `siunitx` aligns values on the decimal point and formats uncertainties:

```latex
\begin{table}[htbp]
  \centering
  \caption{Performance of the compared models ...}
  \label{tab:results}
  \begin{tabular}{l
                  S[table-format=1.3(2), detect-weight, mode=text]
                  ...}
    \toprule
    {Model} & {Precision} & {Recall} & {$\F_1$} \\
    \midrule
    Logistic regression & 0.812(14) & 0.774(21) & 0.792(12) \\
    ...
    Random forest       & \bfseries 0.869(10) & ... \\
    \bottomrule
  \end{tabular}
\end{table}
```

Headers in `S` columns go between braces; the options `detect-weight` and
`mode=text` are needed to typeset a value in bold with `\bfseries`.

#### Rotated tables

A table too wide for the page can be placed on a page in landscape
orientation, so that its width runs along the height of the sheet. The
`landscape` environment of the `pdflscape` package, loaded in `main.tex`,
typesets its content on rotated pages; in the PDF these pages are also
marked as landscape, so that viewers display them the right way up. Wrapping
it in `\afterpage` defers the landscape page until the end of the current
one, so that the text flows without leaving a gap:

```latex
\afterpage{%
\begin{landscape}
\begin{table}
  \centering
  \caption{Precision, recall and $\F_1$ score of the compared models ...}
  \label{tab:datasets}
  \sisetup{table-format=1.3, detect-weight, mode=text}
  \begin{tabular}{l SSS SSS SSS}
    \toprule
    & \multicolumn{3}{c}{Breast cancer}
    & \multicolumn{3}{c}{Credit default}
    & \multicolumn{3}{c}{Hospital readmission} \\
    \cmidrule(lr){2-4} \cmidrule(lr){5-7} \cmidrule(lr){8-10}
    {Model} & {Precision} & {Recall} & {$\F_1$} & ... \\
    \midrule
    Logistic regression & 0.951 & 0.962 & 0.956 & ... \\
    ...
    \bottomrule
  \end{tabular}
\end{table}
\end{landscape}}
```

Here `\sisetup` sets the options of all the `S` columns at once,
`\multicolumn` spans a header over several columns and `\cmidrule` draws a
partial rule below it. Wide figures are placed on landscape pages in the
same way, with a `figure` environment inside `landscape`.

#### Tables spanning several pages

A table longer than a page is written with the `longtable` environment of
the package with the same name, loaded in `main.tex`. Unlike `table`, it
does not float: it starts where it is written and continues on as many
pages as needed. Its first rows declare what is repeated on each page: the
header of the first page (ended by `\endfirsthead`), the header of the
following pages (`\endhead`), the footer of all pages but the last
(`\endfoot`) and the footer of the last page (`\endlastfoot`):

```latex
\begin{longtable}{r r r l S[table-format=1.3, detect-weight, mode=text]}
  \caption{$\F_1$ score of a random forest for each configuration ...}
  \label{tab:grid} \\
  \toprule
  {\#} & {Max depth} & {Trees} & {Max features} & {$\F_1$} \\
  \midrule
  \endfirsthead
  \caption[]{(continued)} \\
  \toprule
  {\#} & {Max depth} & {Trees} & {Max features} & {$\F_1$} \\
  \midrule
  \endhead
  \midrule
  \multicolumn{5}{r}{\emph{Continued on next page}} \\
  \endfoot
  \bottomrule
  \endlastfoot
  1 & 4 & 50 & \texttt{sqrt} & 0.775 \\
  2 & 4 & 50 & \texttt{log2} & 0.769 \\
  ...
\end{longtable}
```

The caption and the label are the first row of the table, ended by `\\`. On
the following pages, `\caption[]{(continued)}` repeats the table number
followed by "(continued)", without adding a second entry to the list of
tables. Since a long table cannot float, introduce it at the point of the
text where it belongs, and keep it out of paragraphs: leave an empty line
before and after it.

### Figures

Figures are placed in a floating `figure` environment, with the caption
*below* the figure. Images are included with `\includegraphics`, looking for
them in the `images/` directory; vector formats (PDF) are preferable to
bitmaps:

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{kde_plot.pdf}
  \caption{Kernel density estimate of ...}
  \label{fig:kde}
\end{figure}
```

Plots can also be drawn directly in LaTeX with `pgfplots`, so that their
fonts match the text. The colours defined in `style/colors.tex`, as well as
`slimblue`, can be used in plots and diagrams:

```latex
\begin{figure}[htbp]
  \centering
  \begin{tikzpicture}
    \begin{axis}[width=0.8\textwidth, height=0.5\textwidth,
                 xlabel={Training set size}, ylabel={$\F_1$}, ...]
      \addplot[color=pastelBlueDark, mark=*]
        coordinates {(500,0.58) (1000,0.65) ... (10000,0.80)};
      \addlegendentry{Logistic regression}
      ...
    \end{axis}
  \end{tikzpicture}
  \caption{Learning curves: ...}
  \label{fig:learning-curve}
\end{figure}
```

#### Subfigures

Related images can be grouped in a single figure, each with its own caption,
using the `subfigure` environment of the `subcaption` package. Each
subfigure is given a width, here slightly less than half of the line so that
two of them fit side by side, and everything inside it, including plots,
should be sized relative to `\linewidth`:

```latex
\begin{figure}[htbp]
  \centering
  \begin{subfigure}[b]{0.48\textwidth}
    \centering
    \begin{tikzpicture}
      \begin{axis}[width=0.95\linewidth, height=0.8\linewidth, ...]
        \addplot[color=pastelBlueDark, thick, domain=-6:6]
          {1/(1+exp(-x))};
      \end{axis}
    \end{tikzpicture}
    \caption{Logistic function.}
    \label{fig:sigmoid}
  \end{subfigure}
  \hfill
  \begin{subfigure}[b]{0.48\textwidth}
    ...
    \caption{ROC curve of the random forest.}
    \label{fig:roc}
  \end{subfigure}
  \caption{Two subfigures: \subref{fig:sigmoid} the logistic function
    and \subref{fig:roc} a ROC curve, ...}
  \label{fig:subfigures}
\end{figure}
```

Subfigures are labelled (a), (b), and so on: a reference to a subfigure,
such as `\ref{fig:sigmoid}`, gives "2.2a", while `\subref{fig:sigmoid}`
gives just the label, "(a)". The optional argument `[b]` aligns the
subfigures at their bottom, so that their captions are on the same line even
if the images have different heights. Images are included in the same way,
with `\includegraphics[width=\linewidth]{...}` inside each subfigure.

### Algorithms

Algorithms are written in pseudocode with the `algpseudocode` package,
inside the floating `algorithm` environment of the `algorithm` package, both
loaded in `main.tex`. Like figures and tables, algorithms have a caption and
are numbered within each chapter:

```latex
\begin{algorithm}[htbp]
  \caption{$k$-means clustering}
  \label{alg:kmeans}
  \begin{algorithmic}[1]
    \Require points $\bx_1, \dots, \bx_n \in \R^d$, number of clusters $k$
    \Ensure centroids ... and assignments $c_1, \dots, c_n$
    \State choose $\symbfit{\mu}_1, \dots, \symbfit{\mu}_k$ at random ...
    \Repeat
      \For{$i = 1, \dots, n$}
        \State $c_i \gets \operatorname*{arg\,min}_j
          \lVert \bx_i - \symbfit{\mu}_j \rVert$
          \Comment{nearest centroid}
      \EndFor
      \For{$j = 1, \dots, k$}
        \State $\symbfit{\mu}_j \gets$ mean of the points ...
          \label{alg:kmeans:update}
      \EndFor
    \Until{no assignment $c_i$ changes}
    \State \Return $\symbfit{\mu}_1, \dots, \symbfit{\mu}_k$,
      $c_1, \dots, c_n$
  \end{algorithmic}
\end{algorithm}
```

The optional argument `[1]` of `algorithmic` numbers every line; a line can
then be given a `\label` and referred to with `\ref`. `\Require` and
`\Ensure` introduce the input and the output (printed as "Input:" and
"Output:"), `\State` a generic step, `\Comment` a comment aligned to the
right; besides `\For` and `\Repeat`–`\Until`, the package provides
`\If`–`\ElsIf`–`\Else`–`\EndIf`, `\While`–`\EndWhile`,
`\Function`–`\EndFunction` and `\Call`. The heading is "Algorithm" or
"Algoritmo" according to the language. Algorithms are collected in the list
of algorithms, printed by `\listofalgorithms` after the list of tables.

## Citations and links

References are managed with biblatex and biber, in the author–year style:
citations show the surname of the authors and the year of publication, and
the bibliography at the end of the thesis is sorted alphabetically.

### The bibliography file

References are stored in `bibliography.bib`, one entry per work, each
identified by a key:

```bibtex
@article{breiman2001random,
  author  = {Breiman, Leo},
  title   = {Random Forests},
  journal = {Machine Learning},
  volume  = {45},
  number  = {1},
  pages   = {5--32},
  year    = {2001},
  doi     = {10.1023/A:1010933404324}
}
```

Write author names as `Surname, Name` and separate them with `and`. Export
services such as Google Scholar, DBLP or the publisher's web site provide
entries in this format, but check them: they often contain mistakes or miss
the DOI. Only the works actually cited in the text are listed in the
bibliography, which is printed by `\printthesisbibliography` at the end of
`main.tex`.

### Citing

Citations use the familiar commands of the natbib package. The two most
common forms are the parenthetical one, `\citep`, and the textual one,
`\citet`, where the author names are part of the sentence:

```latex
Random forests \citep{breiman2001random} combine ...
As shown by \citet{breiman2001random}, ...
```

which produce "Random forests (Breiman, 2001) combine …" and "As shown by
Breiman (2001), …". The other available commands are:

| Command                                          | Output                               |
|--------------------------------------------------|--------------------------------------|
| `\citep{cortes1995support}`                      | (Cortes and Vapnik, 1995)            |
| `\citet{cortes1995support}`                      | Cortes and Vapnik (1995)             |
| `\citep[p.~280]{cortes1995support}`              | (Cortes and Vapnik, 1995, p. 280)    |
| `\citep[see][]{vapnik1995nature}`                | (see Vapnik, 1995)                   |
| `\citep{bishop2006pattern,hastie2009elements}`   | (Bishop, 2006; Hastie et al., 2009)  |
| `\citealp{pedregosa2011scikit}`                  | Pedregosa et al., 2011               |
| `\citeauthor{goodfellow2016deep}`                | Goodfellow et al.                    |
| `\citeyear{goodfellow2016deep}`                  | 2016                                 |

Works with more than two authors are cited with the first author followed by
"et al."; all the authors are listed in the bibliography.

### DOIs and URLs

When an entry has a `doi` field, the bibliography shows it as a
`https://doi.org/...` link; otherwise, the `url` field is shown, if present.
The link closes the entry, right-aligned and never broken across lines.
Prefer the DOI to the URL whenever it exists: it is a permanent identifier,
while web addresses change over time.

Web addresses in the text are written with `\url`, which breaks them only
after characters such as slashes and dots. The address must be written
without spaces or line breaks:

```latex
documented at \url{https://scikit-learn.org/stable/modules/...}
```

### Links

Citations, cross-references, URLs and DOIs are all hyperlinks, coloured in
the blue of the SLIM logo. This dark blue is barely distinguishable from
black on paper. With the option `pdfa=false`, links are blue when the PDF is
viewed on screen and black when it is printed, so that the printed thesis
has a uniform appearance; this is not allowed in a PDF/A file, and a few PDF
viewers that ignore the distinction may show the links in black or print
them in blue. To create a link with arbitrary text, use `\href`:

```latex
the \href{https://slim.di.unimi.it}{SLIM laboratory}
```

## PDF/A

The thesis is produced as a PDF/A-2b file, the archival format usually
required when the final version is deposited, through the `pdfx` package.
The title, the author, the degree course and the keywords given with
`\keywords` are stored in the metadata of the file; the style writes them in
the file `main.xmpdata`, read by `pdfx`, which is regenerated at each
compilation and should not be edited. Conformance can be checked with the
free validator [veraPDF](https://verapdf.org). The option `pdfa=false`
produces an ordinary PDF file instead.

## Before submitting

A few checks are worth doing before the final submission.

- The cover shows the right programme, the full names of supervisor and
  co-supervisors, the academic year and, if required, the student ID.
- The compilation completes without errors, and the log contains no
  *undefined references* or *undefined citations*: run the full sequence of
  [Compiling](#compiling) (or `latexmk`) once more after the last change.
- The log reports no *overfull boxes*, i.e., no lines exceeding the margin;
  long words or formulas causing them can be fixed by rephrasing, or by
  suggesting hyphenation points with `\-`.
- Every figure and table is referred to in the text, and its caption can be
  understood without reading the surrounding text.
- Bibliographic entries are complete (authors, title, venue, year) and have
  a DOI whenever one exists.
- Placeholder material, such as the examples of the template, the dedication
  or the epigraph if not wanted, has been removed.

## Customising the style

The style is meant to be used as it is, but a few aspects are easy to change
in `slimthesis.sty`, where they are grouped and commented: the spacing of the
bibliography (`\bibitemsep` and the line spacing set by
`\AtBeginBibliography`), the colour of links (`slimblue`), and the fonts. Keep
such changes to a minimum, and note them down: when a new version of the
style is released, they will have to be applied again.

The last page of the thesis acknowledges the SLIM laboratory; it can be
omitted with the `madeinslim=false` option.

## License

Copyright (c) 2026 Dario Malchiodi and SLIM laboratory, Università degli
Studi di Milano.

The template is released under the [MIT license](LICENSE). The license
covers the template only: theses written with it belong to their authors.

Some bundled files keep their own terms (see [LICENSE](LICENSE) for
details): the logos of the Università degli Studi di Milano and of the SLIM
laboratory, the Creative Commons buttons, and the Figtree font, released
under the [SIL Open Font License 1.1](fonts/Figtree/OFL.txt).
