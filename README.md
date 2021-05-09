Attempting to implement, in SwiftUI, a spline curve editor for non-linear scaling (e.g. animation curves, terrain generation, etc.).

![](https://i.imgur.com/ujJ9YUR.png)

The green line is the _x,y = f(t)_ curve drawn using SwiftUI `Path`. The black line is _y = f(x)_ drawn as piecewise linear segments (also using `Path`).

I’m struggling with a few major concerns, and some influence others:

* The most appropriate `View` factoring and organization. Should the axes be collected into their own view? Should the X- and Y-axes be two separate views? They need to connect and overlap nicely at the origin, and it’s probably best to stroke both paths at the same time (which I’m not even doing now).

	I think I’ve settled on having an `Axes` container view that `ZStacks` a `GeometryReader` (for drawing the axes) with the contents provided to it. The contents are each curve, and the control points’ handles (this part isn't implemented yet; they’re all in the same `ZStack` in `Curves`).
 
* Transforms. The curves are computed in a normalized space over [0.0, 1.0]. So I need to get the current dimensions of the graph area and scale the values appropriately to draw them. I also need to do the inverse when dragging control points or tracking mouse movement. I also need to invert the y-axis because the graph origin is near the bottom of the view.

* Tracking mouse movement. I want to be able to show input and output values as the user hovers over the curve. I’m using SwiftUI Lab’s excellent [approach](https://swiftui-lab.com/a-powerful-combo/) that uses `NSView` and `NSTrackingArea`.

	A serious issue arises when I enable the tracking view: the scaling/translation of the contained views changes dramatically.

* Drawing control points. I’ve been able to draw control points using `Path`, but it seems a more idiomatic SwiftUI approach is to use the `Circle` shape. But I don’t understand scaling and translating a `View` or `Shape` very well (e.g. using `.offset()` and `.scale()`. You can toggle between `Path` drawing and `Circle()` drawing with the checkbox in the corner.

* Dragging control points. The few examples in the docs and online generally attach a drag gesture handler to the View to be dragged. I tried this and it didn't work (but also my shapes are not drawn in the right place because I don't have the transforms correct).

* Drawing text along the axes tick marks. I can try using `Text` views, but is that best way to do it? In the past I would have used Core Graphics to draw the text directly, rather than try to sprinkle `NSTextFields` in there.
