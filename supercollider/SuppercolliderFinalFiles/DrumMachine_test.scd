//find audio

//create dictionary

(
var filePath;
//move sounds to suppercollider
//filePath = PathName("/Users/astewart/Google\ Drive/2016_Fall/Convolution/InterfaceCode/supercollider/sounds/SplitSounds");
filePath = PathName(thisProcess.nowExecutingPath.dirname);
filePath = PathName(filePath.pathOnly +/+ "sounds/SplitSounds");
d=Dictionary.new;
d.add(\l ->
	PathName(filePath.fullPath +/+ "/low").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
d.add(\m ->
	//PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/mid").entries.collect({
	PathName(filePath.fullPath +/+ "/mid").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);

d.add(\h ->
	PathName(filePath.fullPath +/+"/high").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);




SynthDef.new(\bufplay, {
	arg buf=0, rate= 1, loop=0, t_trig = 1, amp=1, da=2, sPos=0;
	var sig, startFrame=0;
	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, startPos: sPos, loop: loop, doneAction:da);
	sig = sig * amp;
	Out.ar(0, sig!2);
}).add;

SynthDef(\bufEnv, { arg bus = 0, bufnum = 0, rate = 1, attack=0.01, rel=1, cu = -4;
    Out.ar(
        bus,
        PlayBuf.ar(
            1,
            bufnum,
            BufRateScale.kr(bufnum) * rate
        )
        *
		EnvGen.kr(Env.perc(attack, rel, curve: cu), doneAction: 2)
    !2)
}).add;
)
~bassTest = Pbind(
	\instrument, \bufEnv,
	\degree, Pseq([1,Rest, 1,1,Rest,Rest], inf),
	\scale, Pfunc{~scales},
	\bufnum, d[\h][1].bufnum,
	\rate, ~bassRate,
	\amp, ~bassAmp,
	\attack, ~dmInstAtk[0],
	\cu, ~dmInstSus[0],
	\rel, ~dmInstRel[0],
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~bassTest.stop;
// (-1 < 0).postln;
// ~tested = -0.5;
// if(~tested < 0, {~posed1 = BufFrames.kr(d[\m][1].bufnum)-2}, {~posed1 = 0});
// ~posed1.postln;
// ~posed.value = 0;
// y =Synth.new(\bufplay, [\buf, d[\m][1].bufnum, \rate, 1 ]);
// y.free;
// y.set(\rate, 0.25);
//
// b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
//
// (
// x = { arg rate= -0.5;
// 	BufRd.ar( 1, d[\m][1].bufnum, Phasor.ar(0, BufRateScale.kr(d[\m][1].bufnum) * rate, 0, BufFrames.kr(d[\m][1].bufnum)))
// }.play;
// )
// x.free


 SynthDef(\playBufTest, {| out = 0, bufnum = 0, rate = 1 |
  var scaledRate, player, duration, env;
  scaledRate = rate * BufRateScale.kr(bufnum);
	duration = BufDur.kr(bufnum);
	env = Env([0,1], [0.5]);
	player = PlayBuf.ar(1, bufnum, scaledRate, startPos: 0)*EnvGen.kr(env, doneAction: 2);
  Out.ar(out, player)
 }).play(s, [\out, 0, \bufnum, d[\m][0].bufnum, \rate, -0.1]);
)