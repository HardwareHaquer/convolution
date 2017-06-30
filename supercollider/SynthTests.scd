{SinOsc.ar(Vibrato.ar(DC.ar(400.0),1,0.02) )}.play

s.boot;

{SinOsc.ar(Vibrato.kr(400.0,20,0.02))}.play


{SinOsc.ar(Vibrato.ar(DC.ar(400.0),MouseX.kr(2.0,100.0),0.1,1.0,1.0,MouseY.kr(0.0,1.0),0.1) )}.play

{SinOsc.ar(Vibrato.ar(DC.ar(400.0),LFNoise1.kr(10,3,7),MouseX.kr(0.0,1.0),1.0,1.0,MouseY.kr(0.0,1.0),0.1) )}.play

{LeakDC.ar(DC.ar(0.5))}.play;

(
{
    var a;
    a = LFPulse.ar(400, 0.5, 0.5, 0.5);
    [a, LeakDC.ar(a, 0.75)]
}.scope(bufsize: 22050)
)

{ LFPulse.ar(400) * 0.1 }.play;

{ LFPulse.ar(XLine.kr(1, 200, 10), 0, 0.2, 0.1) }.play;

{ LFPulse.kr(XLine.kr(1, 200, 10), 0, 0.2) * SinOsc.ar(440) * 0.1 }.play;


{ LFPulse.ar(LFPulse.kr(30, 0, 0.3, MouseX.kr(30,1000), MouseY.kr(30,1000)), 0, 0.5, 0.1) }.play;

{ LFNoise1.ar(200, 0.25) }.play;

{ LFNoise2.ar(XLine.kr(10000, 20, 0.5), 0.25) }.play;

(
SynthDef(\beeu, { |freq = 1000|
	var sig, env;
	sig  = LFNoise2.ar(XLine.kr(10000, 20, 0.5), 0.25);
	sig = sig * SinOsc.ar(XLine.kr(50,freq, 0.3),0,1,0.5) +SinOsc.ar(100,0,1,0.5);// + LFNoise1.kr([50,50], 0.05);
	env = EnvGen.kr(Env.perc(curve: -6), doneAction: 2);
	Out.ar(0, 0.1*sig*env!2);
}).add;
)
s.meter
(
SynthDef(\ueeb, { |freq=300, degree=1|
	var sig, env, test;

	sig  = LFNoise2.ar(XLine.kr(freq*10, freq*100, 0.2), 0.25);
	sig = sig + SinOsc.ar(freq,0,1,0.25) + LFNoise1.kr([50,50], 0.05);
	sig = sig * CombN.ar(SinOsc.ar(freq, 0, 0.2), 0.01, XLine.kr(0.0001, 0.001, 0.25), -1);
	env = EnvGen.kr(Env.perc(0.1, 0.4, 1, -8), doneAction: 2);
	Out.ar(0, 0.4*sig*env!2);
}).add;
)
x = Synth(\beeu, [\freq, rrand(20,2000)]);
x.free;
Scale.major.degreeToFreq(1, 60.midicps, 1);
Synth(\ueeb, [\freq, rrand(50,800)]);
(
{ SinOsc.ar(
	        LFNoise1.ar(XLine.kr(1000, 1, 1), 1000, 40),
        0, 0.2
    )
}.play;
)
s.plotTree;
(
{ SinOsc.ar(
	LFNoise1.ar(Linen.ar(1,0.5, 1, 1, 2), 1000, 40),
        0, 0.2
    )
}.play;
)


(
r = {
    var scale = Scale.choose.postln;
    SinOsc.ar(
        (
            DegreeToKey.kr(
                scale.as(LocalBuf),
                MouseX.kr(0,15), // mouse indexes into scale
                scale.stepsPerOctave,
                1, // mul = 1
                60 // offset by 72 notes
            )
            + LFNoise1.kr([50,50], 0.5) // add some low freq stereo detuning
        ).midicps, // convert midi notes to hertz
        0,
        0.25
    )
}.play;
)

r.free;

{ CombL.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;

{ CombN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;

{ CombN.ar(SinOsc.ar(400,0,0.2,0), 0.01, XLine.kr(0.0001, 0.01, 1), -1 )}.play;

{WhiteNoise.ar(0.01)}.postln;

Spec

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
	Out.ar(0, Pan2.ar(filter))

}).add;
)
c = Synth(\Moog);
c.free;

Scale.minor.degrees

Scale.kurd.degrees

Scale.