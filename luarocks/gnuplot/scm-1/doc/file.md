<a name="gnuplot.files.dok"></a>
## Saving Plots to Files ##

Any of the above plotting utilities can also be used for directly plotting
into `eps` or `png` files, or `pdf` files if your gnuplot installation
allows. A final gnuplot.plotflush() command ensures that all output is
written to the file properly.

```lua
gnuplot.epsfigure('test.eps')
gnuplot.plot({'Sin Curve',torch.sin(torch.linspace(-5,5))})
gnuplot.xlabel('X')
gnuplot.ylabel('Y')
gnuplot.plotflush()
```

<a name="gnuplot.epsfigure"></a>
### gnuplot.epsfigure(fname) ###

Creates a figure directly on the `eps` file given with
`fname`. This uses `Gnuplot` terminal `postscript eps enhanced color`.

<a name="gnuplot.pdffigure"></a>
###  gnuplot.pdffigure(fname) ###

Only available if your installation of gnuplot has been compiled
with `pdf` support enabled.

Creates a figure directly on the `pdf` file given with
`fname`. This uses `Gnuplot` terminal `pdf enhanced color`,
or `pdfcairo enhanced color` if available.

<a name="gnuplot.pngfigure"></a>
### gnuplot.pngfigure(fname) ###

Creates a figure directly on the `png` file given with
`fname`. This uses `Gnuplot` terminal `png`, or `pngcairo` if available.

<a name="gnuplot.svgfigure"></a>
###  gnuplot.svgfigure(fname) ###

Creates a figure directly on the `svg` file given with `fname`. This uses
`Gnuplot` terminal `svg`.

<a name="gnuplot.figprint"></a>
### gnuplot.figprint(fname) ###

Prints the current figure to the given file with name `fname`. Only `png`
or `eps` files are supported by default. If your gnuplot installation
allows, `pdf` files are also supported.

<a name="gnuplot.plotflush"></a>
### gnuplot.plotflush([n]) ###

This command sends `unset output` to underlying gnuplot. Useful for
flushing file based terminals.

<a name="gnuplot.close"></a>
### gnuplot.close() ###

Closes open file handles. Prevents too many handles staying open if creating lots of plots.
