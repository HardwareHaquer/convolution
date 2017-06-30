(
x = Array.newClear(7);

[6,4,3,6,8,0.6,17].do{
	arg item, count;
	x[count] = item.squared;
}
)

x;
(
z = [6,4,3,6,8,0.6,17].collect{
	arg item;
	item.squared;
}
)

z = [6,4,3,6,8,0.6,17].collect(_.squared);

x = {VarSaw.ar(40!2, 0, 0.05)}.play;

x.free;

(
SynthDef.new(\iter, {
	arg freq=40, copies = 10;
	var temp, sum, env;
	sum = 0;
	10.do{
		env = EnvGen.kr(
			Env.perc(0.01, 5, 1, -2),
			doneAction:2
		);
		temp = VarSaw.ar(
			freq * {Rand(0.99, 1.02)}!2,  //freq
			{Rand(0.0, 1.0)}!2,                 //phase
			{ExpRand(0.005, 0.05)}!2                                 //duty
		);
		sum = sum + temp;
	};
	sum = sum *0.05 * env;
	Out.ar(0, sum);
}).add;
)

Synth.new(\iter, [\freq, 66.midicps]);
Synth.new(\iter, [\freq, 73.midicps]);
Synth.new(\iter, [\freq, 80.midicps]);
Synth.new(\iter, [\freq, 75.midicps]);

(
[53, 59, 63, 68].do{
	arg midinote;
	Synth.new(\iter, [\freq, midinote.midicps]);
}
)


(
SynthDef.new(\iter2, {
	arg freq=40, copies = 10;
	var temp, sum, env;
	sum = 0;
	10.do{
		arg count;
		env = EnvGen.kr(
			Env.perc(0.01, 30, 1, -2),
			doneAction:2
		);
		temp = SinOsc.ar(
			freq *
			(count +1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(0.98, 1.02)
		);
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum *0.05 * env;
	Out.ar(0, sum);
}).add;
)

Synth.new(\iter2, [\freq, 88.midicps]);
Synth.new(\iter2, [\freq, 36.midicps]);
Synth.new(\iter2, [\freq, 50.midicps]);
Synth.new(\iter2, [\freq, 75.midicps]);