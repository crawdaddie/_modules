



var b1 = Buffer.alloc(s, 10*44100);
var b2 = Buffer.alloc(s, 10*44100);





~warpdelay = {
	{ arg spd = 1, spdctl = 1, rate = 0.96, rate2 = 2.01, ratectl = 1,
	delay = 0.01, wsize = 0.2, wrand = 0.5,
	overlaps = 40, amp = 1, fbamt = 0.8, dur = 0.3,
	maxlfo = 20, filtmix = 1, mix = 0, t_gate = 1, spdatk = 0.2, reclevel = 0.4,
	buf1, buf2;

	var trigger, phase, warpPhase, input, record1, record2, warp, warp2, dist, output, ampenv, fb, wctl;


	wctl = \ctl1.kr(1).linlin(0,1.0,0.1,0.99);



	trigger = t_gate;
	phase = Phasor.ar(trigger, 1, 0, BufFrames.kr(b1));
	warpPhase = EnvGen.ar(Env.new([1, 1, spd], [0, spdatk, 1].normalizeSum), trigger, timeScale: dur) * \ctl2.kr(0) * (phase/BufFrames.kr(b1));
	ampenv = EnvGen.ar(Env.new([0.2, 0.2, 1], [0, 0.1, 1].normalizeSum), trigger, timeScale: dur);

	fb = FbNode(2, 1);


	input = \in.ar(0!2);
	input = input + Limiter.ar(fb);
	input = HPF.ar(input, 100);

	record1 = BufWr.ar(reclevel * input[0], b1, phase);
	record2 = BufWr.ar(reclevel * input[1], b2, phase);

	
	warp = Warp1.ar(
		numChannels: 1, 
		bufnum: b1, 
		pointer: Wrap.ar(delay*44100/BufFrames.kr(b1) + warpPhase),
		freqScale: rate*ratectl,
		windowSize: wctl,
		envbufnum: -1,
		overlaps: overlaps*\ctl3.kr(1),
		windowRandRatio: \ctl4.kr(1).linlin(0,1.0,0.001,0.99),
		interp: 2);

	warp2 = Warp1.ar(
		numChannels: 1, 
		bufnum: b2, 
		pointer: Wrap.ar(delay*44100/BufFrames.kr(b2) + warpPhase),
		freqScale: rate2*ratectl,
		windowSize: wctl,
		envbufnum: -1,
		overlaps: overlaps*\ctl5.kr(1), 
		windowRandRatio: \ctl6.kr(1).linlin(0,1.0,0.001,0.99),
		interp: 2);

	dist =  SinOsc.ar(LFNoise1.kr(0.3).range(0.01, \ctl7.kr(1).linlin(0,1.0,0.2,20))).abs*filtmix*AJNastyFilt.ar((warp + warp2)*0.5, hpf: 9000, lpf: 120, filt: \ctl8.kr(1).linexp(0,1.0,0.5,1));

	output = XFade2.ar([warp,warp2], dist, \ctl8.kr(1).linlin(0,1.0,-1.0,1));


	fb.write(\ctl9.kr(1).linlin(0,1.0,0,0.99) * LeakDC.ar(output.reverse));

	amp*\ctl10.kr(1)*output*ampenv;




};
};



