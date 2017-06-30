//Synth def examples for Convolution

//just for testing




(
SynthDef(\beeu, { |freq = 1000|
	var sig, env;
	sig  = LFNoise2.ar(XLine.kr(10000, 20, 0.5), 0.25);
	sig = sig * SinOsc.ar(XLine.kr(50,freq, 0.3),0,1,0.5) +SinOsc.ar(100,0,1,0.5);// + LFNoise1.kr([50,50], 0.05);
	env = EnvGen.kr(Env.perc(curve: -6), doneAction: 2);
	Out.ar(0, 0.1*sig*env!2);
}).add;



SynthDef(\ueeb, { |freq=300, degree=1|
	var sig, env, test;

	sig  = LFNoise2.ar(XLine.kr(freq*10, freq*100, 0.2), 0.25);
	sig = sig + SinOsc.ar(freq,0,1,0.25) + LFNoise1.kr([50,50], 0.05);
	sig = sig * CombN.ar(SinOsc.ar(freq, 0, 0.2), 0.01, XLine.kr(0.0001, 0.001, 0.25), -1);
	env = EnvGen.kr(Env.perc(0.1, 0.4, 1, -8), doneAction: 2);
	Out.ar(0, 0.2*sig*env!2);
}).add;



SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05, amp=1;
        var env;
        env = EnvGen.kr(Env.perc(0.001, sustain, 0.05), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env*amp))
    }).add;

/*SynthDef(\help_sawgrain,
    { arg out=0, freq=440, ssustain=0.1;
        var env;
        env = EnvGen.kr(Env.perc(0.001, ssustain, 0.05), doneAction:2);
		Out.ar(out, SawDPW.ar(freq, 0, env))
    }).add;*/



SynthDef(\funSynth, {
	|freq =400, gate=0.5|
	var sound = SinOsc.ar(freq, mul: 0.2);
	var linen = Env.linen(sustainTime: 0.1, releaseTime:0.25);
	var env = EnvGen.kr(linen,gate, doneAction: 2);
	Out.ar(0, sound*env);
}).add;

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

SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
    var sig, plfo, fcurve;
    plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
    freq = Lag.kr(freq, freqlag) * plfo;
    fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
    fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
    sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
    sig = RLPF.ar(sig, fcurve, rq)
        * EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
        * amp;
    Out.ar(out, sig ! 2)
}).add;

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
SynthDescLib.
SynthDef.synthDefDir.postln;

// x =Synth(\funSynth, [pitch:50.rrand(600)]);
// x =Synth(\beeu, [freq:50.rrand(6000)]);
// //x =Synth(\Moog, [freq:200.rrand(800), gate:1]);
// x.free;