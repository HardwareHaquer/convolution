(
z= {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise0.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
}.play;
)
z.set(\noiseHz, 32);
z.free;
(
SynthDef.new(\sineTest, {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise0.kr(12).exprange(0.02,0.4);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0, sig);
}).add;
)

x=Synth.new(\sineTest, [\noiseHz, 64]);
x.set(\noiseHz, 2);
x.free;

(
SynthDef.new(\pulseTest, {
	arg fund=40, maxPartial=4, ampHz=4, width=0.5;
	var freq1, freq2, sig1, sig2, amp1, amp2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) *0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) *0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(1,sig2);
}).add;
)

x = Synth.new(\pulseTest);

x.set(\width, 0.125);
x.set(\fund, 120);
x.set(\ampHz, 2.75);
x.set(\maxPartial, 8);
x.free;

y = Synth.new(\pulseTest, [\fund, 120, \ampHz, 2]);
z = Synth.new(\pulseTest, [\fund, 40, \ampHz, 2]);
y.set(\fund, 80);
z.set(\ampHz, 4);
z.set(\fund, 240);
(
x = {
	var sig, env, freq;
	env = XLine.kr(1, 0.01, 5, doneAction: 2);
	freq = XLine.kr(880, 110, 1, doneAction: 0);
	sig = Pulse.ar(freq) * env;
}.play;
)

Env.new.plot;

(  //triggered env using t_ set doneAction to zero to retrigger whenevs
x = {
	arg t_gate=1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.1, 0.25, 1],
		[-12,-12,2],
	), t_gate, doneAction:0);
	sig = Pulse.ar(LFPulse.kr(8).range(200,400))*env;
}.play;
)
x.set(\t_gate, 1);

(
x = {
	arg gate=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr,gate);
	sig = VarSaw.ar(SinOsc.kr(16).range(500,1000))*env;
}.play;
)
x.set(\gate, 0);

Env.adsr.plot;

Env.new([0.01,1,0.2,0.01], [0.5, 1, 2], [-12,-12,0]).plot;

