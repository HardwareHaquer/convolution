(
~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);
~ampOscGroup = Group.after(~fxGroup);
)
s.killAll
s.freeAll
s.reboot
Scale.directory
s.plotTree;
~scale = Scale.prometheus;
~coreNote = 58;
~coreNote = 60;
440.midinote
Scale.major.degrees[6]
(

var notes, on, off;
~noteOn;
~noteOff;
~knobs;
~root;
~degree;
~scale = Scale.major;

notes = Array.newClear(128);
on = OSCdef(\testNoteOn, { |msg|
	var frqa, frqb, frqc;
	~noteOn = msg;
	//~noteOn.postln;
	~degree = ~noteOn[2] % 12;
	//notes[~noteOn[2]] = Synth(\oscnotes, [\pitch, ~scale.degreeToFreq(~degree, ~coreNote.midicps, ~root), \trig, ~noteOn[3]/128, \out, ~reverbBus], ~srcGroup);
	frqa = ~scale.degreeToFreq(~degree, ~coreNote.midicps, ~root);
	frqb = ~scale.degreeToFreq(~degree-12, ~coreNote.midicps, ~root);
	frqc = ~scale.degreeToFreq(~degree+4, ~coreNote.midicps, ~root);
	//notes[~noteOn[2]] = Synth(\ay1, [\freqa, frqa, \freqb, frqb, \freqc, frqc,\trig, ~noteOn[3]/128, \out, ~reverbBus], ~srcGroup);
	//~scale.degreeToFreq(~degree, ~coreNote.midicps, ~root).postln;
	//~noteOn[2].midicps.postln;
	notes[~noteOn[2]] = Synth(\oscnotes, [\pitch, ~noteOn[2].midicps, \trig, ~noteOn[3]/128, \out, ~reverbBus], ~srcGroup);
	//x.set("pitch", ~noteOn[2].midicps);
	//x.set("trig", ~noteOn[3]/128);


}, "/noteOn");



off = OSCdef(\testNoteOff, { |msg|
	~noteOff = msg;
	~noteOff.postln;
	notes[~noteOff[2]].set(\trig, 0);
	notes[~noteOff[2]].release;
	//x.set("trig", 0);

}, "/noteOff");

 OSCdef(\testKnobs, { |msg|
	~knobs = msg;
	~srcGroup.set(\pitchMod, g.unmap(msg[1])*2);
	~srcGroup.set(\atk, g.unmap(msg[2]));
	~srcGroup.set(\releaseTime, g.unmap(msg[3])*2+0.01);
	/*~srcGroup.set(\dens, g.unmap(msg[1])*10);
	~srcGroup.set(\decay, g.unmap(msg[2])+0.01);*/

	//~fxGroup.set(\mix, g.unmap(msg[3]));
	~srcGroup.set(\vola, 15*g.unmap(msg[4]));
	~srcGroup.set(\volb, 15*g.unmap(msg[5]));

	~srcGroup.set(\volc, 15*g.unmap(msg[6]));
	//y.set(\damp, g.unmap(msg[3])*2);
	//a.set("dens",
	//~noteOn.postln;

		//g.unmap(msg[3])*10.postln;
}, "/knobs");
~oldmsg = 0;
OSCdef(\encoder, { |msg|
	~root = msg[1]-4;
	if(msg[1] != ~oldmsg, {msg[1].postln});
	~oldmsg = msg[1];
	//~root.postln;

}, "/encoder");

q = { on.free; off.free};
)
~srcGroup.freeAll;
~fxGroup.freeAll;
~ampOscGroup.freeAll;
q.value;
y = {SinOsc.ar(440)}.play;
y.free;
x = Synth("oscnotes");
x.free;
(
SynthDef("oscnotes", { arg out, pitch=440, trig=0, pitchMod =0, amp = 0.5, atk=0.01, releaseTime=1;
var sound, env;
sound = SinOsc.ar(pitch+pitchMod);
	env = EnvGen.ar(Env.adsr(releaseTime: releaseTime), trig, doneAction: 2);
Out.ar(out, sound*env*amp);
}).add;


)
g = ControlSpec(0, 4096, step:0);
~reverbBus = Bus.audio(s, 1);
~reverbBusOut = Bus.audio(s,1);
a = Synth(\blip, [\out, ~reverbBus], ~srcGroup);
y = Synth.new(\reverb, [\in,~reverbBus, \out, 0], ~fxGroup);
z = Synth(\ampOsc, [\in, ~reverbBusOut, \out, 0], ~ampOscGroup);
z.free;
y.free;
a.free;
(

SynthDef.new(\blip, {
	arg out, fund=300, dens=2, decay=0.2, amp =1;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, fund*4).round(fund);
	sig = SinOsc.ar(freq) *0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	//sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig*amp);
}).add;
SynthDef.new(\reverb, {
	arg in, out=0, mix=0.5, room=0.8, damp=0.2, amp = 1, pass=0;
	var sig;
	sig = In.ar(in, 1);
	if(pass == 1, {
		sig = FreeVerb.ar(sig, mix, room, damp, amp);
	});
	Out.ar(out, sig);
}).add;

