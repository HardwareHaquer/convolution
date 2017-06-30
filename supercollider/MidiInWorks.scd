MIDIClient.init	//should post a list of available devices

MIDIIn.connect(0,MIDIClient.sources[2])  //first number is port number, second is device from sources list
//MIDIIn.connect //would work on its own but defaults to first port of first device
//MIDIIn.connectAll //connect to all attached input sources

MIDIIn.noteOn= { arg src, chan, num, vel;   [chan,num,vel / 127].postln; };   //set up callback for MIDI Note On message

MIDIIn.control = { arg src, chan, num, val;   [chan,num,val/127].postln; }; //control change messages have a 7 bit value

MIDIIn.bend = { arg src, chan, bend;  }; // [chan,bend/8192].postln; }; //pitch bend has a 14 bit range and is a bipolar signal (so bend/8192 will remap the range to -1.0 to 1.0)
MIDIIn.bend = nil;
MIDIFunc

//creating Synths with each new note on
(
SynthDef(\sound,{arg freq=440, amp=0.1;
	var saw, filter, env, gateVal;

	saw= Saw.ar(freq);
	filter= Resonz.ar(saw,200,0.2)*amp;
	env= EnvGen.ar(Env([0,1,0],[0.01,1]),gate: gateVal, doneAction:2);

	//dup(2) duplicates the mono signal onto two channels, giving instant stereo middle panned output
	Out.ar(0,(filter*env).dup(2))
}).add
)

//create one Synth for every new note, Synths will be of finite duration because of the envelope
MIDIIn.noteOn = { arg src,chan, midinote, velocity;   Synth(\sound,[\freq,midinote.midicps , \amp,velocity/127.0]) };

MIDIIn.noteOff = { arg src,chan, midinote, velocity;   Synth(\sound,[\freq,midinote.midicps, gate: 0, \amp,velocity/127.0]) };

//turn off again
MIDIIn.noteOn = nil;
MIDIIn.noteOff = nil;


(
SynthDef.new(\multi,  { arg freq = 440, gate=1;
	var sig, amp, env;
	env =  EnvGen.kr(  //triangle envelope to shape volume of synth
		Env.new([0,1,0], [0.1,1], [1, -1]), gate,
		doneAction: 2
	);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,0.8);  //Create an array of 8 unique amplitude oscillators
	sig = SinOsc.ar({ExpRand(freq/4, freq*4)}!8);                    //create an array of 8 unique frequency oscillators
	sig = sig * amp * env;                                               //combine the signal, amplitude, and envelop for each
	sig = Splay.ar(sig)!2*0.5;                                        //Splay the 8 signals between two audio channels(stereo sound)
	Out.ar(0,sig);                                                            //Send signal to speakers
}).add;
)


//note the use of a gate; this will sustain until released
(
SynthDef(\sound,{arg freq=440, amp=0.1, gate=1, freqMod = 0;
	var saw, filter, env;

	saw= Saw.ar(freq+freqMod);
	filter= Resonz.ar(saw,1000,0.1)*amp;
	env= EnvGen.ar(Env.asr(0.005,1.0,0.1),gate,doneAction:2);

	Out.ar(0,(filter*env).dup(2))
}).add
)

//MIDIIn.noteOn = { arg src,chan, midinote, velocity;   Synth(\sound,[\freq,midinote.midicps , \amp,velocity/127.0]) };
MIDIIn.noteOn = { arg src,chan, midinote, velocity;   Synth(\multi,[\freq,midinote.midicps]) };
//~activenotes = nil!128;  use midi keyboard to control theKey
(
var noteBend = 0;
var bent=0;
var activenotes = nil!128; //make Array of 128 slots, initially with nil objects in to represent nothing
var releasefunction = {|index|

		//release existing note if present already
	if(activenotes[index].notNil) {
		activenotes[index].release; //will send gate=0
		activenotes[index] = nil; //make sure now empty slot ready
	}

	};
	MIDIIn.bend = {arg src, chan, bend;

		//[chan,bend].postln;
		noteBend = [chan,bend/8192];
/*		"noteBend ".post;
	noteBend[1].postln;*/
	bent = noteBend[1]*100;
		Synth(\sound,[\freqMod, bent]);
/*	"bent ".post;
	bent.postln;*/
};
//create one Synth for every new note, with logic to check existing notes (though not MIDI channel sensitive)
MIDIIn.noteOn = { arg src,chan, midinote, velocity;

	//"received".postln;



	releasefunction.value(midinote);

	//put active note in array; function above tidied any existing note on this key
	activenotes[midinote] = Synth(\multi,[\freq,midinote.midicps]);
	//activenotes[midinote] = Synth(\sound,[\freq,midinote.midicps,\amp,velocity/127.0+30, \freqMod, bent]);
	bent.postln;
	};

//must also look for note offs as indicated end of held note
MIDIIn.noteOff = { arg src,chan, midinote, velocity, bend;

	releasefunction.value(midinote);

	};

)

n = MIDIFunc.noteOn({arg ...args; args.postln}); // match any noteOn
(
b = MIDIFunc.bend({arg ...args; args.postln}); // match any noteOn

)

s.reboot;