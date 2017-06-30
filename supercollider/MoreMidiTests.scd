MIDIClient.init	//should post a list of available devices

MIDIIn.connect(0,MIDIClient.sources[5])
MIDIIn.connect(0,MIDIClient.sources[2])
//first number is port number, second is device from sources list
//MIDIIn.connect //would work on its own but defaults to first port of first device
//MIDIIn.connectAll //connect to all attached input sources

//note the use of a gate; this will sustain until released
(
SynthDef(\sound,{arg freq=440, amp=0.2, gate=1;
	var saw, filter, env;

	saw= Saw.ar(freq);
	filter= Resonz.ar(saw,200,0.1+SinOsc.ar(freq: 600, phase:1)/2)*amp;
	env= EnvGen.ar(Env.asr(0.005,1.0,0.1),gate,doneAction:2);

	Out.ar(0,(filter*env).dup(2))
}).add
)

(
var activenotes = nil!128; //make Array of 128 slots, initially with nil objects in to represent nothing
var releasefunction = {|index|

		//release existing note if present already
	if(activenotes[index].notNil) {
		activenotes[index].release; //will send gate=0
		activenotes[index] = nil; //make sure now empty slot ready
	}

	};

//create one Synth for every new note, with logic to check existing notes (though not MIDI channel sensitive)
MIDIIn.noteOn = { arg src,chan, midinote, velocity;   var freqs = midinote.midicps;

	"received: ".post;
	midinote.midicps.postln;

	releasefunction.value(midinote);

	//put active note in array; function above tidied any existing note on this key
	activenotes[midinote] = (Pbind(\instrument, \sound, \freq, Prand([\rest,1,2,3,0.5,6], 10)*freqs, \dur, [0.05,0.1, 0,0.2].wrapAt(3)).play;
		Pbind(\instrument, \test, \amp, 0.1, \freq, Prand([\rest,1,2,3,0.5,6, 8], 10)*freqs/2, \dur, [0.05,0.1, 0,0.2].wrapAt(3)).play;)//\sound,[\freq,midinote.midicps,\amp,velocity/127.0]);

	};

//must also look for note offs as indicated end of held note
MIDIIn.noteOff = { arg src,chan, midinote, velocity;

	releasefunction.value(midinote);

	};

)

(
//turn off again
MIDIIn.noteOn = nil;
MIDIIn.noteOff = nil;
)

//Just post line to test!!!
(
var activenotes = nil!128; //make Array of 128 slots, initially with nil objects in to represent nothing
var releasefunction = {|index|

		//release existing note if present already
	if(activenotes[index].notNil) {
		activenotes[index].release; //will send gate=0
		activenotes[index] = nil; //make sure now empty slot ready
	}

	};

//create one Synth for every new note, with logic to check existing notes (though not MIDI channel sensitive)
MIDIIn.noteOn = { arg src,chan, midinote, velocity;   var freqs = midinote.midicps;

	"received: ".post;
	midinote.post;
	" Vel: ".post;
	velocity.postln;

	releasefunction.value(midinote);

	//put active note in array; function above tidied any existing note on this key
	//activenotes[midinote] = Synth(\warble, [\imp, midinote*10]); //Synth(\test,[\freq,midinote.midicps,\amp,velocity/127.0]);
	activenotes[midinote] = Synth(\test,[\freq,midinote.midicps,\amp,velocity/127.0]);
	};

//must also look for note offs as indicated end of held note
MIDIIn.noteOff = { arg src,chan, midinote, velocity;

	releasefunction.value(midinote);

	};

)

(
//turn off again
MIDIIn.noteOn = nil;
MIDIIn.noteOff = nil;
)
(
var freqs=400;
Pbind(\instrument, \test, \freq, Prand([1,2,0.5,6,4], 20)*200, \dur, 0.1).play;
)

"ls -l".unixCmd
(
SynthDef(\many, { Synth(\funSynth, [pitch:300.rrand(600), rel: 1, mult:0.2]);}).add
)

(
SynthDef(\funSynth, {
	arg pitch = 200, att=0.01, sus = 0.1, rel = 1, mult=0.2, gate = 1;
	var sound = Saw.ar(pitch, mul: mult);
	var linen = Env.linen(att, sustainTime:sus, releaseTime:rel);
	var env = EnvGen.kr(linen, doneAction:2, gate: gate);
	Out.ar(0, FreeVerb.ar((sound * env), 0.25, 0.15, 0.5));
}).add;
)


