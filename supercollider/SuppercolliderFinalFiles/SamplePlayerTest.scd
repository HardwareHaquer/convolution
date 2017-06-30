(
// read a soundfile from disk
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// a samplePlayer in mono ... one channel only
SynthDef("aMonoSamplePlayer", { arg bus = 0, bufnum = 0, rateScale = 1, attack=0.01, rel=1, cu = -4;
    Out.ar(
        bus,
        PlayBuf.ar(
            1,
            bufnum,
            BufRateScale.kr(bufnum) * rateScale
        )
        *
		EnvGen.kr(Env.perc(attack, rel, curve: cu), doneAction: 2)
    !2)
}).add;
)

b.free;
//sine(BufDur.kr(bufnum))
(
// test the synthdef ... does it work? (yes, it's fine. it plays on the left channel)
x = Synth("aMonoSamplePlayer", [\attack,0.001, \rel, 3, \bus, 0, \bufnum, d[\h][3], \cu, 0, \rateScale, 0.1]);
//y = Synth("aMonoSamplePlayer", [\attack,0.01, \rel, 2, \bus, 1, \bufNum, b, \cu, 12, \rateScale, 2]);
)
d[\m][1].postln
x =Synth("aMonoSamplePlayer", [\attack,0.05, \rel, 0.1,\bus, 0, \bufnum, b, \rateScale, 4, \cu, 8]);
x.free;
(
SynthDef.new(\bufEnv, {
	arg buf=0, rate= 1, loop=0, t_trig = 1, amp=1, da=0, sPos=0, attack = 0.01, sus = 1, rel = 1, gate=1;
	var sig, startFrame=0;
	var ampEnv = EnvGen.kr(Env.linen( attack, sus, rel, amp, \welch), gate, doneAction:2); //sine(BufDur.kr(buf)));
	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, startPos: sPos, loop: loop, doneAction:da);
	sig = sig * ampEnv;
	Out.ar(0, sig!2);
}).add;
)

(
~bassTest = Pbind(
	\instrument, \bufEnv,
	\degree, Pseq([1,Rest, 1,1,Rest,Rest], inf),
	\scale, Pfunc{~scales},
	\buf, d[\m][2].bufnum,
	\rate, ~bassRate,
	\amp, ~bassAmp,
	\attack, ~dmInstAtk[0],
	\sus, ~dmInstSus[0],
	\rel, ~dmInstRel[0],
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);
)

s.plotTree;
~bassTest.stop;