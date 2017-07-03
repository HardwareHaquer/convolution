//~scales = Scale.spanish;
//Scale.directory;
//variable definitions
Scale.at(\ionian).postln;
Scale.names.postln;
~theScale = Scale.names[5];
~scales = Scale.directory;
~scales[3].postln;
~mult.postln;
(
//~stepSeqPatternProxy = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~mult = 1.0;
~testSeqAmp =0.5;
~seqLegato = 0.5;
~seqOctave = 5;
~seqRoot = 0;
~scales = Scale.minor;
~scale = Scale.minor;
~rootNote = 0;
//change below to just be zero.
~rootNotesDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~stepSeqDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~bassDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));
~congaDegrees = PatternProxy(Pn(Pseries(0, 4, 12), inf));
~hihatDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~kickDegrees = PatternProxy(Pn(Pseries(0, 8, 12), inf));
~fluteDegrees = PatternProxy(Pn(Pseries(0, 0.5, 12), inf));
~snareDegrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth1Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~synth2Degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));

~stepSeqArray = Array.fill(16, {rrand(-2,2)});
~bassArray = Array.fill(32, {rrand(-2,2)});
~congaArray = Array.fill(32, {rrand(-2,2)});
~hihatArray = Array.fill(32, {rrand(-2,2)});
~kickArray = Array.fill(32, {rrand(-2,2)});
~fluteArray = Array.fill(32, {rrand(-2,2)});
~snareArray = Array.fill(32, {rrand(-2,2)});
~synth1Array = Array.fill(32, {rrand(-2,2)});
~synth2Array = Array.fill(32, {rrand(-2,2)});

//initiatize amp and rate holders

~bassAmp = PatternProxy(Pseq([0.5], inf));
~congaAmp = PatternProxy(Pseq([0.5], inf));
~hihatAmp = PatternProxy(Pseq([0.5], inf));
~kickAmp = PatternProxy(Pseq([0.5], inf));
~fluteAmp = PatternProxy(Pseq([0.5], inf));
~snareAmp = PatternProxy(Pseq([0.5], inf));
~synth1Amp = PatternProxy(Pseq([0.5], inf));
~synth2Amp = PatternProxy(Pseq([0.5], inf));
~seqAmp = PatternProxy(Pseq([1.0]), inf);

~bassRate = PatternProxy(Pseq([1], inf));
~congaRate = PatternProxy(Pseq([1], inf));
~hihatRate = PatternProxy(Pseq([1], inf));
~kickRate = PatternProxy(Pseq([1], inf));
~fluteRate = PatternProxy(Pseq([1], inf));
~snareRate = PatternProxy(Pseq([1], inf));
~synth1Rate = PatternProxy(Pseq([1], inf));
~synth2Rate= PatternProxy(Pseq([1], inf));

~dmInstAtk = Array.fill(8, PatternProxy(Pseq([1], inf)));
~dmInstSus = Array.fill(8, PatternProxy(Pseq([1], inf)));
~dmInstDcy = Array.fill(8, PatternProxy(Pseq([1], inf)));
~dmInstRel = Array.fill(8, PatternProxy(Pseq([1], inf)));

//~stepSequencePatternProxy.source = PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees, \root, ~rootNotesDegrees, \legato, 1.0, \amp, Pfunc{~testSeqAmp} );

//start tempoClock

//Setup OSC messages to Processing and setup tempoClock.  Below is OSCdef to set tempo

//Send OSC tick to processing

b = NetAddr.new("127.0.0.1", 12001);    // create the NetAddr
// get elapsed time, round up to next second
v = Main.elapsedTime.ceil;
~mainTempo = 1;  //bpm = num * 60  bpm/60 = num

(1000/125*60).postln;
// create two clocks, starting at time v.
t = TempoClock(1, 0, v);
u = TempoClock(t.tempo*8, 0, v);
x = TempoClock(t.tempo*~mult, 0, v);