(
// a SynthDef
SynthDef(\test, { | out, freq = 440, amp = 0.01, nharms = 10, pan = 0, gate = 1 |
	    var audio = Blip.ar(freq, nharms, amp);//*LFNoise1.kr(3, 0.3);
	//var effect = CombC.ar(audio, 0.1, 0.4, 5, 0, 0.5);
    var env = Linen.kr(gate, susLevel: 0.8, doneAction: 2);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
)
(
//Pbind(\instrument, \test, \freq, Pseq([1, \rest, \rest, 2.5,\rest, 4], 10) * 100, \dur, 0.25).play;
Pbind(\instrument, \sound, \freq, Pseq([\rest, 3, \rest, 3,\rest, 1, 6], 10) * (400), \dur, 0.25).play;
)

x ={Dust.ar(MouseX.kr(1,100))}.play
x.free;
(
{
	[
	LFNoise0.ar(100),	//step
	LFNoise1.ar(100),	//linear interpolation
	LFNoise2.ar(400)	//quadratic interpolation
	]
}.plot(0.1)
)
y={LFNoise2.ar(400)}.play
{SinOsc.ar(400,mul: 0.2)}.play
y.free;

(
SynthDef("help-Dust", { arg out=0;
    Out.ar(out,
        Dust.ar(XLine.kr(20000, 2, 10, doneAction: 2), 0.5)
    )
}).play;
)

x = {Pbind(\instrument, \test, \freq, Pseq([\rest, 3, \rest, 3,\rest, 1, 6], 10) * (220), \dur, 0.25).play;}.play
x.free;
{ LFGauss.ar(XLine.kr(0.1, 0.001, 10), 0.03) * 0.2 }.play;
{ LFGauss.ar(1/60, XLine.kr(0.1, 0.001, 10)) * 0.2 }.play;
{ LFGauss.ar(MouseX.kr(1, 0.001, 1), 0.1) * SinOsc.ar(1000) * 0.1 }.play;

(
{
    var son = LeakDC.ar(LFGauss.ar(0.005, 0.2));
    BPF.ar(son * 3, MouseX.kr(60, 2000, 1), 0.05)
}.play;
)

{ LFGauss.ar(0.01, SampleDur.ir * MouseX.kr(10, 3000, 1)) * 0.2 }.play;

{ LFGauss.ar(MouseX.kr(1/8000, 0.1, 1), MouseY.kr(0.001, 0.1, 1)) * 0.1 }.play;

(
plot({
    var z;
    z = Dust.ar(1000);
    [z, z - Delay1.ar(z)]     // [ original, subtract delayed from original ]
}))

{ CombN.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

{ CombC.ar(Decay.ar(SinOsc.ar), 0.2, 0.8, 1.5) }.play;


(
{ SinOsc.ar(
        LFNoise1.ar(4, 400, 450),
        0, 0.2
    )
}.play;
)

{ LFNoise1.ar(LFNoise2.ar(4, 400, 450), 0.25) }.play;

{Impulse.ar(MouseX.kr(1,100))}.play

{ Stepper.ar(Impulse.ar(100), 0,1,10,1) }.plot(0.3,minval:0,maxval:10);
(
SynthDef("warble", { arg imp = 100, gate = 1;
	var audio = SinOsc.ar(Stepper.ar(Impulse.ar(imp), 0,1,1000,1)*10,0,0.1);
	var env = Linen.kr(gate, susLevel: 0.8, doneAction: 2);
	Out.ar(0, (audio*env)!2);
};).add;
)
{ SinOsc.ar(Stepper.ar(Impulse.ar(100), 0,1,10,1)*100,0,0.1) }.play

{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(6,0.1),0,0,7,1),[72,63,67,72,55,62,63,60].midicps),0.1) }.play

(
{
	var source = SinOsc.ar(200);
	//plot both original signal, and the trigger pattern
	[source, Trig.ar(source,0.001)]

	}.plot(0.1)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(source, 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(source- Delay1.ar(source), 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)

{Latch.ar(SinOsc.ar(133), Impulse.ar(100))}.plot(0.5)
{Latch.ar(LFNoise2.ar(100), Impulse.ar(100))}.plot(0.1) //removes smoothing!

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(56.2), Impulse.ar(2))))*0.2}.play

 {EnvGen.ar(Env([0,1,0],[0.01,0.01]),Impulse.kr(50))}.plot(0.1)
{EnvGen.ar(Env([0,1,0,0.5,-0.4],0.01!4),Impulse.kr(25))}.plot(0.1)

{SinOsc.ar(600*(1+EnvGen.ar(Env([0,1,0,0.5,-0.4],0.1!4,curve:\step),Impulse.kr(2.5))))}.play
(

	{SinOsc.ar(EnvGen.ar(Env([63,63,60,55,60],0.125!4,curve:\step),Impulse.kr(2)).midicps)}.play;


)

//percussive sound retriggered 3 times a second
(
{
var sound,env, trig;

trig= Impulse.ar(3); //trigger source

sound= Mix(LFPulse.ar(50*[1,7/2],0.0,0.5,0.1));

env= EnvGen.ar(Env.perc(0.02,1),trig); //with retriggering controlled by impulse

Pan2.ar(sound*env,0.0)
}.play
)

//value of third frequency component is a new random number with each trigger
(
{
var sound,env, trig;

//> is itself a UGen when used in this context; it is outputting the result of comparing the LFNoise0 with the value 0 every sample!
trig= LFNoise0.ar(13)>0; //trigger source (might also use Dust, for example)

//TRand chooses a random number in its range when triggered
sound= Mix(LFPulse.ar(110*[1,5/2,TRand.ar(3.9,4.1,trig)],0.0,0.5,0.2));

env= EnvGen.ar(Env.perc(0.02,0.1),trig); //with retriggering controlled by impulse

Pan2.ar(sound*env,0.0)
}.play
)

(
var a, b;
a = Pbind(\note, Pseq([7, 4, 0], 4), \dur, Pseq([1, 0.5, 1.5], inf));
b = Pbind(\note, Pseq([5, 10, 12], 4), \dur, 1);
Ptpar([ 0.0, a, 1.3, b ]).play;
)