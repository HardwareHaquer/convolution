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
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.001, sustain, 0.05), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;





SynthDef(\funSynth, {
	|pitch =400|
	var sound = SinOsc.ar(pitch, mul: 0.2);
	var linen = Env.linen(sustainTime: 0.1, releaseTime:0.25);
	var env = EnvGen.kr(linen, doneAction: 2);
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
)