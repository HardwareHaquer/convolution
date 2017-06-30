(SynthDef(\simplebpf, {
	arg freq=440, rq=0.2;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, freq.lag(0.5),
		rq.lag(0.5),
		1/rq.sqrt.lag(0.5)
	);
	Out.ar(0, sig);
}).add;
)
y=Synth(\simplebpf);
y.free;



(
Window.closeAll;
w = Window.new("gui", Rect.new(
	Window.screenBounds.width/2-300,
	 (Window.screenBounds.height)/3-100,
	600,200))
 .front
 .alwaysOnTop_(true);

~slider = Slider.new(w.view, Rect(20,20,150,30));
~slider.visible_(true);  //visible or not?
~slider.bounds_(Rect(40,40,200,20));  //change dimensions
~slider.enabled_(true); //can be used or greyed out?
~slider.remove; //gid rid of it
)
 w.close;



(
Window.closeAll;
w = Window("gui", Rect(
	Window.screenBounds.width/2-300,
	 (Window.screenBounds.height)/3-100,
	600,200))
.background_(Color.gray(0.2))
 .front
 .alwaysOnTop_(true);

~slider = Slider(w, Rect(20,20,150,30))
 .background_(Color(0,0,0))
 .knobColor_(Color.cyan)
 .action_({
	arg obj;
	var cf;
	cf  = obj.value.linexp(0, 1, 100,4000).postln;
	if(
		x.isPlaying,
		{x.set(\freq, cf)}
	);
	~numberBox.value_(obj.value.linexp(0,1,100,4000));
});

~button = Button(w, Rect(430,20,50,30))
.states_([
	["OFF", Color.black, Color.gray(0.8)],
	["ON", Color.white, Color.cyan]
])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x =Synth(\simplebpf,
				[
					\freq, ~slider.value.linexp(0,1,100,4000),
					\rq, ~knob.value.linexp(0,1,1,100).reciprocal
				]
			).register;
			~knob.value.linexp(0,1,1,100).reciprocal.postln;
		},
		{x.free;}
	);
});

~knob = Knob(w, Rect(300,30,50, 50))
.background_(Color.cyan)
.action_({
	arg obj;
	var qual;
	qual = obj.value.linexp(0,1,1,100).reciprocal;
	//qual.postln;
	if(
		x.isPlaying,
		{x.set(\rq, qual)}
	);
});


~numberBox = NumberBox(w, Rect(180,20,80,30))
.value_(100)
.clipLo_(100)
.clipHi_(4000)
.decimals_(2)
.action_({
	arg obj;
	~slider.valueAction_(obj.value.explin(100,4000,0,1))
	//ONLY have one chained GUI object use valueAction or inf loop of doom
});
~freqLabel = StaticText(w, Rect(180, 50, 80, 30))
.string_("freq")
.stringColor_(Color.white)
.align_(\center);

//can set font with Font

)

(
~obj.remove;
~obj = PopUpMenu(w, Rect(20, 100, 120, 30));
)

(
x =Synth(\simplebpf,
	[
		\freq, ~slider.value.linexp(0,1,100,4000),
		\rq, ~knob.value.linexp(0,1,1,00).reciprocal
	]
);
)
x.free;
//controlSpec may be better
~slider.valueAction_(rrand(0.0, 1.0));  //sets or gets value and performas action
~slider.value=0;
(
~slider.action_({
	arg obj;
	obj.value.postln;

});
)

~slider.background_(Color(0,0,0));