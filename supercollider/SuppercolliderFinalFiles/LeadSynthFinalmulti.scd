(
//remove all of the damn postlns!
var notes, on, off;
~srcGroup = Group.new;
~fxGroup = Group.after(~srcGroup);
~ampOscGroup = Group.after(~fxGroup);

~leadNames = [\am1, \simpleSine];
~leadSynths = Array.newClear(~leadNames.size);
~curSynth=1;
~coreNote = 57;
~noteOn;
~noteOff;
~knobs;
~root;
~degree;
~leadKnobs;
~scale = Scale.major;
~root = 0;
notes = Array.newClear(128);
on = OSCdef(\testNoteOn, { |msg|
	var frqa, frqb, frqc, steps, padNum, index, oct, freq;
	~noteOn = msg;
	//(~noteOn[1] / ~scale.degrees.size).postln;
	oct = (~noteOn[1] / ~scale.degrees.size).trunc;
	index = ~noteOn[1] %  ~scale.degrees.size;
	freq = ~scale.degreeToFreq(index, ~coreNote.midicps, 1+oct);
	/*~noteOn[1].post;
	"<==noteOn oct==>".post;
	oct.postln;
	~scale.degrees[index].postln;
	freq.postln;
	"=============".postln;*/

	if(~theMode == 1,
		{
			notes[~noteOn[1]] = Synth(~leadNames[~curSynth],[\freq, freq, \modFreq, ~leadKnobs[2], \att, ~leadKnobs[0], \rel, ~leadKnobs[1], \amp, ~leadKnobs[5], \gate, 1, \out, 0, \curv, ~leadKnobs[3]], ~srcGroup);});
		NodeWatcher.register(notes[~noteOn[1]] );

}, "/keyOn");

off = OSCdef(\testNoteOff, { |msg|
	~noteOff = msg;
	//~noteOff.postln;
	if(~theMode == 1 && notes[~noteOff[1]].isPlaying, {
	notes[~noteOff[1]].set(\trig, 0);
	notes[~noteOff[1]].set(\gate, 0);
	notes[~noteOff[1]].release;
	});
	//x.set("trig", 0);

}, "/keyOff");

~oldmsg = 0;
OSCdef(\encoder, { |msg|
	//~root = msg[1]-4;
	//if(msg[1] != ~oldmsg,{(msg[1].clip(0,120)).postln});// {(msg[1].min(8)-3).postln});
	/*if(msg[1] < ~oldmsg,
		{~coreNote= ~coreNote - 1; ~coreNote.postln;},
		{if(msg[1] > ~oldmsg,
			{~coreNote = ~coreNote + 1; ~coreNote.postln;})});
	~oldmsg = msg[1];
	//~coreNote.postln;
	~coreNote = ~coreNote.clip(1, 99);*/

}, "/rawEnc");

OSCdef(\scale, { |msg|
	~scale = Scale.at(Scale.names[msg[1]]);
	if(msg[1] != ~oldmsg, {msg[1].postln});
	~oldmsg = msg[1];
	//~scale.name.postln;

}, "/scale");

OSCdef(\getCoreNote, {|msg|
	~coreNote = msg[1];
	//~coreNote.postln;
}, "/core");

q = { on.free; off.free};

OSCdef(\getLeadKnobs, {|msg|
	~leadKnobs = msg[2..7];
	//~leadKnobs.postln;
}, "/leadKnobs");

//This def listens for messages about which drone to turn off or on.
OSCdef(\setLeadSynth, {|msg|

	~curSynth = ~leadNames[msg[1]];
	if( ~leadSynths[msg[1]] != nil, {  //if the Synth has been played / added to array
		if(msg[2] == 0,  //if the toggle state is off
			{
				"turning off: ".post;
				msg[1].postln;
				~leadSynths[msg[1]].set(\gate, 0);  //close gate: let Synth release
				~leadSynths[msg[1]].postln;
			},
			{  //if the toggle state is on
				"turned on existing".postln;
				//~leadSynths[msg[1]] = nil;
				~leadSynths[msg[1]] = Synth(~leadNames[msg[1]], [\gate, 1, \freq, 500, \amp, 0.5]);  //create Synth and add to array
				NodeWatcher.register(~leadSynths[msg[1]]);  /*register synth so we can know if it is playing or not so we do not get errors when setting variables with knobs*/

	});},
		{  //if Synth has never been played
		"turned on nil".postln;
		~leadSynths[msg[1]] = Synth(~leadNames[msg[1]], [\gate,1, \freq, 500, \amp, 0.5]);
		NodeWatcher.register(~leadSynths[msg[1]]);

	});
}, "/setLeadSynth");  //message name from processing
)


SynthDef("oscnotes", { arg out =0, freq=440, trig=0, pitchMod =0, amp = 0.5, atk=0.01, releaseTime=1;
var sound, env;
sound = SinOsc.ar(freq+pitchMod);
	env = EnvGen.ar(Env.adsr(releaseTime: releaseTime), trig, doneAction: 2);
Out.ar(out, sound*env*amp);
}).add;





SynthDef("am1", {arg freq = 200, modfreq = 5, amp = 0.4, att = 0.01, rel = 3, gate=0, out;
    var carrier, modulator, env ,gen;
    env = Env.perc(
        attackTime: att,
        releaseTime: rel,
        level: amp
    );//.kr(2);
	gen = EnvGen.kr(env, gate, doneAction: 2);
    modulator = SinOsc.ar(modfreq).range(0, 1);
    carrier = SinOsc.ar(freq: freq, mul: gen * modulator);
    Out.ar(out, carrier ! 2);
}).add;
)

SynthDef("simpleSine", { arg freq = 440, att = 0.1, rel=0.3, amp = 0.25, gate = 0.5, curv = -4;
	var sig = SinOsc.ar(freq, 0, 1);
	var env = Env.perc(att, rel, curve: curv);
	var gen = EnvGen.kr(env, gate, doneAction:2);
    Out.ar(
        0,
        sig*gen*amp
        )
}).add;
~theMode;
~coreNote;
~scale;
x=Synth(\simpleSine, [\freq, 300, \curv, -8, \atk, 0.01, \rel, 0.4]);
x.free;