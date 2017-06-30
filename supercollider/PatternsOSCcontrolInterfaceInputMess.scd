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
~hihatArray = Array.fill(32, {rrand(-2,2)});
(
Synth(\funSynth, [pitch:50.rrand(600)]);
OSCdef(\conga, { |msg|
	//Synth(\funSynth, [pitch:200.rrand(600)]);
	~instArray = msg[1..32];
	 for(0, ~instArray.size-1, {|i|
		if(~instArray[i] == 0,
			{~instArray[i] = Rest},
			{~instArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});



	~degrees.source = (Pseq(~instArray, inf));
	msg[0].postln;
	~instArray.postln;

	~knobsArray = msg[34..39];
	~knobsArray.postln;

}, "/conga");

Synth(\funSynth, [pitch:50.rrand(600)]);
OSCdef(\hihat, { |msg|
	//Synth(\funSynth, [pitch:200.rrand(600)]);
	~hihatArray = msg[1..32];
	 for(0, ~hihatArray.size-1, {|i|
		if(~hihatArray[i] == 0,
			{~hihatArray[i] = Rest},
			{~hihatArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});



	~degree.source = (Pseq(~hihatArray, inf));
	msg[0].postln;
	~hihatArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/hi-hat");
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

//~dur = PatternProxy(Pn(0.125, inf));

p = Pbind(
	\instrument, \beeu,
    \degree, ~degree,
	\scale, Pfunc{~scale},
    \dur, ~dur,
	\strum, 10

).play(u, quant: 1);


)
a = [1,1,1, Rest,1,Rest,1, Rest];
~degree.source = Pseq([11,12,13, Rest,1,Rest,24, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~dur.source = Pn(1, inf);//PatternProxy(Pn(1, inf));
~degree.source = Pseq(Array.fill(16, {rrand(-3,7)}), inf);
(
//~degrees = PatternProxy(Pn(Pseries(12,-1, 12), inf));

~durs = PatternProxy(Pn(1, inf));

g = Pbind(
	\instrument, \ueeb,
    \degree, ~degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\strum, 0.1
).play(t, quant: 1);
)
~scale = Scale.minorPentatonic;
~scales = Scale.minor;

Pbind(\note, [1, 3, 5, 7, 9], \strum, 0.1).play
~degrees.source = (Pseq(~instArray, inf));
~degrees.source = Pseq(Array.fill(64, {[-5,-3,0,3,5,Rest,Rest,Rest, Rest, Rest].choose}), inf);

~dur.source = Pwrand(#[0.25, 0.5, 0.75], #[0.5, 0.3, 0.2], inf);
~durs.source = Pn(0.2, inf);
Scale.directory
g.stop;
p.pause;
p.play;
p.stop;

(
SystemClock.sched(0.0,{ arg time;
    time.postln;
    rrand(0.1,0.9);
});
)

(
t = TempoClock.default;

t.play({
	arg beats, time, clock;
	[beats, time, clock].postln;
});

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
u.tempo = u.tempo * 1/4;
t.tempo = t.tempo * 1/4;
)

b = NetAddr.new("127.0.0.1", 12001);    // create the NetAddr
b.sendMsg("/tick", 31, "hrlp","more");    // send the application the message "hello" with the parameter "there"o
OSCFunc.trace(true);
OSCFunc.trace(false);


(
~degree = PatternProxy(Pn(Pseries(0, 1, 12), inf));

~dur = PatternProxy(Pn(1, inf));

p = Pbind(
	\instrument, \help_sawgrain,
    \degree, ~degree,
	\scale, Pfunc{~scale},
    \dur, 0.125,//~dur,
	\strum, 10

);



~degrees = PatternProxy(Pn(Pseries(12,-1, 12), inf));

~durs = PatternProxy(Pn(1, inf));

g = Pbind(
	\instrument, \help_sinegrain,
    \degree, ~degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\strum, 0.1
);
Ppar([p,g], inf).play(quant: 1);
)
~scale = Scale.minorPentatonic;
~scales = Scale.locrian;

