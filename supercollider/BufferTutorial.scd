~b0 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/808loopMono.wav");
~b1 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/BD.wav");
~b2 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/elevator_start.wav");
~b3 = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/elevator_stop.wav");

~b3.play;

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

~b2_end = Buffer.read(s, "/Users/astewart/Developer/SuperColliderTests/sounds/elevator_start.wav", 65000, ~b2.numFrames - 65000);
~b2.numFrames;
~b2_end.play;

//load multiple sound files at once

~samps = Array.new;
~folder = PathName.new("/Users/astewart/Developer/SuperColliderTests/sounds/");
~folder.entries;
(
~folder.entries.do({
	arg path;
	~samps = ~samps.add(Buffer.read(s, path.fullPath));
});
)


~samps.at(0).play;
~samps.at(3).play;
~samps.at(2).play;
~samps.[2].play;

s.options.numBuffers

//PlayBuf  and BufRd

(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf, rate=1, t_trig=1, start=0, da=2, loop=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, doneAction: da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\playbuf_test, [\buf, ~b3.bufnum, \start, 144800, \da,0, \rate, 3]);

x.set(\loop, 1);
x.set(\rate, 48.midiratio);
x.free;
//reverse
y = Synth.new(\playbuf_test, [\buf, ~b3.bufnum, \start, ~b3.numFrames-2, \rate, -6, \da, 0]);

y.set(\rate, -1);
y;
y.free;

~b1.sampleRate;
~b3.numFrames;
s.plotTree;
s.freeAll;

//BufRd

(
SynthDef.new(\bufrd_test, {
	arg amp=1, out=0, buf, start, end, rate=1;
	var sig, ptr;
/*	ptr = Line.ar(0, BufFrames.kr(buf)-1, BufDur.kr(buf),
		doneAction:2);*/
	ptr = Line.ar(start, end, BufDur.kr(buf),
		doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig*amp;
	Out.ar(out, sig);
}).add;
)

x=Synth.new(\bufrd_test, [\buf, ~b3.bufnum, \start, 20000, \end, 80000]);
~b3.numFrames;
(
SynthDef.new(\bufrd_loop, {
	arg amp=1, out=0, buf, start, end, rate=1;
	var sig, ptr;
	ptr = Phasor.ar(0, BufRateScale.kr(buf)*rate, start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig*amp;
	Out.ar(out, sig);
}).add;
)

x=Synth.new(\bufrd_loop, [\buf, ~b3.bufnum, \start,0, \end, ~b3.numFrames-1]);
x.set(\start, 0, \end, ~b3.numFrames-2, \rate, -3.midiratio);
x.free;

(
SynthDef.new(\bufrd_sine, {
	arg amp=1, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = SinOsc.ar(freq, 3pi/2).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig*amp;
	Out.ar(out, sig);
}).add;
)

x=Synth.new(\bufrd_sine, [\buf, ~b3.bufnum, \start,0, \end, ~b3.numFrames-1, \freq, 0.5]);
x.set(\freq, 0.05);
x.free;

(
SynthDef.new(\bufrd_noise, {
	arg amp=1, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig*amp;
	Out.ar(out, sig);
}).add;
)

x=Synth.new(\bufrd_noise, [\buf, ~b3.bufnum, \start,0, \end, ~b3.numFrames-1, \freq, 1]);
x.set(\freq, 0.05);
x.free;

g = Group.new;

w=Synth.new(\bufrd_noise, [\buf, ~b0.bufnum, \start,0, \end, ~b0.numFrames-1, \freq, 0.6, \amp, 0.5], g);
x=Synth.new(\bufrd_noise, [\buf, ~b1.bufnum, \start,0, \end, ~b1.numFrames-1, \freq, 0.8, \amp, 0.5], g);
y=Synth.new(\bufrd_noise, [\buf, ~b2.bufnum, \start,0, \end, ~b2.numFrames-1, \freq, 0.7, \amp, 0.5], g);
z=Synth.new(\bufrd_noise, [\buf, ~b3.bufnum, \start,0, \end, ~b3.numFrames-1, \freq, 0.5, \amp, 0.5], g);

g.set(\freq, 24);
g.freeAll;

z.free;