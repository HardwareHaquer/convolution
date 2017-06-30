(
s.startAliveThread;
ServerBoot.add { s.initTree };
)
s.boot

{[SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)]}.play;

f = { "Evaluating...".postln; 2 + 3; };
f.value;
f.value;

g=3;
g.value;

g={3.0.rand;};
g.value;

f={arg a; a.value + 3};
f.value(3);
f.value(g);
f.value(g);

(
f={arg a, b; b+(a*b);};
f.value(5,3);
)

(
f={|a, b|
	var firstResult, finalResult;
	firstResult = a+b;
	finalResult = firstResult*2;
	finalResult;
};
f.value(5,3);
)

(
var myFunc;
myFunc = { |input| input.postln; };
myFunc.value("foo");    // arg is a String
myFunc.value("bar");
)

myFunc;

{[SinOsc.ar(100, 0, 1),SinOsc.ar(300, pi, 0.2)]}.plot;

(
{ var ampOsc, freqOsc;
	ampOsc = SinOsc.kr(1, 1.5pi, 0.5,0.5);
	freqOsc = SinOsc.ar(100, 0.3, 1.0);
	SinOsc.ar(330, 0, ampOsc);
}.play;
{ var ampOsc;
	ampOsc = SinOsc.kr(4, 1.25pi, 0.5,0.5);

	SinOsc.ar(440, 0, ampOsc);
}.play;
)

a= ["foo", "bar"];
a.at(0);
a.at(1);
a.at(2);

{[SinOsc.ar(440,0,0.2), SinOsc.ar(442, 0, 0.2)]}.play

{SinOsc.ar([440,442],0,0.2)}.play
(
{ var freq;
	freq = [[660,880], [440,660],[1320,880]].choose;

	SinOsc.ar(freq, 0, 0.2);
}.play;
)

{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;
//adding UGens together
{PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2)}.play;

// one channel Mix
{ Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]).postln }.play;