// start two functions at beat zero in each clock.
// t controls u's tempo. They should stay in sync.
t.schedAbs(0, { arg beat, sec; /* [\t, beat, sec].postln;*/ 1 });
u.schedAbs(0, { arg beat, sec; /*["/tick", beat%32, "hrlp","more"].postln;*/b.sendMsg("/tick", beat, "hrlp","more");  1 });



/*~stepstep =  Pbind(
		\instrument, \sawpulse,
		\degree, ~stepSeqDegrees,
		\scale, Pfunc{~scales},
		\root, ~rootNotesDegrees,
		\amp, Pfunc{~testSeqAmp},
		\dur, 0.125,  //maybe change rythms based on 0.125,0.250,0.5, 0.75, 1?
	).play(t, quant: 1);*/

//OSCdefs


OSCdef(\getbpm, {|msg|                /*GetBPM listens for BPM message from Processing*/
	~mainTempo = msg[1]/60;
	t.tempo = ~mainTempo;
	x.tempo = t.tempo*~mult;
	//msg.postln;
}, "/bpm");

OSCdef(\getSeqAmp, {|msg|                /*GetBPM listens for BPM message from Processing*/
	   var temp;
	temp = msg[1];
	~seqAmp.source =(Pseq([1.0], inf));
	~testSeqAmp = msg[1];
	//msg.postln;
	//~seqAmp.source.postln;
}, "/volume");

OSCdef(\getTempoMult, {|msg|                /*GetBPM listens for BPM message from Processing*/
	   var temp;
	temp = msg[1];
	~mult = msg[1];
	t.tempo = ~mainTempo;
	x.tempo = t.tempo*~mult;
	//~seqAmp.source =(Pseq([1.0], inf));
	//~testSeqAmp = msg[1];
	~mult.postln;
	//~seqAmp.source.postln;
}, "/seqMult");

OSCdef(\getSlideMode, {|msg|                /*GetBPM listens for BPM message from Processing*/
	   var temp;
	temp = msg[1];
	~seqLegato = msg[1];
	//~seqAmp.source =(Pseq([1.0], inf));
	//~testSeqAmp = msg[1];
	//msg.postln;
	//~seqAmp.source.postln;
}, "/Slide");

OSCdef(\knobStates, {|msg|
	//msg[1].postln;
	switch (msg[1],
		0, {~bassKnobs = msg[2..7];
			~bassAmp.source = (Pseq([~bassKnobs[4]], inf));
			~bassRate.source = (Pseq([~bassKnobs[5]], inf));

		},
		1, {~congaKnobs = msg[2..7];
		~congaAmp.source = (Pseq([~congaKnobs[4]], inf));
			~congaRate.source = (Pseq([~congaKnobs[5]], inf));
		},
		2, {~hihatKnobs = msg[2..7];
			~hihatAmp.source = (Pseq([~hihatKnobs[4]], inf));
			~hihatRate.source = (Pseq([~hihatKnobs[5]], inf));
		},
		3, {~kickKnobs = msg[2..7];
			~kickAmp.source = (Pseq([~kickKnobs[4]], inf));
			~kickRate.source = (Pseq([~kickKnobs[5]], inf));
		},
		4, {~fluteKnobs = msg[2..7];
			~fluteAmp.source = (Pseq([~fluteKnobs[4]], inf));
			~fluteRate.source = (Pseq([~fluteKnobs[5]], inf));
		},
		5, {~snareKnobs = msg[2..7];
			~snareAmp.source = (Pseq([~snareKnobs[4]], inf));
			~snareRate.source = (Pseq([~snareKnobs[5]], inf));
		    },
		6, {~synth1Knobs = msg[2..7];
			~synth1Amp.source = (Pseq([~synth1Knobs[4]], inf));
			~synth1Rate.source = (Pseq([~synth1Knobs[5]], inf));
		},
		7, {~synth2Knobs = msg[2..7];
			~synth2Amp.source = (Pseq([~synth2Knobs[4]], inf));
			~synth2Rate.source = (Pseq([~synth2Knobs[5]], inf));
	});
	~dmInstAtk[msg[1]].source = (Pseq([msg[2]], inf));
	~dmInstDcy[msg[1]].source = (Pseq([msg[3]], inf));
	~dmInstSus[msg[1]].source = (Pseq([(2*msg[4])-5], inf));
	~dmInstRel[msg[1]].source = (Pseq([msg[5]], inf));
}, "/kStates");

