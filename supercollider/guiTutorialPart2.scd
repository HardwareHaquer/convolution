(
Window.closeAll;
w = Window.new("flow", Rect.new(850, 50, 400, 400))
 .front
 .alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds, 15@15, 7@7));

)

w.view.decorator.nextLine;
w.view.decorator.reset;

20.do{Knob(w, 40@40)};

w.view.children.collect(_.value_(rrand(0.0,1.0)));
w.view.children.collect(_.remove);


w.close;

//CompositeView

(
Window.closeAll;
w = Window.new("nested", Rect.new(750, 50, 500, 500))
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
Array.fill(8, {Button(c[2], 30@30)});

)

c[0].children[2].value_(0.5);
c[1].children.collect(_.value_(0.75));


(
Window.closeAll;
w = Window.new;
a = Array.fill(3,{
	3.do{ |i|
		Button(w, Rect(100*(i+1), 100, 50, 50))
		.states_(["yes", Color.grey, Color.white], ["no", Color.white, Color.grey], ["perhaps", Color.black, Color.green(0.8)]);
};
});
//b= Button(w, Rect(230, 130, 100, 100));
w.front;
w.alwaysOnTop_(true);
)
(
3.do{ |i|
	a[i].states = [["yes", Color.grey, Color.white], ["no", Color.white, Color.grey], ["perhaps", Color.black, Color.green(0.8)]];
}
)
a[0]
(
var ary;
ary = Array.new(3);
ary = [0,1,2];

3.do{ |i|
	a.states = [["yes", Color.grey, Color.white], ["no", Color.white, Color.grey], ["perhaps", Color.black, Color.green(0.8)]];
}
)
// change the states:
a.states = [["yes", Color.grey, Color.white], ["no", Color.white, Color.grey]];
a.states = [["yes", Color.grey, Color.white], ["no", Color.white, Color.grey], ["perhaps", Color.black, Color.green(0.8)], []];

// change the states on action:
(
a.action = { |view|
    if(view.value == 3) { a.states =  [[["yes", "no"].choose, Color.grey, Color.white]] }
}
);