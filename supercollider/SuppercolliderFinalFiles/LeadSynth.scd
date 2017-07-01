(
~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);
~ampOscGroup = Group.after(~fxGroup);
)
~srcGroup.freeAll;
~srcGroup = Group.before(~fxGroup);
s.killAll
s.quit;
s.freeAll
s.reboot
Scale.pelog.ratios.postln;
Scale.directory
s.plotTree;
s.meter;
~scale.postln;
~scale = Scale.minorPentatonic;
~scale.postln;
~coreNote = 58;
~coreNote = 50;
440.midinote
Scale.major.degrees.wrapAt(12)
Scale.major.degreeToFreq(0, 72.midicps, 1);
Scale.minor.degreeToFreq(0, 57.midicps, 1);
(1 / Scale.minorPentatonic.degrees.size).round.postln
Scale.major.degrees.size
1 % 5
(
a = {|a,b|
	if(a > b, {(a-b).postln} , {(b-a).postln});
};
)
a.value(15,10);
(

var notes, on, off;
~coreNote = 57;
~noteOn;
~noteOff;
~knobs;
~root;
~degree;
~scale = Scale.major;
~root = 0;
notes = Array.newClear(128);
on = OSCdef(\testNoteOn, { |msg|
	var frqa, frqb, frqc, steps, padNum, index, oct, freq;
	~noteOn = msg;
	(~noteOn[1] / ~scale.degrees.size).postln;
	oct = (~noteOn[1] / ~scale.degrees.size).trunc;
	index = ~noteOn[1] %  ~scale.degrees.size;
	freq = ~scale.degreeToFreq(index, ~coreNote.midicps, 1+oct);
	~noteOn[1].post;
	"<==noteOn oct==>".post;
	oct.postln;
	~scale.degrees[index].postln;
	freq.postln;
	"=============".postln;

	notes[~noteOn[1]] = Synth(\am1,[\freq, freq, \out, 0],/* [\pitch, ~noteOn[2].midicps, \trig, ~noteOn[3]/128, \out, ~reverbBus],*/ ~srcGroup);

}, "/keyOn");

off = OSCdef(\testNoteOff, { |msg|
	~noteOff = msg;
	//~noteOff.postln;
	notes[~noteOff[1]].set(\trig, 0);
	notes[~noteOff[1]].release;
	//x.set("trig", 0);

}, "/keyOff");

~oldmsg = 0;
OSCdef(\encoder, { |msg|
	//~root = msg[1]-4;
	//if(msg[1] != ~oldmsg,{(msg[1].clip(0,120)).postln});// {(msg[1].min(8)-3).postln});
	if(msg[1] < ~oldmsg,
		{~coreNote= ~coreNote - 1; ~coreNote.postln;},
		{if(msg[1] > ~oldmsg,
			{~coreNote = ~coreNote + 1; ~coreNote.postln;})});
	~oldmsg = msg[1];
	//~coreNote.postln;
	~coreNote = ~coreNote.clip(1, 99);

}, "/rawEnc");

OSCdef(\scale, { |msg|
	~scale = Scale.at(Scale.names[msg[1]]);
	if(msg[1] != ~oldmsg, {msg[1].postln});
	~oldmsg = msg[1];
	~scale.name.postln;

}, "/scale");

q = { on.free; off.free};
)

(
OSCdef(\setRoot, { | msg |
	//~coreNote = msg[1];
	//~rootNote = ~coreNote-60;
	"rootN0ote :".post;
	//~rootNote.postln;
}, "/root");
)

(
SynthDef("oscnotes", { arg out, pitch=440, trig=0, pitchMod =0, amp = 0.5, atk=0.01, releaseTime=1;
var sound, env;
sound = SinOsc.ar(pitch+pitchMod);
	env = EnvGen.ar(Env.adsr(releaseTime: releaseTime), trig, doneAction: 2);
Out.ar(out, sound*env*amp);
}).add;




(
SynthDef("am1", {arg freq = 200, modfreq = 5, amp = 0.4, att = 0.01, rel = 3, out;
    var carrier, modulator, env;
    env = Env.perc(
        attackTime: att,
        releaseTime: rel,
        level: amp
    ).kr(2);
    modulator = SinOsc.ar(modfreq).range(0, 1);
    carrier = SinOsc.ar(freq: freq, mul: env * modulator);
    Out.ar(out, carrier ! 2);
}).add;
)