/*~bassAmp.source = (Pseq([0.5], inf));
~bassAmp.source = (Pseq([0.5], inf));
~bassKnobs.postln;
~snareKnobs.postln;
~snareRate.source = (Pseq([~snareKnobs[5]], inf));
~snareAmp.source = (Pseq([~snareKnobs[4]], inf));*/


OSCdef(\StepSeq, { |msg|    /*OSCDefs to fill all array and create sequences for all instruments played via drum machine*/

	~stepSeqArray = msg[1..(msg.size-1)];
	 for(0, ~stepSeqArray.size-1, {|i|
		if(~stepSeqArray[i] == -1,
			{~stepSeqArray[i] = Rest},
			{~stepSeqArray[i] = ~scale.degrees.wrapAt(msg[i+1])}//~scales.degrees.choose}
		);
	});

	~stepSeqDegrees.source = (Pseq(~stepSeqArray, inf));
	//msg[0].postln;
	//~bassArray.postln;
  ~stepSeqArray.postln;
	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/StepSeq");

//~stepSeqArray.size;

OSCdef(\RootNotes, { |msg|    /*OSCDefs to fill all array and create sequences for all instruments played via drum machine*/

	~rootNotesArray = msg[1..(msg.size-1)];
	 for(0, ~rootNotesArray.size-1, {|i|
		if(~rootNotesArray[i] == -1,
			{~rootNotesArray[i] = Rest},
			{~rootNotesArray[i] = ~scale.degrees.wrapAt(msg[i+1])}//~scales.degrees.choose}
		);
	});
  //add sequence repeats or trigger for next root
	~rootNotesDegrees.source = (Pseq(~rootNotesArray.stutter(~stepSeqArray.size), inf));
	//msg[0].postln;
	//~bassArray.postln;
  ~rootNotesArray.postln;
	//~knobsArray = msg[34..39];
	//~knobsArray.postln;

}, "/RootNotes");


/*~rootNotesArray.postln;
~stepSeqArray.postln;*/

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



//PBinds for drum machine


~bass = Pbind(
	\instrument, \bufplay,
    \degree, ~bassDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\l][0].bufnum,
	\rate, ~bassRate,
	\amp, ~bassAmp,
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~conga = Pbind(
	\instrument, \bufplay,
    \degree, ~congaDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\l][1].bufnum,
	\rate, ~congaRate,
	\amp, ~congaAmp,
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~hihat = Pbind(
	\instrument, \bufplay,
    \degree, ~hihatDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\l][3].bufnum,
	\rate, ~hihatRate,
	\amp, ~hihatAmp,
    \dur, 0.125,
	\root, Pfunc{~rootNote},
	//\strum, 0.1
).play(t, quant: 1);

~kick = Pbind(
	\instrument, \bufplay,
    \degree, ~kickDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\m][0].bufnum,
	\rate, ~kickRate,
	\amp, ~kickAmp,
	\root, Pfunc{~rootNote},
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~flute = Pbind(
	\instrument, \bufplay,
    \degree, ~fluteDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\m][1].bufnum,
	\rate, ~fluteRate,
	\amp, ~fluteAmp,
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~snare = Pbind(
	\instrument, \bufplay,
    \degree, ~snareDegrees,
	\scale, Pfunc{~scales},
	\buf, d[\m][0].bufnum,
	\rate, ~snareRate,
	\amp, ~snareAmp,
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth1 = Pbind(
	\instrument, \bufplay,
    \degree, ~synth1Degrees,
	\scale, Pfunc{~scales},
	\buf, d[\h][6].bufnum,
	\rate, ~synth1Rate,
	\amp, ~synth1Amp,
    \dur, 0.125,
	//\strum, 0.1
).play(t, quant: 1);

~synth2 = Pbind(
	\instrument, \bufplay,
    \degree, ~synth2Degrees,
	\buf, d[\h][7].bufnum,
	\rate, ~synth2Rate,
	\amp, ~synth2Amp,
	\scale, Pfunc{~scales},
    \dur, 0.125,

).play(t, quant: 1);

~stepstep =  PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees, \root, ~rootNotesDegrees, \legato, Pfunc{~seqLegato}, \amp, Pfunc{~testSeqAmp} ).play(x, quant: 1);

)
~stepstep.stop;

