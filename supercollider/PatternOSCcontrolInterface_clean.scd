//what needs to be initialized first?
//synth defs
//tempoClock
//oscDefs
//~scales and
s.boot;
(
SynthDef(\beeu, { |freq = 1000|
	var sig, env;
	sig  = LFNoise2.ar(XLine.kr(10000, 20, 0.5), 0.25);
	sig = sig * SinOsc.ar(XLine.kr(50,freq, 0.3),0,1,0.5) +SinOsc.ar(100,0,1,0.5);// + LFNoise1.kr([50,50], 0.05);
	env = EnvGen.kr(Env.perc(curve: -6), doneAction: 2);
	Out.ar(0, 0.1*sig*env!2);
}).add;
)

(
SynthDef(\ueeb, { |freq=300, degree=1|
	var sig, env, test;

	sig  = LFNoise2.ar(XLine.kr(freq*10, freq*100, 0.2), 0.25);
	sig = sig + SinOsc.ar(freq,0,1,0.25) + LFNoise1.kr([50,50], 0.05);
	sig = sig * CombN.ar(SinOsc.ar(freq, 0, 0.2), 0.01, XLine.kr(0.0001, 0.001, 0.25), -1);
	env = EnvGen.kr(Env.perc(0.1, 0.4, 1, -8), doneAction: 2);
	Out.ar(0, 0.2*sig*env!2);
}).add;
)

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

(
SynthDef(\funSynth, {
	|pitch =400|
	var sound = SinOsc.ar(pitch, mul: 0.2);
	var linen = Env.linen(sustainTime: 0.1, releaseTime:0.25);
	var env = EnvGen.kr(linen, doneAction: 2);
	Out.ar(0, sound*env);
}).add;
)

(
SynthDef("Moog",{

arg oscType =0, oscType2 = 1, pan = 0, level = 0.5, cutoff = 500, gain = 3.3, attack = 0.1, decay = 0.1, sust = 0.7, rel = 0.2, attackf = 0.1, decayf = 0.1, sustf = 0.9, relf = 0.2, gate = 1, freq =440;


var oscArray = [Saw.ar(freq ), SinOsc.ar(freq), Pulse.ar(freq)];
var oscArray2 = [Saw.ar(freq), SinOsc.ar(freq), Pulse.ar(freq)];
var ampEnv = EnvGen.ar(Env.adsr(attack, decay, sust, rel), gate, doneAction:2);
var filterEnv = EnvGen.ar(Env.adsr(attackf, decayf, sustf, relf), gate, doneAction:2);
var osc1 = Select.ar(oscType, oscArray);
var osc2 = Select.ar(oscType2, oscArray2);
var fade = XFade2.ar(osc1, osc2, pan , level * ampEnv);
var filter = MoogFF.ar(fade, cutoff * filterEnv, gain);
Out.ar(0,filter)

}).add;
)

//audio test
s.plotTree;
x =Synth(\funSynth, [pitch:50.rrand(600)]);
x.free;
(
~scales = Scale.minor;
~bassDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~congaDegrees = PatternProxy(Pn(Pseries(0, 4, 12), inf));
~hihatDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~kickDegrees = PatternProxy(Pn(Pseries(0, 8, 12), inf));
~fluteDegrees = PatternProxy(Pn(Pseries(0, 0.5, 12), inf));
~snareDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth1Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth2Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
)

(
~bassArray = Array.fill(32, {rrand(-2,2)});
~congaArray = Array.fill(32, {rrand(-2,2)});
~hihatArray = Array.fill(32, {rrand(-2,2)});
~kickArray = Array.fill(32, {rrand(-2,2)});
~fluteArray = Array.fill(32, {rrand(-2,2)});
~snareArray = Array.fill(32, {rrand(-2,2)});
~synth1Array = Array.fill(32, {rrand(-2,2)});
~synth2Array = Array.fill(32, {rrand(-2,2)});
)

(
OSCdef(\scaleGetter, { |msg|

	~scale = Scale.at(Scale.names[msg[1]]);

	~scale.postln;
}, "/scale");
)


