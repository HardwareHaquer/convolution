//Boot stuff
s.boot;

(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

(
s.plotTree;
s.meter(2,8);
)

//reference and testing

~b0 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/808loopMono.wav");
~b1 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/BD.wav");
~b2 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/elevator_start.wav");
~b3 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/elevator_stop.wav");

~b0.play;
x = Synth.new(\playbuf_test, [\buf, ~b0.bufnum]);
x.free;
(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf, rate=1, t_trig=1, start=0, da=2, loop=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, doneAction: da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)
Platform.resourceDir +/+ "hello";
~b0.free; //remove buffer

//Frames
~b0.numFrames;

//Channels

~b0.numChannels;
//duration
~b2.duration;

//buffernumbers

~b0.bufnum;

//buffer sample rate

~b0.sampleRate;

~b0.query;

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
x = d[\m].choose;
x.play;

(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, loop=0, t_trig = 1, amp=1, da=2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, loop: loop, doneAction:da);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

y =Synth.new(\bufplay, [\buf, d[\m].choose.bufnum]);
y.free;
y.set(\rate, 1);
(
Pdef(\machine,
		Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 60/128 *4,
		\buf, Prand(d[\h]++d[\m]++d[\l], inf),  //Pxrand, Pwrand, Pshuf
		\rate, 1,//PSeq([0.5, 1, 2, 3, 4],inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
);
).stop;
)

d[\m][3].bufnum