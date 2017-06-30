//CompositeView

(
~steps = 16;
~gaps = 10;
~bMarg = 10;
Window.closeAll;
w = Window.new("nested", Rect.new(750, 50, Window.screenBounds.width, Window.screenBounds.height/2))
 .front
 .alwaysOnTop_(true);

 w.view.decorator_(FlowLayout(w.bounds, ~bMarg@~bMarg, ~bMarg@~bMarg));

c = Array.fill(2, {
	arg view;

	view = CompositeView(w, w.bounds.width-(~bMarg*2)@(2*w.bounds.height/3))
	.background_(Color.rand);

	view.decorator_(FlowLayout(view.bounds, ~gaps@~gaps, ~gaps@~gaps));
});
~lightBar = Array.fill(~steps, {
	arg lightDim;
	lightDim = ((c[0].bounds.width-((~steps+1) * ~gaps))/~steps).floor;
	lightDim.postln;
	Button(c[0], lightDim@(lightDim/5))
	.states_([
		["", Color.black, Color.black],
		["", Color.magenta, Color.magenta]
	])

});
~kicker = Array.fill(~steps, {
	arg butDim;
	butDim = ((c[0].bounds.width-((~steps+1) * ~gaps))/~steps).floor;
	Button(c[0], butDim@butDim)
	.states_([
		["—", Color.gray(0.3), Color.white],
		["+", Color.white, Color.cyan],
		//["o", Color.white, Color.magenta]
	])

});

~high = Array.fill(~steps, {
	arg butDim;
	butDim = ((c[0].bounds.width-((~steps+1) * ~gaps))/~steps).floor;
	Button(c[0], butDim@butDim)
	.states_([
		["—", Color.gray(0.3), Color.white],
		["+", Color.white, Color.cyan],
		//["o", Color.white, Color.magenta]
	])

});
~mid = Array.fill(~steps, {
	arg butDim;
	butDim = ((c[0].bounds.width-((~steps+1) * ~gaps))/~steps).floor;
	Button(c[0], butDim@butDim)
	.states_([
		["—", Color.gray(0.3), Color.white],
		["+", Color.white, Color.cyan],
		//["o", Color.white, Color.magenta]
	])

});

Array.fill(8, {Knob(c[1], 40@40)});

)
w.bounds.width;
c[0].children[2].value_(0.5);
c[1].children.collect(_.value_(0.75));

w.bounds.width -( ~bMarg *2)

((c[0].bounds.width-((~steps+1) * ~gaps))/~steps).floor
(468/~steps).floor

(

~steps.do{
	arg i;
	if(~kicker[i].value == 1, {~kicker[i].value = 0},  {~kicker[i].value = 1});
	// 1.wait;
}
)

if(~kicker[3].value == 1, {~kicker[3].value = 0},  {~kicker[3].value = 1})

(
SynthDef(\help_sinegrain,
    { arg out = 0, freq = 440, sustain = 0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env)!2)
    }).add;
)
~lastKick = ~kicker;
(~steps-1).do{|i| ~lastKick[i].value.postln;}
(
var a, i;

a = Pfunc({ exprand(0.1, 0.3) + #[1, 2, 3, 6, 7].choose }).asStream;
a.nextN.postln;
i =0;

{
    a.do { |val|
		var temp;
       // Synth(\help_sinegrain, [\freq, val * 100 + 300]);
		//{lastKick = ~kicker[i].value}.defer;
		//{~lastKick[i].value.postln}.defer;
		//{temp = ~kicker[i].value;}.defer;
		//temp.postln;
		{~lightBar[i].value = 1;}.defer;
		{if( i == 0,
		{~lightBar[~steps-1].value = 0},
			{~lightBar[i-1].value = 0})}.defer;
		{if(~kicker[i].value == 1, {Synth(\help_sinegrain,[\freq, 110,\sustain, rrand(0.05, 0.8)])})}.defer;
		{if(~high[i].value == 1, {Synth(\help_sinegrain,[\freq, 660,\sustain, rrand(0.05, 0.8)])})}.defer;
		{if(~mid[i].value == 1, {Synth(\help_sinegrain,[\freq, 440,\sustain, rrand(0.05, 0.8)])})}.defer;
		i=i+1;
		if(i > 15, {i=0;});
        0.125.wait;

		//{~kicker[i].value = temp}.defer;
    }
}.fork(SystemClock);
)
~kicker[0].states[2];
(
~steps.do{ |i|
	~kicker[i].value = 0;
}
)

(
var i;
{

	i=0;
	inf.do {


		{if(~kicker[i].value == 1, {~kicker[i].value = 0},  {~kicker[i].value = 1})}.defer;
		i=i+1;
		if(i > 15, {i=0;});
		i.postln;
		0.5.wait;
	}
}.fork(SystemClock);
)


Platform.userExtensionDir

Quarks.clear
s.boot;
ddwCommon.quark
Quarks.uninstall("ddwCommon");

s.boot;


