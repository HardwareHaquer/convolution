(
SynthDef.new(\blip, {
	arg out, fund=300, dens=2, decay=0.2;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, fund*4).round(fund);
	sig = SinOsc.ar(freq) *0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	//sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;

SynthDef.new(\ampOsc, {
	arg in, out=127, freq=2;
	var sig;
	sig = In.ar(in, 2);
	sig = sig * SinOsc.kr(freq);
	Out.ar(out, sig);
}).add;
)

s.options.numAudioBusChannels;
s.options.numInputBusChannels=8;
s.meter;

s.reboot;
s.meter;

(
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60,300).round(30)
	],
	~sourceGrp
	);
}
)
y = Synth.new(\reverb, [\in,~reverbBus2, \out, ~reverbBusOut], ~fxGrp);
z= Synth.new(\ampOsc, [\in, ~reverbBusOut, \out, 0], ~ampOscGrp);

	~reverbBusOut = Bus.audio(s,2);

x.free;
y.free;
s.freeAll;
~sourceGrp.free;
~fxGrp.free;
~ampOscGrp.free;
g = Group.new;
g.free;


~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);
~ampOscGrp = Group.after(~fxGrp);
~sourceGrp.set(\dens, 16);
~sourceGrp.set(\decay, 0.4);
~ampOscGrp.set(\freq, exprand(0.2, 5));
z.set(\freq, 20);


