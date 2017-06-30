~tempo = TempoClock.default.tempo.reciprocal / 6;  //Line
~knobs = [5,16];
~bpm = 90;
~bmp.free;
~tempoTemp = ~bpm*8 / (60);
~tempo2 = (~bpm*8 / (60)).reciprocal;
(4*TempoClock.default.tempo)*60

240/60
s.latency
(

var w, buttons, defaults=[5], knobData,knobData2, knobSet=[5,16], data, synths, dims = [32,16], resolution = 4;
Window.closeAll;
w = Window("rand-n-step", Rect(50,250,(dims[0]*32 + 10+(32*knobSet[0])), dims[1]*32+10));
w.background_(Color.black);
~synths = Array.fill(dims[1], { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			-1.0.rand2,
			EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});

data = Array2D(dims[1],dims[0]);
buttons = Array.fill(dims[1], { |l|
	Array.fill(dims[0], { |i|
		if( i % 4 == 0,
			{Button( w, Rect( 5 + (32*i), 5 + (32*l), 30, 30) ).states_([ ["■", Color.cyan, Color.gray(0.2)], ['+', Color.black, Color.cyan], ['%', Color.black, Color.magenta] ]).action_({ |b| data[l,i] = b.value })},
			{Button( w, Rect( 5 + (32*i), 5 + (32*l), 30, 30) ).states_([ ["■", Color.cyan, Color.black], ['+', Color.black, Color.cyan], ['%', Color.black, Color.magenta] ]).action_({ |b| data[l,i] = b.value })})
	})

});
knobData = Array2D(knobSet[1], knobSet[0]);
knobData2 = Array2D(knobSet[1], knobSet[0]);
/*~knobs = Array.fill(5, { |i|
	Array.fill(16, { |l|
		Knob(w, Rect(10+(32*32)+(31*l), 5+(32*i), 30, 30) ).action_({|b| knobData[l,i] = b.value});
		if(knobData[l,i] == nil, { knobData[l,i] = 0.01});
	})

});*/
~knobs2= Array2D(16, 5);
defaults = [0.01,0.125,0.5,0.2,0];
5.do({ |o|
	var defaultVal = defaults[o];
	16.do({ |f|
		~knobs2.put(f,o, Knob(w, Rect(10+(32*32)+(31*o), 5+(32*f), 30, 30) )
			.color_([Color.magenta, Color.cyan, Color.yellow, Color.black])
			.value_(defaultVal)
			.action_({|b| knobData2[f,o] = b.value}));
		f.postln;
	})
});


knobSet[0].postln;

AppClock.play({
	inf.do({|i|
		var temp, atk, rel, iphase, amp;
		temp = 0;
		dims[1].do({ |l|

			atk = knobData2[l, 0];
			rel = knobData2[l,1];
			iphase = knobData2[l,2];
			amp = knobData2[l,3];

			(buttons[l] @@ i).font_(Font("sans", 200));

			(buttons[l] @@ (i-1)).font_(Font("sans", 14));

			switch( data[l,i.mod(dims[0])],
				1, { Synth(~synths[l], [\slope, -4, \atk, atk, \rel,rel, \iphase, iphase, \amp, amp]) },
				2, { Synth(~synths[l], [\slope, 2, \atk, atk, \rel, rel, \iphase, iphase, \amp, amp])  }
			);


		if(temp < (knobSet[0]-1), {temp = temp+1}, {temp = 0});

		});
		// (TempoClock.default.tempo.reciprocal / resolution).yield;
		(~tempo2).yield;
	});
}.asRoutine);
w.front;
)
~knobs[0][4].background_(Color.magenta)
~knobs[0][4].value
~knobs.at(4,15)
~knobs2= Array2D(16, 5);
(
5.do({ |o|
	16.do({ |f|
		~knobs2.put(f,o, Knob(w, Rect(10+(32*32)+(31*o), 5+(32*f), 50, 50)).value_(0.2));
		f.postln;
	})
})
)
~knobs2[13,4].value;
TempoClock.default.tempo.reciprocal
(
~synths = Array.fill(16, { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			-1.0.rand2,
			EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});
)
a = nil![16,16];
	a[1][1].size;

	a[0][1]
