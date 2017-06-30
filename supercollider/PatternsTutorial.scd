(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

x=Synth.new(\sine);

(
p=Pbind(

	\instrument, \sine,
	\dur, Pseq([0.6,0.15,0.15], inf).trace,
	\midinote, Pseq([60,64, 67, 71], inf)
).play;
)
p.stop;

(
p=Pbind(

	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	//\freq, Pexprand(100, 4000, inf).round(55).trace,
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf);

).play;
)
p.stop;
(
Pdef(
	\sinepat,
Pbind(

	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	//\freq, Pexprand(100, 4000, inf).round(55).trace,
		\midinote, Pseq([35], inf).trace,
	\harmonic, Pexprand(1, 40, inf).round,
	\atk, Pwhite(0.01, 0.01, inf),
	\rel, Pwhite(0.1, 0.5, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf);
	);
).stop;
)

(
d=Dictionary.new;
d.add(\l ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/low").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
d.add(\m ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/mid").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);

d.add(\h ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/high").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
)
d;
d[\l].choose.play;

(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;

SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;

)

Synth.new(\bufplay, [\buf, d[\m].choose.bufnum]);

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 60/128 *4,
	\buf, Prand(d[\h]++d[\l], inf),  //Pxrand, Pwrand, Pshuf
	\rate, 1,
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
);
).stop;
)

(
Pdef(
	\sinepat,
Pbind(

	\instrument, \sine,
		\dur, Pseq([1/16], inf),
	\stretch, 1.875,
	//\freq, Pexprand(100, 4000, inf).round(55).trace,
	\note, Pxrand([0,3,5,9,10,12], inf).trace,
	\gtranspose, -6,
	\atk, 0.005,
	\rel, Pexprand(0.5, 0.75, inf),
	\amp, Pexprand(0.05, 0.5, inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	);
).quant_(1.875);



Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 60/128 *4,
		\buf, Pseq(   //nested patterns
			[
				Prand(d[\l], 1),  //Pxrand, Pwrand, Pshuf  //first beat should always be low
				Prand(d[\h]++d[\m]++d[\l], 7),  //then 7 random notes
				Prand(d[\h], 1),  // 8th beat always a high sample
				Prand(d[\h]++d[\m]++d[\l], 7),  //then 7 random notes
			], inf
		),
		\rate, Pexprand(0.5, 2, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).quant_(1.875);
)
Pdef(\rhythm).stop;
Pdef(\sinepat).stop;
s.reboot;

s.boot;

Server.allRunningServers

(
var a, b, c;
a=
c=Pseq([0,1,2,3]*16, 4, 1);
b = c.asStream;
16.do({ b.next.postln; });
a = Pseq.new([1, Pseq.new([100,200], 2), 3], 3);
b = a.asStream;
19.do({ b.next.postln; });
)
Array.series(5, [10,11,12], 2).postln;

[1, 2, 3].stutter(16).postln;