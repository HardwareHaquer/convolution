(SynthDef(\funSynth, {
	arg pitch = 200, att=0.01, sus = 0.1, rel = 1, mult=0.2;
	var sound = SinOsc.ar(pitch, mul: mult);
	var linen = Env.linen(att, sustainTime:sus, releaseTime:rel);
	var env = EnvGen.kr(linen, doneAction:2);
	Out.ar(0, sound * env);
}).add;
)
(
var clock = TempoClock(1);
{
10.do{
		s.bind(Synth(\funSynth, [pitch:300.rrand(600), rel: 1, mult:0.2]));
	0.1.wait;
};
}.fork(clock);
)

NetAddr.localAddr
(
OSCdef(\starlistener, {
	arg msg;
	Synth(\funSynth, [pitch:msg[6], att: msg[1], sus: msg[2], rel: msg[3], mult:0.5]);
	4.do{
		arg i;
		msg[7+i].postln;
	}

}, "/starhit");

)


(
OSCdef(\multi, {
arg msg;
var clock = TempoClock(1);
{
	msg[5].do{
			s.bind(Synth(\funSynth, [pitch:msg[6].rrand(600), att: msg[1], sus: msg[2], rel: msg[3], mult:0.5]));
			msg[4].wait;
};
}.fork(clock);
}, "\multi");
)

\multi.free;

(
d ={Pan2.ar(
Normalizer.ar(
RLPF.ar(
RLPF.ar(Gendy2.ar(a:SinOsc.kr(0.4,0,0.05,0.05),c:SinOsc.kr(0.3,0,0.1,0.5)),
MouseX.kr(10,10000,'exponential'),0.05),
MouseY.kr(10,10000,'exponential'),0.05)
,0.9)
,Lag.kr(LFNoise0.kr(1),0.5))}.play
)

d.free;

a = Scale.minor;
a.degrees;        // [ 0, 2, 4, 5, 7, 9, 11 ]
a.semitones;        // [ 0, 2, 4, 5, 7, 9, 11 ]
a.cents;        // [ 0, 200, 300, 500, 700, 900, 1100 ]
a.ratios;        // [ 1, 1.1224620483089, 1.2599210498937, 1.3348398541685, etc. ]

Pbind(\scale, a, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.5).play;

Pbind(\freq, Prand([440,880,220, 1660, 330], 10), \dur, [0.05,0.1, 0,0.2].wrapAt(3)).play;