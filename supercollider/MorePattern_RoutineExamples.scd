(
a = Routine{
	var i=0;
	loop{
		i.yield;
		i=i+1;
	};
};
)

a.nextN(10);
(
a = Routine{
	(0..).do{|i|
		i.yield;
	};
};
)

a = Pseries(start:0,step:5,length:inf).asStream;

a.nextN(10);

p = Pseries(0, 1, 10);
p.next;    // always returns the Pseries, not actual numbers

q = p.asStream;
q.next;    // calling this repeatedly gets the desired increasing integers
r = p.asStream;
r.next;    // calling this repeatedly gets the desired increasing integers
[r.next, q.next]
Pseq(#[1,2,3],4).asStream.all;
Pser(#[1,2,3],4).asStream.all;

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 1], 1)
).play;
)

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, true).asStream.all;
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, true).clump(3).asStream.all;
Pslide( (-6, -4 .. 12), 8, 3, 1, 0).clump(3).asStream.all;

// Flock of Seagulls!
(
p = Pbind(
    \degree, Pslide( (-6, -4 .. 12), 8, 3, 1, 0),
    \dur, Pseq(#[0.02, 0.01, 0.01], inf),
    \sustain, 0.05
).play;
)

// Prand: given scale degrees (pentatonic) with equal probability of each
(
p = Pbind(
    \degree, Prand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
p.stop;
// Pxrand: same as above but never repeats a pitch twice in a row
(
p = Pbind(
    \degree, Pxrand([-4,-2, 0, 1, 2, 4, 5, 7], inf),
    \dur, 0.125
).play;
)

// Pshuf: randomly ordered once and repeated
(
p = Pbind(
    \degree, Pshuf([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)

// Pwrand: these probabilities favor triadic notes from scale degrees
(
p = Pbind(
    \degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
    \dur, 0.25
).play;
)
p.stop;

Place([0, [1, 2], [3, 4, 5]], 3).asStream.all;
Ppatlace([Pseries(0,1,8), Pseries(2,1,7)], inf).clump(2).asStream.all;
// Hanon exercise
(
p = Pbind(
    \degree, Ppatlace([
        Pseries(0, 1, 8),    // first, third etc. notes
        Pseries(2, 1, 7)    // second, fourth etc. notes
    ], inf),
    \dur, 0.25
).play;
)

// Chords
// \degree receives [7, 9, 4], then [6, 7, 4] successively, expanded to chords on the server
(
p = Pbind(
    \degree, Ptuple([
        Pseries(7, -1, 8),
        Pseq([9, 7, 7, 7, 4, 4, 2, 2], 1),
        Pseq([4, 4, 4, 2, 2, 0, 0, -3], 1)
    ], 1),
    \dur, 1
).play;
)

// Use Pseries for a scale and Pgeom for an accelerando
(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)

Pmeanrand(0.0, 1.0, inf).asStream.nextN(10000).histo(200, 0.0, 1.0).plot;

(
p  = Pbind(
	\degree, Pseq(#[0,0,4,4,5,5,4],1),
	\dur, Pseq(#[0.5,0.5,0.5,0.5,0.5,0.5,1],1)
).asStream;
)

p.next(Event.new);

( 'degree': 0, 'dur': 0.5 ).play;

p = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1).play;
p.stop;
p = Pmono(\default, \degree, Pwhite(0, 7, inf)+3, \dur, 0.25).play;
p.stop;


(freq: 293.3333, amp: 0.2, pan: -0.7).play;
(freq: 440, amp: 0.1, pan: 0.7).play;

(
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    // see below for more on .add
)
(
p = Pbind(
        // Use \harpsi, not \default
    \instrument, \harpsi,
    \degree, Pseries(0, 1, 8),
    \dur, 0.25
).play;
)
(
p = Pbind(
    \degree, Pwhite(0, 11, inf),
        // odd numbered scale degrees get a shorter rhythmic value
    \dur, Pif(Pkey(\degree).odd, 0.25, 0.5)
).play;
)
p.stop;

(
// first, pitches ascending by 1-3 semitones, until 2 octaves are reached
var    pitches = Pseries(0, Pconst(24, Pwhite(1, 3, inf)), inf).asStream.all,
        // randomly block 1/3 of those
    mask = pitches.scramble[0 .. pitches.size div: 3];

p = Pbind(
    \arpeg, Pseq(pitches[ .. pitches.size - 2] ++ pitches.reverse[ .. pitches.size - 2], inf),
        // if the note is found in the mask array, replace it with Rest
        // then that note does not sound
    \note, Pif(Pfunc { |event| mask.includes(event[\arpeg]) }, Rest, Pkey(\arpeg)),
    \octave, 4,
    \dur, 0.0675
).play;
)
p.stop;

(
SynthDef(\trig_demo, { |freq, gate = 1, t_trig = 1|    // t_trig here
    var    env = Decay2.kr(t_trig, 0.01, 0.02),
        sig = SinOsc.ar(freq, 0, env)
            * Linen.kr(gate, 0.01, 0.4, 0.01, doneAction: 2);
    Out.ar(0, sig ! 2)
}).add;
)

(
p = Pmono(\trig_demo,
    \freq, Pexprand(200, 800, inf),
    \trig, 1,    // note that this is NOT t_trig -- just \trig
    \delta, 0.125
).play;
)

p.stop;

{Decay2.kr(1, 0.01, 0.1)}.plot;

(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, 0.25
).play;
)

p.stop;

(
SynthDef(\bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 800, width = 0.8,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
		        \midinote, Pseq([60,40,60,43],2),
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

p.stop;

Array.series(5, 0, 3).postln;

// Uses the bass SynthDef above
(
~phrases = (
    repeated: Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    octave: Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    tritone: Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    dim: Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
);

TempoClock.default.tempo = 90/60;

// the higher level control pattern is really simple now
p = Psym(Pxrand(#[repeated, octave, tritone, dim], inf), ~phrases).play;
)

p.stop;

(
p.stop;
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pswitch1([Pwhite(7, 14, inf), Pwhite(-7, 0, inf)], Pfunc { 0.3.coin.binaryValue }),
    \dur, 0.25
).play;
)

(
p = Pbind(
    \degree, Pswitch([Pwhite(7, 14, 5), Pwhite(-7, 0, 5)], Pfunc { 0.7.coin.binaryValue }),
    \dur, 0.25
).play;
)

p.stop;

(Pseq([10, 9, 8], 1) + Pseq([1, 2,12,5], 1)).do { |x| x.postln };
(Pwhite(1, 5, inf) * Prand([-1, 1], inf)).asStream.nextN(10);

// Play a major-7th arpeggio, transposed to different scale degrees
// Pwhite is the transposer; Pseq is the chord
// The chord is like an "inner loop"
(
p = Pbind(
	\instrument, \bass,
    \midinote, Pwhite(48, 60, inf) +.x Pseq([0, 4, 7, Rest], 1),
    \dur, 0.25,
	\amp, Pseq([0.3,0.8,0.3, 0.8,0.3, 0.8, 0.3, 0.8], inf);
).play;
)

p.stop;


// Swing notes with Prorate
(
p = Pbind(
    \degree, Pseries(4, Pwhite(-2, 2, inf).reject({ |x| x == 0 }), inf).fold(-7, 11),
    \dur, Prorate(0.5, 0.6)    // actually yields 0.3, 0.2, 0.3, 0.2...
).play;
)

p.stop;

(
p = Pbind(
        // making 'n' a separate stream so that degree and dur can share it
    \n, Pwhite(3, 10, inf),
    \degree, Pstutter(Pkey(\n), Pwhite(-4, 11, inf)),
    \dur, Pstutter(Pkey(\n), Pwhite(0.1, 0.4, inf)),
    \legato, 0.1
).play;
)
p.stop;

// using Pfin / Pn
// Pn loops the Pbind infinitely
// Plazy builds a new Pbind for each iteration
// Pfin cuts off the Pbind when it's time for a new value

(
p = Pn(
    Plazy {
        Pbind(
            \degree, Pfin(rrand(3, 10), rrand(-4, 11)),
            \dur, rrand(0.1, 0.4)
        )
    },
    inf
).play;
)
p.stop;

// This is a really useful trick: like Pfindur but for value patterns
(
p = Pbind(
    \degree, Pif(Ptime(inf) < 4.0, Pwhite(-4, 11, inf)),
    \dur, 0.25
).play;
)

// curve is 5 - here's what the curve looks like, ascending first then descending
Env(#[0, 1, 0], #[1, 1], 5).plot;

(
p = Pbind(
        // using \note b/c Pseg will give fractional note numbers
        // can't use \degree because it handles non-integers differently
    \note, Pseg(
        //Pwhite(-7, 19, inf),    // chromatic note numbers
            // alternate version for diatonic numbers
            // PdegreeToKey does the same conversion as \degree --> \note
        PdegreeToKey(Pwhite(-4, 11, inf), Pkey(\scale), 12),
        Pwhite(1, 4, inf) * 0.5,
        5, inf),
    \dur, 0.125
).play;
)

p.stop;

// Use an envelope to pan notes from left to right and back
p = Pbind(
    \degree, Pwhite(-4, 11, 32),
    \pan, Env(#[-1, 1, -1], #[2, 2], \sin),
    \dur, 0.125
).play;

p.stop;

//function composition

f = { |x| x + 1 };
g = { |x| x * 2 };

h = (g <> f);

h.value(1);
h.value(10);

~rhythm = Pbind(
    \dur, Pwrand(#[0.125, 0.25, 0.5], #[0.3, 0.5, 0.2], inf),
    \legato, Pwrand(#[0.1, 0.6, 1.01], #[0.1, 0.3, 0.6], inf)
);
~melody = Pbind(
    \degree, Pwhite(-4, 11, inf)
);

p = Pchain(~melody, ~rhythm).play;
p.stop;

~rhythm = EventPatternProxy(Pbind(
    \dur, Pwrand(#[0.125, 0.25, 0.5], #[0.3, 0.5, 0.2], inf),
    \legato, Pwrand(#[0.1, 0.6, 1.01], #[0.1, 0.3, 0.6], inf)
));

~melody = EventPatternProxy(Pbind(
    \degree, Pwhite(-4, 11, inf)
));

p = Pchain(~melody, ~rhythm).play;

~melody.source = PmonoArtic(\default, \degree, Pseries(4, Prand(#[-1, 1], inf), inf).fold(-4, 11));

~melody.source = Pbind(\degree, Pseries(4, Pwrand(#[-2, -1, 1, 2], #[0.3, 0.2, 0.2, 0.3], inf), inf).fold(-4, 11));

p.stop;

p = Pbind(
        // array is "multichannel expanded" into one Synth each
    \degree, #[2, 5, 8, 11, 13, 16, \rest, 16, 13,11,8,5,2],
    \octave, 3,
    \dur, 2,
    \sustain, 3,
        // non-zero strum staggers the entrances
    \strum, 0.3
).play(quant: 1);

p.stop;

(
TempoClock.default.tempo = 84/60;

p = Pbind(
    \scale, #[0, 2, 3, 5, 7, 8, 10],
	    \root, 2,
    \degree, Pseq(#[rest, 4, 3, 4, 2, 4, 1, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2, 4,
        -3, 4, -1.9, 4, -0.9, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2], 1),
    \dur, 0.25
).play;
)
