s.boot;
MIDIClient.init;
MIDIIn.connectAll
MIDIClient.disposeClient
x=6.do({|i| i.postln;});
x.free;
(
a = 6.do({ |i|
	MIDIFunc.cc({arg ...args; args.postln}, (9+i)); // match cc 1
});
)
b = MIDIFunc.cc({arg ...args; args.postln}, 9); // match cc 1
b.postln;
a.free; // cleanup
n = MIDIFunc.noteOn({arg ...args; args.postln}); // match any noteOn
n.free; // cleanup
n.msgType
(
var notes, on, off, bend, bendAmount;
bendAmount = 0;
MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
    notes[num] = Synth(\default, [\freq, num.midicps+bendAmount,
        \amp, veloc * 0.00315]);
	num.midicps.postln;
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    notes[num].release;
});

bend = MIDIFunc.bend({|bendVal, chan, src|
	bendAmount = (bendVal-8192)/100;
	"bend ".post;
	bendAmount.postln;

});

q = { on.free; off.free; bend.free};
)

// when done:
q.value;

(
MIDIClient.init;
MIDIIn.connectAll;
)
(
SynthDef("midinotes", { arg pitch=440, trig=0, pitchMod =0;
var sound, env;
sound = SinOsc.ar(pitch+pitchMod);
env = EnvGen.ar(Env.adsr, trig);
Out.ar(0, sound*env);
}).add;
)/*.writeDefFile;
s.sendSynthDef("midinotes");*/

x = Synth("midinotes");
(
MIDIIn.noteOn = { arg src, chan, num, vel;
	x.set("pitch", num.midicps);
	x.set("trig", vel/128);
};
MIDIIn.noteOff = { arg src, chan, num, vel;
	x.set("trig", 0);
};

MIDIIn.bend = { arg src, chan, bend;
	x.set("pitchMod", bend-8192/10);
};
)
x.free;

Server.killAll;
(
a= Pbind(\instrument, \default, \freq, Pseq([[100, 200, 300], [160,
240, 320]], inf), \strum, Pseq([0.1,0.2,0.3], inf), \legato, 0.1, \dur,
0.25).play
)

(x = { |freq = 440|
    //var son = SoundIn.ar;
	var sig = SinOsc.ar(freq, 0, 0.2)*SinOsc.kr(2);
	var env = EnvGen
    var sequence = [0, 4, 7, 10, 12, 10, 7, 4].midiratio;
    var result = PitchShift.ar(sig, 0.2, Duty.kr(0.1, 0, Dseq(sequence, inf)));
    Out.ar(0, result);
}.play
)
x.free
x.set(\freq,880);