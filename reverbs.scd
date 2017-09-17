~rreverb = {
    { arg in, time = 4, fbamt = 0.5, fbdelay = 0.01, rctl = 1, hifreq = 6000, lofreq = 60, ltime = 0.7;
    var signal, rev, fb, filt;
    fb = FbNode(2, 1);
    signal = in + fb.delay(fbdelay);

    signal = LeakDC.ar(signal);

    signal = HPF.ar(signal, 100);
    rev = signal.reverse;
    10.do({rev = AllpassL.ar(rev, 3, rctl*[0.1.rand, 0.1.rand], time.lag(ltime))});

    //filt = RHPF.ar(rev, hifreq.lag(ltime)) + RLPF.ar(rev, lofreq);
    
    rev = Limiter.ar(rev, 1);
    fb.write(fbamt*(rev));
    (signal * 0.6) + (rev) * 0.9;
};
};



~rreverbChorus = { 
{ arg in, time = 4, fbamt = 0.5, fbdelay = 0.01, rctl = 1, hifreq = 6000, lofreq = 60, ltime = 0.7;
    var signal, rev, fb, filt;
    fb = FbNode(2, 1);
    signal = in + fb.delay(fbdelay);

    signal = LeakDC.ar(signal);

    signal = HPF.ar(signal, 100);
    rev = signal.reverse;
    10.do({rev = AllpassL.ar(rev, 3, rctl* [0.1.rand, 0.1.rand] * LFNoise1.kr(\spd.kr(1), mul: \diff.kr(0.2), add: 1), time.lag(ltime))});

    //filt = RHPF.ar(rev, hifreq.lag(ltime)) + RLPF.ar(rev, lofreq);
    
    rev = Limiter.ar(rev, 1);
    fb.write(fbamt*(rev));
    (signal * 0.6) + (rev) * 0.9;
};
};




~rreverbGrain = {
{ arg in, time = 4, wSize = 0.2, fbamt = 0.5, fbdelay = 0.01, rctl = 1, hifreq = 6000, lofreq = 60, ltime = 0.7;
    var signal, rev, fb, filt;

    var ratios = \control.kr([1, 1.5, 0.99, 0.5]);
    fb = FbNode(2, 1);
    signal = in + fb.delay(fbdelay);

    signal = LeakDC.ar(signal);

    signal = HPF.ar(signal, 100);
    rev = signal.reverse;
    rev = Mix.new(PitchShift.ar(rev, wSize, ratios, \chorus.kr(0), \timeDisp.kr(0)));
    //rev.poll;
    10.do({rev = AllpassL.ar(rev, 3, rctl*[0.1.rand, 0.1.rand], time.lag(ltime))});

    //filt = RHPF.ar(rev, hifreq.lag(ltime)) + RLPF.ar(rev, lofreq);
    
    rev = Limiter.ar(rev, 1);
    fb.write(fbamt*(rev));
    (signal * 0.6) + (rev) * 0.9;
};
};

~rreverbPshift = {
{ arg in, time = 4, wSize = 0.2, fbamt = 0.5, fbdelay = 0.01, rctl = 1, hifreq = 6000, lofreq = 60, ltime = 0.7;
    var signal, rev, fb, filt;
    var chors = \chorus.kr(0);
    var timeDis = \timeDisp.kr(0);
    var ratios = \control.kr([1, 1.5, 0.99, 0.5]);
    fb = FbNode(2, 1);
    signal = in + fb.delay(fbdelay);

    signal = LeakDC.ar(signal);

    signal = HPF.ar(signal, 100);
    rev = signal.reverse;
    //rev = Mix.new(PitchShift.ar(rev, wSize, ratios, \chorus.kr(0), \timeDisp.kr(0)));
    4.do({ arg num, i;
        rev = PitchShift.ar(rev, wSize, ratios[i], chors, timeDis);
        rev = AllpassL.ar(rev, 3, rctl*[0.1.rand, 0.1.rand], time.lag(ltime));
        });
    6.do({rev = AllpassL.ar(rev, 3, rctl*[0.1.rand, 0.1.rand], time.lag(ltime))});

    //filt = RHPF.ar(rev, hifreq.lag(ltime)) + RLPF.ar(rev, lofreq);
    
    rev = Limiter.ar(rev, 1);
    fb.write(fbamt*(rev));
    (signal * 0.6) + (rev) * 0.9;
};
};