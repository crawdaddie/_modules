// pattern module
var synthdef = SynthDef(\sqtest, { arg out = 0, freq = 200, gate = 1, width = 0.5;
	var sq = Pulse.ar(freq, width)!2;
	var env = Env.newClear(5);
	var envctl = \env.kr(env.asArray);
	var freqenv = EnvGen.kr(envctl, gate, doneAction: 2);
	var filt = RLPF.ar(sq, freqenv, 0.5);
	Out.ar(out, filt);
	}).add;

var env = Env([1000, 1000, 200, 400, 1000], [0, 0.2, 0.3, 0.4], [0,0,0,0]);
env.plot;

~x = NodeProxy.audio(s, 2);

~x.source = Pbind(\instrument, \sqtest,
	\dur, 1.5,
	\env, Plazy({env}),
	\octave, 2,
	\note, 3);






