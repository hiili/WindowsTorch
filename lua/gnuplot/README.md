<a name="gnuplot.dok"></a>
# Plotting Package Manual with Gnuplot #

A plotting package to visualize [Tensor](https://github.com/torch/torch7/blob/master/doc/tensor.md#tensor) objects.
Functions fall into several types of categories:

  * [Plotting lines](doc/plotline.md#gnuplot.line.dok)
  * [Plotting matrices](doc/plotmatrix.md#gnuplot.image.dok)
  * [Plotting surfaces](doc/plotsurface.md#gnuplot.surface.dok)
  * [Plotting histograms](doc/plothistogram.md#gnuplot.histogram.dok)
  * [Plotting 3D points](doc/plot3dpoints.md#gnuplot.scatter3.dok)
  * [Saving to Files](doc/file.md#gnuplot.files.dok)
  * [Common operations](doc/common.md)
  
The plotting package currently uses [gnuplot](http://gnuplot.info) as
a backend to display data. In particular, `Gnuplot` version `4.4`
or above is suggested for full support of all functionality.

By default, the plot package will search for terminal in following order:

  * ` windows ` terminal if operating system is windows
  * ` wxt `, ` qt `, ` x11 `  terminal if operating system is linux
  * ` aqua `, `wxt`, ` qt `, ` x11 ` terminal if operating system is mac

It is also possible to manually set any terminal type using
[gnuplot.setterm](#gnuplot.setterm). Interactivity is
dependent on the terminal being used. By default, `x11` and ''wxt
support'' different interactive operations like, zooming, panning,
rotating...

The `Gnuplot` port uses `pipes` to communicate with `gnuplot`,
therefore each plotting session is persistent and additional commands
can be sent. For advanced users [gnuplot.raw](doc/common.md#gnuplot.raw)
provides a free form interface to gnuplot.
