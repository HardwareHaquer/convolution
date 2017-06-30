

//variable definitions
(
~scales = Scale.minor;
~scale = Scale.minor;
~rootNote = 0;
~bassDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~congaDegrees = PatternProxy(Pn(Pseries(0, 4, 12), inf));
~hihatDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~kickDegrees = PatternProxy(Pn(Pseries(0, 8, 12), inf));
~fluteDegrees = PatternProxy(Pn(Pseries(0, 0.5, 12), inf));
~snareDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth1Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth2Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
)

(
~bassArray = Array.fill(32, {rrand(-2,2)});
~congaArray = Array.fill(32, {rrand(-2,2)});
~hihatArray = Array.fill(32, {rrand(-2,2)});
~kickArray = Array.fill(32, {rrand(-2,2)});
~fluteArray = Array.fill(32, {rrand(-2,2)});
~snareArray = Array.fill(32, {rrand(-2,2)});
~synth1Array = Array.fill(32, {rrand(-2,2)});
~synth2Array = Array.fill(32, {rrand(-2,2)});
)

//start tempoClock

//Setup OSC messages to Processing and setup tempoClock.  Below is OSCdef to set tempo
)
//Send OSC tick to processing
(
b = NetAddr.new("127.0.0.1", 12001);    // create the NetAddr
// get elapsed time, round up to next second
v = Main.elapsedTime.ceil;
~mainTempo = 1;  //bpm = num * 60  bpm/60 = num
(1000/125*60).postln;
// create two clocks, starting at time v.
t = TempoClock(1, 0, v);
u = TempoClock(t.tempo*8, 0, v);

// start two functions at beat zero in each clock.
// t controls u's tempo. They should stay in sync.
t.schedAbs(0, { arg beat, sec; /* [\t, beat, sec].postln;*/ 1 });
u.schedAbs(0, { arg beat, sec; /*["/tick", beat%32, "hrlp","more"].postln;*/b.sendMsg("/tick", beat%32, "hrlp","more");  1 });
)


//OSCdefs

(
OSCdef(\getbpm, {|msg|                /*GetBPM listens for BPM message from Processing*/
	~mainTempo = msg[1]/60;
	t.tempo = ~mainTempo;
	u.tempo = t.tempo*8;
	//msg.postln;
}, "/bpm");
)

(
OSCdef(\bass, { |msg|    /*OSCDefs to fill all array and create sequences for all instruments played via drum machine*/

	~bassArray = msg[1..32];
	 for(0, ~bassArray.size-1, {|i|
		if(~bassArray[i] == 0,
			{~bassArray[i] = Rest},
			{~bassArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~bassDegrees.source = (Pseq(~bassArray, inf));
	//msg[0].postln;
	//~bassArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/bass");

OSCdef(\conga, { |msg|

	~congaArray = msg[1..32];
	 for(0, ~congaArray.size-1, {|i|
		if(~congaArray[i] == 0,
			{~congaArray[i] = Rest},
			{~congaArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});
	~congaDegrees.source = (Pseq(~congaArray, inf));
	//msg[0].postln;
	//~congaArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/conga");

Synth(\funSynth, [pitch:50.rrand(600)]);
OSCdef(\hihat, { |msg|

	~hihatArray = msg[1..32];
	 for(0, ~hihatArray.size-1, {|i|
		if(~hihatArray[i] == 0,
			{~hihatArray[i] = Rest},
			{~hihatArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~hihatDegrees.source = (Pseq(~hihatArray, inf));
	//msg[0].postln;
	//~hihatArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/hi-hat");

OSCdef(\kick, { |msg|

	~kickArray = msg[1..32];
	 for(0, ~kickArray.size-1, {|i|
		if(~kickArray[i] == 0,
			{~kickArray[i] = Rest},
			{~kickArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~kickDegrees.source = (Pseq(~kickArray, inf));
	//msg[0].postln;
	//~kickArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/kick");

OSCdef(\flute, { |msg|

	~fluteArray = msg[1..32];
	 for(0, ~fluteArray.size-1, {|i|
		if(~fluteArray[i] == 0,
			{~fluteArray[i] = Rest},
			{~fluteArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~fluteDegrees.source = (Pseq(~fluteArray, inf));
	//msg[0].postln;
	//~fluteArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/flute");

OSCdef(\snare, { |msg|

	~snareArray = msg[1..32];
	 for(0, ~snareArray.size-1, {|i|
		if(~snareArray[i] == 0,
			{~snareArray[i] = Rest},
			{~snareArray[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~snareDegrees.source = (Pseq(~snareArray, inf));
	//msg[0].postln;
	//~snareArray.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/snare");

OSCdef(\synth1, { |msg|

	~synth1Array = msg[1..32];
	 for(0, ~synth1Array.size-1, {|i|
		if(~synth1Array[i] == 0,
			{~synth1Array[i] = Rest},
			{~synth1Array[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~synth1Degrees.source = (Pseq(~synth1Array, inf));
	//msg[0].postln;
	//~synth1Array.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/synth1");

OSCdef(\synth2, { |msg|

	~synth2Array = msg[1..32];
	 for(0, ~synth2Array.size-1, {|i|
		if(~synth2Array[i] == 0,
			{~synth2Array[i] = Rest},
			{~synth2Array[i] = [1,3,5,7].choose}//~scales.degrees.choose}
		);
	});

	~synth2Degrees.source = (Pseq(~synth2Array, inf));
	//msg[0].postln;
	//~synth2Array.postln;

	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/synth2");

)

//PBinds for drum machine

(
~bass = Pbind(
	\instrument, \ueeb,
    \degree, ~bassDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~conga = Pbind(
	\instrument, \beeu,
    \degree, ~congaDegrees,
	\scale, Pfunc{~scales},
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~hihat = Pbind(
	\instrument, \help_sinegrain,
    \degree, ~hihatDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~kick = Pbind(
	\instrument, \help_sawgrain,
    \degree, ~kickDegrees,
	\scale, Pfunc{~scales},
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~flute = Pbind(
	\instrument, \funSynth,
    \degree, ~fluteDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~snare = Pbind(
	\instrument, \beeu,
    \degree, ~snareDegrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth1 = Pbind(
	\instrument, \ueeb,
    \degree, ~synth1Degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth2 = Pbind(
	\instrument, \funSynth,
    \degree, ~synth2Degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,

).play(t, quant: 1);
)