(
~synths = Array.fill(16, { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			VarSaw.ar(20.exprand(4000), 0.001.exprand(1).lag, 0.001.exprand(1)),
			-1.0.rand2,
			EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});
)

(
~synths = Array.fill(16, { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			SinOsc.ar(20.exprand(4000), 0.001.exprand(1).lag, 16.reciprocal),
			-1.0.rand2,
		//	EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
			EnvGen.kr(Env.perc(0.005.rrand(0.5), 0.005.rrand(0.5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});
)
~theKey = 48;
(
~synths = Array.fill(16, { |i|
	SynthDef('rstp'++i, {
		//var freqDegree = Scale.kurd.degreeToFreq(Scale.kurd.degrees.choose, 60.midicps,1);
		var freqDegree = Scale.minor.degreeToFreq(Scale.minor.degrees.wrapAt(i), 36.midicps,-1);
		var sig = SinOsc.ar(freqDegree, 0, 7.reciprocal);
		sig = FreeVerb.ar(sig, 0.15, 0.7, 0.3);
		var sig = Pan2.ar(
			// SinOsc.ar(220*(i+1), 0, 16.reciprocal),
			SinOsc.ar(freqDegree, 0, 7.reciprocal),
			-1.0.rand2,
		//	EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
			EnvGen.kr(Env.perc(0.02, 0.2), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});
)
Scale.directory
~scaleHolder = Scale.yu0;
~theKey = 60;
(
~synths = Array.fill(16, { |i|
	if( i < ~scaleHolder.size, {
	SynthDef('rstp'++i, { arg slope = 8, atk = 0.01, rel=0.25, iphase = -1, amp =0.2;
		//var freqDegree = Scale.kurd.degreeToFreq(Scale.kurd.degrees.choose, 60.midicps,1);
		var freqDegree = ~scaleHolder.degreeToFreq(~scaleHolder.degrees.wrapAt(i), ~theKey.midicps,-1);
		var sig = SinOsc.ar(freqDegree, iphase)*amp;
			//var sig = SawDPW.ar(freqDegree, iphase)*amp;
		sig = FreeVerb.ar(sig, 0.6, 0.8, 0.1, 3);
		sig = Pan2.ar(
			sig,
			-1.0.rand2,
		//	EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
			EnvGen.kr(Env.perc(atk, rel, 1, slope), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
	},
	{SynthDef('rstp'++i, {  arg atk = 0.01, rel=0.125, amp = 0.2;
		//var freqDegree = Scale.kurd.degreeToFreq(Scale.kurd.degrees.choose, 60.midicps,1);
		var freqDegree = ~scaleHolder.degreeToFreq(~scaleHolder.degrees.wrapAt(i), ~theKey.midicps,1);
		var sig = SinOsc.ar(freqDegree, 0) * amp;
		sig = FreeVerb.ar(sig, 0.6, 0.8, 0.01);
		sig = Pan2.ar(
			sig,
			-1.0.rand2,
		//	EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
			EnvGen.kr(Env.perc(atk, rel, 1, -6), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
	})

});
)
s.recSampleFormat;
s.sampleFormat;
80.exprand(85);

s.meter(8);
s.hasShmInterface;
~scaleHolder = Scale.minorPentatonic;
~scaleHolder.size
Scale.minor.degreeToFreq(Scale.minor.degrees[1], 60.midicps,0)
60.midicps
Scale.minor.degrees
d = Scale.minor.degrees.choose;

degreeToFreq(Scale.minor.degrees.choose, 60.midicps,-1)
6.degreeToKey

Scale.directory
16.do{|i|
	var temp;
temp = Scale.ajam.degrees.wrapAt(i);
	("i :"++i++"degree :"++temp).postln;
}
1/16
{EnvGen.kr(Env.perc(0.1, 0.02, 1, -6))}.plot(1)

~synths[1].set(\slope, -8);

SynthDef
