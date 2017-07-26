<a name="gnuplot.image.dok"></a>
## Plotting Matrices ##

A given matrix can be plotted using 2D contour plot on a surface.

<a name="gnuplot.imagesc"></a>
### gnuplot.imagesc(z, ['color' or 'gray']) ###

Plot surface ` z ` using contour plot. The second argument defines
the color palette for the display. By default, grayscale colors are
used, however, one can also use any color palette available in
`Gnuplot`.

```lua
x = torch.linspace(-1,1)
xx = torch.Tensor(x:size(1),x:size(1)):zero():addr(1,x,x)
xx = xx*math.pi*6
gnuplot.imagesc(torch.sin(xx),'color')
```
![](plot_imagesc.png)
