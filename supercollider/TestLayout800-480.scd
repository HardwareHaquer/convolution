//CompositeView

(
Window.closeAll;
w = Window.new("nested", Rect.new(-100, 50, 800, 480))
 .front
 .alwaysOnTop_(true);

// w.view.decorator_(FlowLayout(w.bounds, 0@0, 0@0));
w.view.decorator_(FlowLayout(Rect(w.bounds.left,w.bounds.top,w.bounds.width,w.bounds.height), 0@0, 0@0));
r = Rect(-200,0,w.bounds.width,w.bounds.height);
c = Array.fill(3, {
	arg view;
	switch(view,
		0, { view = CompositeView(w, Rect(0,0,705,(480-(800/32*16)))).background_(Color.rand);},
		1,  { view = CompositeView(w, Rect(0,0,800/2,800/32*16)).background_(Color.rand);},
		 {view = CompositeView(w, 95@480).background_(Color.rand);}
	);
	/*if(view == 0, {
		view = CompositeView(w, Rect(0,0,600,90)).background_(Color.rand);},
	{view = CompositeView(w, 95@480).background_(Color.rand);});*/


	view.decorator_(FlowLayout(view.bounds, 0@0, 0@0));
});


Array.fill(5, {Slider(c[0], 150@30)});
Array.fill(16*16, {Button(c[1], (800/32)@(800/32))
	.states_([["on",Color.red, Color.black],
		["off", Color.black, Color.cyan],
		[]])
	.background_(Color.black);
});
Array.fill(8, {Knob(c[2], 40@40)});


)
w.bounds.width
w.bounds.height
w.bounds.top
w.bounds.left

(
~testArray.rowsDo(_.postln);
)
//can set temp variable to hold a single column or row and then set or read the value.
l = ~testArray.colAt(2);
l[3]
c[0].children[2].value_(0.5);
c[1].children.collect(_.value_(0.75));
c[2].children.collect(_.states_(["on",Color.red, Color.black],["off", Color.green, Color.cyan],[]));
c[2].children[2].value_(0);

//set button values from stored Array2D!
~testArray = Array2D.new(16,32);

//function to populate array
l = { |ary| (
ary.cols.do({ |i|
	ary.rows.do({ |j|
		ary[j,i] = [0,1,2].choose;
	});
});
)}
l.value
l.value(~testArray);

//update the button values

(
(c[1].children.size-1).do{ |i|
	c[1].children[i].value_(~testArray.asArray[i]);
	//c[1].children[i].value.postcs;
};
)

(
var tester2D, tester;
tester2D = Array2D.new(3,3);
tester2D[0,0] = 0;
tester2D[0,1] = 1;
tester2D[0,2] = 2;
tester2D[1,0]=3;
tester = [0,1,2,3,4,5,6,7,8];
tester.postln;
tester2D.asArray.postln;
)
(
var ca = Array.newClear(18);
var caD = Array2D.new(6,6);
var steps = 3;
var insturments = 6;
var swap = 0;
insturments.do({ |i|
  steps.do({ |j|
		ca[i*steps + j] = i*insturments+j;
		caD[i,j+(steps*swap)] = i*insturments+j;
	})
});
ca.postln;
caD.colsDo.postln;
)


1%16
2%16
16%2
16%16
16%17
16 % 33