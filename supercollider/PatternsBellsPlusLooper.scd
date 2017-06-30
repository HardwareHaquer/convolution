Platform.resourceDir

(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// one loop segment
SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env) ! 2)
}).add;

SynthDef(\bell, { |out, accent = 0, amp = 0.1, decayScale = 1|
    var    exc = PinkNoise.ar(amp)
            * Decay2.kr(Impulse.kr(0), 0.01, 0.05),
        sig = Klank.ar(`[
            { ExpRand(400, 1600) } ! 4,
            1 ! 4,
            { ExpRand(0.1, 0.4) } ! 4
        ], exc, freqscale: accent + 1, decayscale: decayScale);
    DetectSilence.ar(sig, doneAction: 2);
    Out.ar(out, sig ! 2)
}).add;
)



(
TempoClock.default.tempo = 0.35953685899971 * 2;

p = Pbind(
    \instrument, \oneLoop,
    \bufnum, b,
    \amp, 0.4,
    \start, 17841,
    \time, 0.35953685899971.reciprocal,
    \dur, 4
).play(quant: [4, 3.5]);

q = Pn(
    Pfindur(4,
        Pbind(
            \instrument, \bell,
            \accent, Pseq([2, Pn(0, inf)], 1),
            \amp, Pseq([0.3, Pn(0.1, inf)], 1),
            \decayScale, Pseq([6, Pn(1, inf)], 1),
            \dur, Pwrand(#[0.25, 0.5, 0.75, 1], #[2, 3, 1, 1].normalizeSum, inf)
        )
    ),
inf).play(quant: [4, 4]);

r = Pbind(
    \instrument, \bell,
    \accent, -0.6,
    \amp, 0.2,
    \decayScale, 0.1,
    \dur, 1
).play(quant: [4, 4]);
)

[p, q, r].do(_.stop);

b.free;

// make a sound sample
(
var    recorder;
fork {
    b = Buffer.alloc(s, 44100 * 2, 1);
    s.sync;
    recorder = { |freq = 440|
        var    initPulse = Impulse.kr(0),
            mod = SinOsc.ar(freq) * Decay2.kr(initPulse, 0.01, 3) * 5,
            car = SinOsc.ar(freq + (mod*freq)) * Decay2.kr(initPulse, 0.01, 2.0);
        RecordBuf.ar(car, b, loop: 0, doneAction: 2);
        car ! 2
    }.play;
    o = OSCFunc({ |msg|
        if(msg[1] == recorder.nodeID, {
            "done recording".postln;
            o.free;
        });
    }, '/n_end', s.addr);
};
SynthDef(\sampler, { |out, bufnum, freq = 1, amp = 1|
    var    sig = PlayBuf.ar(1, bufnum, rate: freq, doneAction: 2) * amp;
    Out.ar(out, sig ! 2)
}).add;
)

(
// WAIT for "done recording" message before doing this
var    samplerEvent = Event.default.put(\freq, { ~midinote.midicps / ~sampleBaseFreq });

TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pwhite(0, 12, inf),
    \dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
    \amp, Pexprand(0.1, 0.5, inf),
    \sampleBaseFreq, 440,
    \instrument, \sampler,
    \bufnum, b
).play(protoEvent: samplerEvent);
)

p.stop;
b.free;

(
// timing offset = 0
//p = Pbind(\freq, 440, \pan, -1, \delta, 1.0, \sustain, 0.1).play(quant: [2, 0, 0]);
// timing offest = 0.1
q = Pbind(\freq, 220, \pan, Pseq([-1, -0.5,0,0.5, 1, 0.5, 0, -0.5], inf), \delta, 0.5, \sustain, 0.25).play(quant: [2, 0, 0.1]);
)
q.freq(220);
// p's nextBeat is x.0 - q's is x.4 or x.9 (e.g., halves of a beat minus 0.1)
[p.nextBeat, q.nextBeat]

p.stop; q.stop;