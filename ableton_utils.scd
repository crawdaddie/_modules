~setUp = { arg e, relativePath;
	var cwd = ~path.dirname;
	var path = cwd +/+ relativePath;
	var mod;
	if ((path +/+ "*.als").pathMatch.notEmpty, {
		mod = Mod.newVirtual(path, {
			~samplesDir =  ~path +/+ "Samples";
			});
		}, {(path ++ " not an ableton project").postln});
	mod;
};

// //First initialize the midi and audio devices
// (
// MIDIClient.init;
// //0 is iac bus internal routing from live!
// MIDIIn.connect(0, 0);
// //set the action:
// MIDIIn.control = {arg src, chan, num, val;
// val.postln;
// };
// Server.internal.options.device = "Soundflower (2ch)"; 
// Server.local.options.device = "Soundflower (2ch)"; 
// );
// //next define your synth and start the server
// (
// MIDIIn.connect;
// s = Server.local;
// s.boot;
// s.latency = 0;

// SynthDef("sik-goo", { arg freq=400,fromfreq=100, gate=0.0, bwfreq=800;
// var x;
// x = Formant.ar(
// SinOsc.kr(0.02,0,10,freq),
// fromfreq,
// bwfreq
// );
// x = EnvGen.kr(Env.adsr,gate,Latch.kr(gate,gate)) * x;
// Out.ar(0,x);
// }).send(s);
// );
// //finally link the midi actions to the defined synth parameters
// (
// x = Synth("sik-goo");
// // action;
// MIDIIn.noteOn = {arg src,chan,num,vel;
// x.set(\freq,num.midicps /4.0);
// x.set(\gate, vel / 200);
// x.set(\formfreq, vel / 127 *1000 );
// };
// MIDIIn.noteOff = { arg src,chan,num,vel;
// x.set(\gate, 0.0);
// };
// MIDIIn.bend = { arg src,chan,val;
// x.set(\bwfreq,val * 0.048828125 );
// };
// );

// // cleanup 
// x.free;