SynthDef.new(\ampOsc, {
	arg in, out=127, freq=0.2, vol =0.1;
	var sig;
	sig = In.ar(in, 1);
	sig = (sig * SinOsc.kr(freq));
	Out.ar(out, sig-vol!2);
}).add;
)
~srcGroup.set(\dens, 4);
~ampOscGroup.set(\vol, 1);
~fxGroup.set(\pass, 1);
~fxGroup.set(\mix, 0.5);
y.set(\pass, 1);

(
SynthDef("am1", {arg freq = 200, modfreq = 5, amp = 0.4, att = 0.01, rel = 3, out;
    var carrier, modulator, env;
    env = Env.perc(
        attackTime: att,
        releaseTime: rel,
        level: amp
    ).kr(2);
    modulator = SinOsc.ar(modfreq).range(0, 1);
    carrier = SinOsc.ar(freq: freq, mul: env * modulator);
    Out.ar(out, carrier ! 2);
}).add;
)
x = Synth(\ay1,[\out, ~reverbBus], ~srcGroup);
x.free;

(
SynthDef(\ay1, { | freqa=440, freqb=550, freqc=660, vola=7, volb=15, volc=10, chink=1, wobbly=1, pan=0, amp=0.1, gate=1, out|
    var ay, chinkenv, wobblyenv;

    //chinkenv = if(chink>0, EnvGen.kr(Env.new([0.06125, 0.06125, 1, 1], [0.05, 0, 0.1], 0, 4, 4)), 1);
    chinkenv = if(chink>0, EnvGen.kr(Env.new([2, 2, 1, 1], [0.05, 0, 0.1], 0, 4, 4)), 1);
    wobblyenv = LFPulse.kr(10, 0.5, mul:wobbly).range(0.5, 0.5);

    # freqa, freqb, freqc = [freqa, freqb, freqc] * [1, wobblyenv, wobblyenv] * chinkenv;
    ay = AY.ar(AY.freqtotone(freqa), AY.freqtotone(freqb), AY.freqtotone(freqc),
        0, 3, vola, volb, volc, 2000, 15, mul: amp);
    ay = ay * EnvGen.kr(Env.asr(0.01, 1, 1), gate, doneAction:2);
    Out.ar(out, ay);
}).add;
)
(
Pbind(
    \instrument, \ay1,
    \freqa,    Pseq((#[55, 55, 57, 58, 57, 55, 58, 50]-12).midicps, inf),
    \freqb,    Pseq([
                    Pseq( (#[55, 55, 54, 55, 54, 55, 58, 57]+12).midicps, 2),
                    Prand((#[55, 55, 54, 55, 54, 55, 58, 57]+12).midicps, 2)
                ], inf),
    \dur,    Pseq(#[3, 0.5, 0.5, 1.5, 0.5, 1, 1, 4] * 0.4, inf),
    \wobbly,    Pstutter(8 * 4, Prand(#[0, 1], inf)),
    \vola,    15,
    \volb,    14,
    \chink,    1,
    \amp,    0.4
).play
)

s.killAll
s.quit