// combine two stereo arrays
(
{
    var a, b;
    a = [SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    b = [SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)

(
    var n = 8;
    { Mix.fill(n, { SinOsc.ar(500 - 500.0.rand, 0, 1 / n) }) }.play;
)

// Look at the post window for frequencies and indices
(
    var n = 12;
    {
        Mix.fill(n, { arg a;
            var freq;
		//            a.postln;
            freq = 440 + a;
		//             freq.postln;
            SinOsc.ar(freq , 0, 1 / n)
        })
    }.play;
)

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.scope;
s.scope;

{ SinOsc.ar(440, 0, 0.2) }.play;
play({ SinOsc.ar(440, 0, 0.2) });

//SynthDef

{ SinOsc.ar(440, 0, 0.2) }.play;

// now here's an equivalent SynthDef
SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;
(
SynthDef.new("tut-stereo-SinOsc", {var outArray;
	outArray = [SinOsc.ar(440,0,0.2), SinOsc.ar(442,0,0.2)];
	Out.ar(0, outArray)
}).play;
)

(
SynthDef.new("oct-test", {var n = 8;
	Out.ar(0, Mix.fill(n, { SinOsc.ar(500 - Rand(0,500), 0, 1 / n) }))
}).add;
)

(
SynthDef.new("oct-test2", {var n = 8; var smush, ampOsc;
	ampOsc = SinOsc.kr(1, 1.5pi, Rand(0,0.5),0.5);
	smush = Mix.fill(n, { SinOsc.ar(500 - Rand(0,500), 0, 1 / n) });
	Out.ar(0, smush * ampOsc)
}).add;
)


x = Synth.new("oct-test");
y = Synth.new("oct-test2");
x.free; y.free;


x = { SinOsc.ar(660, 0, 0.2) }.play;
y = SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;
x.free;
y.free;

// execute first, by itself
SynthDef.new("tutorial-PinkNoise", { Out.ar(0, PinkNoise.ar(0.3)) }).add;
x = Synth.new("tutorial-PinkNoise");
y = Synth.new("tutorial-PinkNoise");
x.free; y.free;

// Now with a SynthDef. No randomness!
SynthDef("tutorial-NoRand", { Out.ar(0, SinOsc.ar(440 + 200.rand, 0, 0.2)) }).add;
x = Synth("tutorial-NoRand");
y = Synth("tutorial-NoRand");
z = Synth("tutorial-NoRand");
x.free; y.free; z.free;

// With Rand, it works!
SynthDef("tutorial-Rand", { Out.ar(0, SinOsc.ar(Rand(440, 660), 0, 0.2)) }).add;
x = Synth("tutorial-Rand");
y = Synth("tutorial-Rand");
z = Synth("tutorial-Rand");
x.free; y.free; z.free;

(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
x = Synth("tutorial-args");                // no args, so default values
y = Synth("tutorial-args", ["freq", 660]);        // change freq
z = Synth("tutorial-args", ["freq", 880, "out", 1]);    // change freq and output channel
x.free; y.free; z.free;

x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.set("freq", 440, "out", 0);
x.free;

"a String" === "a String"
\aSymbol === \aSymbol

(
// use input amplitude to control SinOsc frequency
{
    SinOsc.ar(
            Amplitude.kr(
                        Blip.ar(3, 20) * LFNoise1.kr(0.1).range(0, 1),
                        MouseX.kr(0.001, 1, 1),
                        MouseY.kr(0.001, 1, 1),
                        1200,
                        400
            ),
            0, 0.3)
}.play;
)

In.ar(0, 1); // this will return 'an OutputProxy'
In.ar(0, 4); // this will return 'an OutputProxy'

// This throws an error. Can't write a control rate signal to an audio rate bus
{Out.ar(0, SinOsc.kr)}.play;

// This will work as the audio rate signal is downsampled to control rate
{Out.kr(0, SinOsc.ar)}.plot;

(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
// both write to bus 1, and their output is mixed
x = Synth("tutorial-args", ["out", 1, "freq", 660]);
y = Synth("tutorial-args", ["out", 1, "freq", 770]);

s.reboot; // this will restart the server and thus reset the bus allocators
(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

b = Bus.control(s, 2);    // a 2 channel control Bus
b.index;         // this should be zero
b.numChannels         // Bus also has a numChannels method
c = Bus.control(s);
c.numChannels;        // the default number of channels is 1
c.index;        // note that this is 2; b uses 0 and 1



(
SynthDef("tutorial-Infreq", { arg bus, freqOffset = 0;
    // this will add freqOffset to whatever is read in from the bus
    Out.ar(0, SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5));
}).add;

SynthDef("tutorial-Outfreq", { arg freq = 400, bus;
    Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
}).add;

b = Bus.control(s,1);
)

(
x = Synth.new("tutorial-Outfreq", [\bus, b]);
y = Synth.after(x, "tutorial-Infreq", [\bus, b]);
z = Synth.after(x, "tutorial-Infreq", [\bus, b, \freqOffset, 300]);
)
x.free; y.free; z.free; b.free;

//big complex effect bus
(
// the arg direct will control the proportion of direct to processed signal
SynthDef("tutorial-DecayPink", { arg outBus = 0, effectBus, direct = 0.5;
    var source;
    // Decaying pulses of PinkNoise. We'll add reverb later.
    source = Decay2.ar(Impulse.ar(1, 0.25), 0.01, 0.2, PinkNoise.ar);
    // this will be our main output
    Out.ar(outBus, source * direct);
    // this will be our effects output
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef("tutorial-DecaySin", { arg outBus = 0, effectBus, direct = 0.5;
    var source;
    // Decaying pulses of a modulating sine wave. We'll add reverb later.
    source = Decay2.ar(Impulse.ar(0.3, 0.25), 0.3, 1, SinOsc.ar(SinOsc.kr(0.2, 0, 110, 440)));
    // this will be our main output
    Out.ar(outBus, source * direct);
    // this will be our effects output
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef("tutorial-Reverb", { arg outBus = 0, inBus;
    var input;
    input = In.ar(inBus, 1);

    // a low-rent reverb
    // aNumber.do will evaluate its function argument a corresponding number of times
    // {}.dup(n) will evaluate the function n times, and return an Array of the results
    // The default for n is 2, so this makes a stereo reverb
    16.do({ input = AllpassC.ar(input, 0.04, { Rand(0.001,0.04) }.dup, 3)});

    Out.ar(outBus, input);
}).add;

b = Bus.audio(s,1); // this will be our effects bus
)

(
x = Synth.new("tutorial-Reverb", [\inBus, b]);
y = Synth.before(x, "tutorial-DecayPink", [\effectBus, b]);
z = Synth.before(x, "tutorial-DecaySin", [\effectBus, b, \outBus, 1]);
)

// Change the balance of wet to dry
y.set(\direct, 0.25); // only direct PinkNoise
z.set(\direct, 1); // only direct Sine wave
y.set(\direct, 0.5); // only direct PinkNoise
z.set(\direct, 0.5); // only direct Sine wave
y.set(\direct, 0); // only reverberated PinkNoise
z.set(\direct, 0); // only reverberated Sine wave
x.free; y.free; z.free; b.free;

(
b=Bus.control(s,1); b.set(880);
c=Bus.control(s,1); c.set(884);

x=SynthDef("tutorial-map", {arg freq1 =440, freq2 = 440;
	Out.ar(0, SinOsc.ar([freq1,freq2],0,0.1));
}).play(s);
)
x.map(\freq1, b, \freq2, c);

y={Out.kr(b, SinOsc.kr(1,0,50,880))}.play(addAction: \addToHead);

y.free;

b.get({arg val; val.postln; f=val;});

x.set(\freq2, f/2);

b.set(200);

x.free; b.free; c.free;

// make a Bus object and set its values
b = Bus.control(s, 1); b.set(880);

// execute this altogether
(
f = nil; // just to be sure
b.get({ arg val; f = val; f.postln });
//f.postln;
)
f.postln;

Server.killAll;