//added the function to map coreNote to the way root wants it without octave.  Now need to figure out how to do root changes
~stepstep =  PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees,  \root, Pfunc{(~coreNote).linlin(12,120,-48, 60);}, \legato, Pfunc{~seqLegato}, \amp, Pfunc{~testSeqAmp} ).play(x, quant: 1);
(~coreNote/12).trunc;
~coreNote%12
~coreNote.postln;
~seqRoot = 23;
~coreNote = 36;
60-12
~seqRoot = (~coreNote).linlin(12,120,-48, 60);
(~coreNote/12).trunc
\octave, Pfunc{(~coreNote/12).trunc},
/*(
~bass.stop;
~conga.stop;
~hihat.stop;
~kick.stop;
~flute.stop;
~snare.stop;
~synth1.stop;
~synth2.stop;
)
~flute.stop;
~snare.stop;*/
/*(
~testes= Pbind(
	\instrument, \bufplay,
    \degree, ~bassDegrees,
	\buf, d[\h][6].bufnum,
	\rate, ~setRate,
	\amp, ~testesamp,
    \dur, 0.125,  //maybe change rythms based on 0.125,0.250,0.5, 0.75, 1?
).play(t, quant: 1);
)*/



/*~stepSequence= Pbind(
	\instrument, \help_sinegrain,
    \degree, ~stepSeqDegrees,
	\scale, Pfunc{~scales},
	\amp, 1.0,
    \dur, 0.125,  //maybe change rythms based on 0.125,0.250,0.5, 0.75, 1?
).play(t, quant: 1);*/



/*~stepSequenceRoot= Pbind(
	\instrument, \sawpulse,
    \degree, ~stepSeqDegrees,
	\scale, Pfunc{~scales},
	\root, ~rootNotesDegrees,
	\amp, Pfunc{~testSeqAmp},
    \dur, 0.125,  //maybe change rythms based on 0.125,0.250,0.5, 0.75, 1?
).play(t, quant: 1);*/
//testing
//~stepSequencePatternProxy.play(t, quant: 1);
//~stepstep =  PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees, \root, ~rootNotesDegrees, \legato, 1.0, \amp, Pfunc{~testSeqAmp} ).play(t, quant: 1);
//)


/*(~stepstep =  Pbind(
		\instrument, \sawpulse,
		\degree, ~stepSeqDegrees,
		\scale, Pfunc{~scales},
		\root, ~rootNotesDegrees,
		\amp, Pfunc{~testSeqAmp},
		\dur, 0.125,  //maybe change rythms based on 0.125,0.250,0.5, 0.75, 1?
	).play(t, quant: 1));*/

// ~stepSequenceRoot.stop;
// ~testSeqAmp.postln;
// ~stepSequence.stop;
// ~scales = Scale.yu;
// Scale.directory
// ~rootNotesDegrees.postln;

// ~stepSequence.free;
// ~stepSequence.stop;
//
// //feed rate, amp, etc into samples have button to adjust or lock settings for each insturment
// //create osc defs for amp and rate
// ~testes.stop;
// ~bass.stop;
// ~setRate.free;
// ~testesamp = PatternProxy(Pn(Pseq([1], inf),inf));
// ~testesamp.source = (Pseq([0.7], inf));
// ~setRate = PatternProxy(Pn(Pseries(0, 2, 12), inf));
// ~setRate.source = (Pseq([1], inf));//PSeq(3, inf);
// ~bassDegrees = PatternProxy(Pn(Pseries(0, 2, 12), inf));