(

Synth(\funSynth, [pitch:50.rrand(600)]);

OSCdef(\lead, { |msg|

	~bassArray = msg[1..32];
	 for(0, ~bassArray.size-1, {|i|
		if(~bassArray[i] == 0,
			{~bassArray[i] = Rest},
			{~bassArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~bassDegrees.source = (Pseq(~bassArray, inf));
	msg[0].postln;
	//~bassArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/lead");

Synth(\funSynth, [pitch:50.rrand(600)]);

OSCdef(\bass, { |msg|

	~bassArray = msg[1..32];
	 for(0, ~bassArray.size-1, {|i|
		if(~bassArray[i] == 0,
			{~bassArray[i] = Rest},
			{~bassArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~bassDegrees.source = (Pseq(~bassArray, inf));
	//msg[0].postln;
	//~bassArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/bass");

OSCdef(\conga, { |msg|

	~congaArray = msg[1..32];
	 for(0, ~congaArray.size-1, {|i|
		if(~congaArray[i] == 0,
			{~congaArray[i] = Rest},
			{~congaArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});
	~congaDegrees.source = (Pseq(~congaArray, inf));
	//msg[0].postln;
	//~congaArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/conga");

Synth(\funSynth, [pitch:50.rrand(600)]);
OSCdef(\hihat, { |msg|

	~hihatArray = msg[1..32];
	 for(0, ~hihatArray.size-1, {|i|
		if(~hihatArray[i] == 0,
			{~hihatArray[i] = Rest},
			{~hihatArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~hihatDegrees.source = (Pseq(~hihatArray, inf));
	//msg[0].postln;
	//~hihatArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/hi-hat");

OSCdef(\kick, { |msg|

	~kickArray = msg[1..32];
	 for(0, ~kickArray.size-1, {|i|
		if(~kickArray[i] == 0,
			{~kickArray[i] = Rest},
			{~kickArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~kickDegrees.source = (Pseq(~kickArray, inf));
	//msg[0].postln;
	//~kickArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/kick");

OSCdef(\flute, { |msg|

	~fluteArray = msg[1..32];
	 for(0, ~fluteArray.size-1, {|i|
		if(~fluteArray[i] == 0,
			{~fluteArray[i] = Rest},
			{~fluteArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~fluteDegrees.source = (Pseq(~fluteArray, inf));
	//msg[0].postln;
	//~fluteArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/flute");

OSCdef(\snare, { |msg|

	~snareArray = msg[1..32];
	 for(0, ~snareArray.size-1, {|i|
		if(~snareArray[i] == 0,
			{~snareArray[i] = Rest},
			{~snareArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~snareDegrees.source = (Pseq(~snareArray, inf));
	//msg[0].postln;
	//~snareArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/snare");

OSCdef(\synth1, { |msg|

	~synth1Array = msg[1..32];
	 for(0, ~synth1Array.size-1, {|i|
		if(~synth1Array[i] == 0,
			{~synth1Array[i] = Rest},
			{~synth1Array[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~synth1Degrees.source = (Pseq(~synth1Array, inf));
	//msg[0].postln;
	//~synth1Array.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/synth1");

OSCdef(\synth2, { |msg|

	~synth2Array = msg[1..32];
	 for(0, ~synth2Array.size-1, {|i|
		if(~synth2Array[i] == 0,
			{~synth2Array[i] = Rest},
			{~synth2Array[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~synth2Degrees.source = (Pseq(~synth2Array, inf));
	//msg[0].postln;
	//~synth2Array.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/synth2");

)

//Setup OSC messages to Processing and setup tempoClock.  Below is OSCdef to set tempo
)
//Send OSC tick to processing
(
b = NetAddr.new("127.0.0.1", 12001);    // create the NetAddr
// get elapsed time, round up to next second
v = Main.elapsedTime.ceil;
~mainTempo = 1;  //bpm = num * 60  bpm/60 = num
(1000/125*60).postln;
// create two clocks, starting at time v.
t = TempoClock(1, 0, v);
u = TempoClock(t.tempo*8, 0, v);

// start two functions at beat zero in each clock.
// t controls u's tempo. They should stay in sync.
t.schedAbs(0, { arg beat, sec; /* [\t, beat, sec].postln;*/ 1 });
u.schedAbs(0, { arg beat, sec; /*["/tick", beat%32, "hrlp","more"].postln;*/b.sendMsg("/tick", beat%32, "hrlp","more");  1 });
)
(
OSCdef(\getbpm, {|msg|
	~mainTempo = msg[1]/60;
	t.tempo = ~mainTempo;
	u.tempo = t.tempo*8;
	//msg.postln;
}, "/bpm");
)
(
~mainTempo = 60/60;
t.tempo = ~mainTempo;
u.tempo = t.tempo*8;
)
(
~degree = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~dur = PatternProxy(Pn(0.125, inf));

~degree.source = Pseq([11,12,13, Rest,1,Rest,24, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~dur.source = Pn(1, inf);//PatternProxy(Pn(1, inf));

~bassDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~congaDegrees = PatternProxy(Pn(Pseries(0, 4, 12), inf));
~hihatDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~kickDegrees = PatternProxy(Pn(Pseries(0, 8, 12), inf));
~fluteDegrees = PatternProxy(Pn(Pseries(0, 0.5, 12), inf));
~snareDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth1Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth2Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));

(


~scale = Scale.major;

p = Pbind(
	\instrument, \beeu,
    \degree, ~degree,
	\scale, Pfunc{~scale},
    \dur, ~dur,
	//\strum, 10

).play(u, quant: 1);

p.stop;
)
a = [1,1,1, Rest,1,Rest,1, Rest];
~congaDegrees.source = Pseq([11,12,13, Rest,1,Rest,12, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~hihatDegrees.source = Pseq([11,12,13, Rest,1,Rest,24, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);

~scales = Scale.kurd;

(
~flute.stop;
~hihat.stop;
~conga.stop;
~snare.stop;
~synth1.stop;
~synth2.stop;
~bass.stop;
~kick.stop;
)
~rootNote = -5;
(
~bass = Pbind(
	\instrument, \ueeb,
    \degree, ~bassDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~conga = Pbind(
	\instrument, \beeu,
    \degree, ~congaDegrees,
	\scale, Pfunc{~scales},
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~hihat = Pbind(
	\instrument, \help_sinegrain,
    \degree, ~hihatDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~kick = Pbind(
	\instrument, \help_sawgrain,
    \degree, ~kickDegrees,
	\scale, Pfunc{~scales},
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~flute = Pbind(
	\instrument, \funSynth,
    \degree, ~fluteDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~snare = Pbind(
	\instrument, \beeu,
    \degree, ~snareDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth1 = Pbind(
	\instrument, \ueeb,
    \degree, ~synth1Degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth2 = Pbind(
	\instrument, \funSynth,
    \degree, ~synth2Degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,

).play(t, quant: 1);
)
~synth2.stop;
q.stop;
g.stop;
p.stop;
q.play