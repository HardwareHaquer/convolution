s.boot;

(
SynthDef(\funSynth, {
	|pitch =400|
	var sound = SinOsc.ar(pitch, mul: 0.2);
	var linen = Env.linen(sustainTime: 0.1);
	var env = EnvGen.kr(linen, doneAction: 2);
	Out.ar(0, sound*env);
}).add;
)
~instArray = Array.fill(32, {rrand(-2,2)});
(
Synth(\funSynth, [pitch:50.rrand(600)]);
OSCdef(\testListen, { |msg|
	//Synth(\funSynth, [pitch:200.rrand(600)]);
	~instArray = msg[1..32];
	 for(0, ~instArray.size-1, {|i|
		if(~instArray[i] == 0,
			{~instArray[i] = Rest},
			{~instArray[i] = ~scales.degrees.choose}
		);
	});

	~degrees.source = (Pseq(~instArray, inf));
	~instArray.postln;

	~knobsArray = msg[34..39];
	~knobsArray.postln;

}, "/test");
)
~scales.degrees
Scale
(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.001, sustain, 0.05), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)

(
SynthDef(\help_sawgrain,
    { arg out=0, freq=440, ssustain=0.1;
        var env;
        env = EnvGen.kr(Env.perc(0.001, ssustain, 0.05), doneAction:2);
		Out.ar(out, SawDPW.ar(freq, 0, env))
    }).add;
)
~instArray*60.postln
(
a = Pseq(~instArray, inf).asStream;
b= Routine({
    loop({
        Synth(\help_sinegrain, [\freq, a.next.midicps]);
		a.next.postln;
        0.2.wait;
    })
}).play;
)
a.postln
b.free

(
~degree = PatternProxy(Pn(Pseries(0, 1, 12), inf));

~dur = PatternProxy(Pn(0.25, inf));

p = Pbind(
	\instrument, \help_sawgrain,
    \degree, ~degree,
	\scale, Pfunc{~scale},
    \dur, ~dur,
	\strum, 10

).play(quant: 1);
)

~degree.source = Pseq(Array.fill(16, {rrand(-3,7)}), inf);
(
~degrees = PatternProxy(Pn(Pseries(12,-1, 12), inf));

~durs = PatternProxy(Pn(1, inf));

g = Pbind(
	\instrument, \help_sinegrain,
    \degree, ~degrees,
	\scale, Pfunc{~scales},
    \dur, ~durs,
	\strum, 0.1
).play(quant: 1);
)
~scale = Scale.minorPentatonic;
~scales = Scale.locrian;


~degrees.source = (Pseq(~instArray, inf));
~degrees.source = Pseq(Array.fill(64, {rrand(-3,7)}), inf);
~durs.source = Pwrand(#[0.25, 0.5, 0.75], #[0.5, 0.3, 0.2], inf);
~durs.source = Pn(0.2, inf);
Scale.directory
g.stop;
p.pause;
p.play;
p.stop;