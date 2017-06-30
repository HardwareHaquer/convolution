//CompositeView

(
Window.closeAll;
w = Window.new("nested", Rect.new(0,0 , 800, 480), border:false)
 .front
 .alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds, 30@30, 30@30));

c = Array.fill(4, {
	arg view;
	view = CompositeView(w, 200@200)
	.background_(Color.rand);

	view.decorator_(FlowLayout(view.bounds, 5@5, 5@5));
});
Array.fill(5, {Slider(c[0], 30@150)});
Array.fill(8, {Knob(c[1], 40@40)});
Array.fill(8, {Button(c[2], 30@30)
	.states_([["on",Color.red, Color.black],
		["off", Color.black, Color.cyan],
		[]]);
});

)

c[0].children[2].value_(0.5);
c[1].children.collect(_.value_(0.75));
c[2].children.collect(_.states_(["on",Color.red, Color.black],["off", Color.green, Color.cyan],[]));
c[2].children[2].value_(0);

(
(c[2].children.size-1).do{ |i|
	c[2].children[i].value_(rrand(0,2));
};
)