s.boot;

(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

s.plotTree;
s.meter(2,8);


(
SynthDef.new("twelver",{
    var n = 12;
        Mix.fill(n, { arg a;
            var freq;
		a.postln;
            freq = 440 + a;
		freq.postln;
            SinOsc.ar(freq , 0, 1 / n)
	})
}).play;
)

SynthDef.new("test", {arg freq=440; Out.ar(0, SinOsc.ar(freq, 0, 0.2)+SinOsc.ar(442, 0, 0.2) + SinOsc.ar(444, 0, 0.2))}).add

SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;


{SinOsc.ar(440 , 0, 0.2)+SinOsc.ar(442, 0, 0.2)+SinOsc.ar(443, 0, 0.2)}.play;

x=Synth.new("test");

Out.ar(x).play;

x.set(\freq, 220);

x.free;

{SinOsc.ar(440,0,0.1)}.scope						//Sine Oscillator goes on forever

{SinOsc.ar(440,0,Line.kr(0.1,0.0,1.0, doneAction:2))}.play	 	//One second for the sine to disappear entirely

Env([1,0,1],[0.1,3]).plot  //This makes an Envelope with three control points, at y positions given by the first array, and separated in x by the values in the second (see the Env help file). The curve drawn out should actually look like a letter envelope!

Env.linen(0.1,0.5,0.1).plot(0.7) //linen has attackTime, sustainTime, releaseTime, level, curve

Env.adsr(0.01, 0.5, 0.5, 0.1, 1.0, 0).plot

Env.perc(0.05,0.5,1.0,0).plot
Env([440,1100,220],[0.5, 6], \welch).plot

Env([1,0],[1.0]).plot

{SinOsc.ar(440,0,0.1)*EnvGen.kr(Env([1,0],[1.0]))}.play

Env([1000,20],[1.0]).plot

({
	Saw.ar(
		EnvGen.kr(Env([2000,200,440],[0.5, 1], \welch)),
	    EnvGen.kr(Env([0.1,0],[2.5]), doneAction:2)
    )
}.play
)

{Saw.ar(SinOsc.ar(1,0,10,440),Line.kr(0,1,1,doneAction:2))}.play

{Saw.ar(SinOsc.ar(1,0,10,440),XLine.kr(0.0001,1,1,doneAction:2))}.play


e = Env([0.0,0.0,1.0,0.0],[0.5,1.0,2.0],0,2,0); //releaseNode at 2, loopNode at 0

a= {arg gate=1; EnvGen.ar(e,gate,doneAction:2)*SinOsc.ar(550,0,0.1)}.play

a.set(\gate, 0); //takes 2.0 seconds to fade out

If you set the envelope looping fast enough, you can get interesting control signals and even head towards audio rate waveforms.

e = Env([0.0,1.0,-1.0,0.0],[0.01,0.01,2.0],0,2,0); //releaseNode at 2, loopNode at 0

e.plot

a= {arg gate=1; EnvGen.ar(e,gate,timeScale:MouseX.kr(0.1,2.0),doneAction:2)}.play

a.set(\gate, 0); //stops immediately since release transition to 0.0 occurs over 2 seconds, too slow to be a pitched oscillation


