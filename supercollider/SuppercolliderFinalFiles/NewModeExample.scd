//define global variables and default values
(
~droneKnobs;
~droneNames = [\drone1, \drone2, \drone3];//, \LFNoise0, \LFNoise1, \LFNoise2];
~droneSynths = Array.newClear(~droneNames.size);
~droneSynth = nil;  //make sure that the variable is initialized to nil to stop errors later
~droneAmp = 0.5;
)
//define synthDefs
/*It is important to give the arguments to your synthDefs the same names for the same puprose.
This makes it much easier to switch synths and use the same code to apply potentiometer values to the new synth.
Also freq, amp, and gate are some of the argument names that supercollider recognizes for use in sequences*/
(
SynthDef(\drone1, { | freq = 100, amp = 0.25, gate = 1, out = 0 |
	var sig = LFNoise1.ar(freq, amp);
	var asr = Env.asr(0.01, 1, 0.5);
	var env = EnvGen.kr(asr,gate, doneAction: 2);
	var ampOsc = LFNoise2.kr(0.6, 1, 0.3) *amp;
	Out.ar(out, (sig*env*ampOsc)!2);
}).add;

SynthDef(\drone2, { | freq = 100, amp = 0.25, gate = 1,  out = 0 |
	var sig = LFNoise2.ar(freq, amp);
	var asr = Env.asr(0.01, 1, 0.5);
	var env = EnvGen.kr(asr,gate, doneAction: 2);
	var ampOsc = LFNoise2.kr(0.3, 1, 0.3) *amp;
	Out.ar(out, (sig*env*ampOsc)!2);
}).add;

SynthDef(\drone3, { | freq = 100, amp = 0.25, gate = 1,  out = 0 |
	var sig = LFNoise1.ar(freq, amp);
	var asr = Env.asr(0.01, 1, 0.5);
	var env = EnvGen.kr(asr,gate, doneAction: 2);
	var ampOsc = LFNoise2.kr(0.5, 1, 0.3) *amp;
	Out.ar(out, (sig*env*ampOsc)!2);
}).add;
)
//===========Currently just using 3 above for example

SynthDef("LFNoise0", { arg freq = 100, out=0, modFreq = 10;
    Out.ar(out,
        LFBrownNoise0.ar(freq, 1, LFNoise2.kr(modFreq, 1, 1), 0.25)
    )
}).add;

SynthDef("LFNoise1", { | out=0, freq = 100 |
    Out.ar(out,
        LFBrownNoise1.ar(freq, 1, MouseX.kr(0, 5), 0.25)
    )
}).add;

SynthDef("LFNoise2", { arg out=0, freq = 100, amp = 1;
    Out.ar(out,
        LFBrownNoise2.ar(freq, 0.5, MouseX.kr(0, 5), 0.5)*amp
    )
}).add;

SynthDef("grainNoise", { arg freq = 100, centerFreq = 440, freqDev = 200, out=0;
	var gate = LFBrownNoise0.ar(freq, 1, LFNoise2.kr(100, 1, 1), 0.25);
    Out.ar(out,

        SinOsc.ar(LFNoise0.kr(4, freqDev, centerFreq),
            0,
            EnvGen.kr(Env.sine(0.5), gate, 0.25)
        )
    )
}).add;
)
x = Synth(\LFNoise1);
x.free;
x.set(\modFreq, 20);
x.set(\freq, 300);

/*define OSCDefs  if using OSC message used by other modes (\keyOn, \keyOff for example) make sure to set check if ~theMode is the mode number before executing so it doesn't respond when in other modes.  Or define OSCDefs that are only triggered when in the mode.
*/
(
//This will listen for processing to send the 6 potentiometer values
OSCdef(\getDroneKnobs, {|msg|
	~droneKnobs = msg[2..7];  //pull the message into global variable for use in other functions
	if( ~droneSynths[0] != nil && ~droneSynths[0].isRunning, {  //if ~droneSynth exists set the arguments to values of the knobs
		~droneSynths[0].set(\amp, ~droneKnobs[0]);   //In this case we are only using 2  knobs for each drone one amp one freq
		~droneSynths[0].set(\freq, ~droneKnobs[1]);
	});
	if( ~droneSynths[1] != nil && ~droneSynths[1].isRunning, {
		~droneSynths[1].set(\amp, ~droneKnobs[2]);
		~droneSynths[1].set(\freq, ~droneKnobs[3]);
	});
	if( ~droneSynths[2] != nil && ~droneSynths[2].isRunning, {
		~droneSynths[2].set(\amp, ~droneKnobs[4]);
		~droneSynths[2].set(\freq, ~droneKnobs[5]);
	});

	//~droneKnobs.postln;
}, "/droneKnobs");

//This def listens for messages about which drone to turn off or on.
OSCdef(\setDroneSynth, {|msg|
	if( ~droneSynths[msg[1]] != nil, {  //if the Synth has been played / added to array
		if(msg[2] == 0,  //if the toggle state is off
			{
				"turning off: ".post;
				msg[1].postln;
				~droneSynths[msg[1]].set(\gate, 0);  //close gate: let Synth release
				~droneSynths[msg[1]].postln;
			},
			{  //if the toggle state is on
				"turned on existing".postln;
				//~droneSynths[msg[1]] = nil;
				~droneSynths[msg[1]] = Synth(~droneNames[msg[1]], [\gate, 1, \freq, 500, \amp, 0.5]);  //create Synth and add to array
				NodeWatcher.register(~droneSynths[msg[1]]);  /*register synth so we can know if it is playing or not so we do not get errors when setting variables with knobs*/

	});},
		{  //if Synth has never been played
		"turned on nil".postln;
		~droneSynths[msg[1]] = Synth(~droneNames[msg[1]], [\gate,1, \freq, 500, \amp, 0.5]);
		NodeWatcher.register(~droneSynths[msg[1]]);

	});
}, "/setDroneSynth");  //message name from processing
)
~droneSynths = Array.newClear(~droneNames.size);
~droneSynths;
~droneSynths[0] = nil;
s.queryAllNodes;
s.freeAll;
x =Synth.newPaused(\drone2, [\freq, 500, \gate, 1]);
x.set(\gate, 0);
x.run(false);
x.run;
x.free;
~lastDroneNum = nil;
(
if( ~lastDroneNum != nil,
	{
		~lastDroneNum.set(\gate, 0);
		~lastDroneNum = Synth(~droneNames[0], [\freq, 800, \gate, 1]);
	"lastDrone not nil".postln;
	},
	{ ~lastDroneNum = Synth(~droneNames[1], [\freq, 500, \gate, 1]);
		~droneNames[1].postln;
		~lastDroneNum.postln;
	"last drone nil".postln;
	});
)
~lastDroneNum.run;
~lastDroneNum.set(\gate, 0);
~lastDroneNum;
~lastDroneNum = Synth(~droneNames[1], [\freq, 500, \gate, 1]);
x={  SinOsc.ar(LFNoise1.ar(MouseX.kr(0.1, 200, 1), 200, 500), 0, 0.2)  }.play;
x.free;

{  SinOsc.ar(LFDNoise1.ar(MouseX.kr(0.1, 1000, 1), 200, 500), 0, 0.2)  }.play;

{Crackle.ar(1.1, 0.25) }.play;

{ Crackle.ar(Line.kr(1.0, 2.0, 3), 0.5, 0.5) }.play;

x = Synth(\LFNoise0);
x.set(\amp, 0.70);
x.set(\freq, 50);
x.free;

~lastDroneNum.set(\gate, 0);