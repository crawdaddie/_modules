var control = Bus.control(s, 6);
control.set(0, 1, 1, 0.1, 0.2, 0);

~ar = { 
	{ arg in;
		var b4 = in;
		var ctls = control.kr;
		var after = Compander.ar(in, in,
			thresh: ctls[0].dbamp,
			slopeBelow: ctls[1], 
			slopeAbove: ctls[2],
			clampTime: ctls[3],
			relaxTime: ctls[4]
			);
		ctls[5].dbamp * after;
		
	}
};


~arGui = {
	{ arg in;
		var imp, delimp, after;
		var ctls = control.kr;
		var b4 = in;
		imp = Impulse.kr(10);
		    delimp = Delay1.kr(imp);
		    
		SendReply.kr(imp, '/levels_pre', [Amplitude.kr(b4), K2A.ar(Peak.ar(b4, delimp).lag(0, 3))]);
		after = Compander.ar(in, in,
			thresh: ctls[0],
			slopeBelow: ctls[1], 
			slopeAbove: ctls[2],
			clampTime: ctls[3],
			relaxTime: ctls[4]
			);
		after = ctls[5].dbamp * after;
		SendReply.kr(imp, '/levels_post', [Amplitude.kr(after), K2A.ar(Peak.ar(after, delimp).lag(0, 3))]);
		after;
	}

};

~makeGui = {
	var o, p, f, kLoRatio, kHiRatio, kAttack, kRelease, kMakeup;
	var w = Window.new(bounds:Rect(1000, 100, 100, 400), resizable: false);
	var a = LevelIndicator(w, bounds:Rect(0, 0, 50, 400));
	var b = LevelIndicator(w, bounds:Rect(50, 0, 50, 400));
	
	o = OSCFunc({arg msg;
		{
			a.value = msg[3].ampdb.linlin(-40, 0, 0, 1);
        	a.peakLevel = msg[4].ampdb.linlin(-40, 0, 0, 1);
		}.defer;
	}, '/levels_pre', s.addr);
	p = OSCFunc({arg msg;
    	{
        	b.value = msg[3].ampdb.linlin(-40, 0, 0, 1);
        	b.peakLevel = msg[4].ampdb.linlin(-40, 0, 0, 1);
    	}.defer;
	}, '/levels_post', s.addr);
	f = FancySlider(w, Rect(0, 0, 100, 400));
	f.value_(1);
	f.sliderColor = Color.blue(alpha: 0.2);
	f.action_({
		control.setSynchronous(f.value);
		});
	kLoRatio = Knob.new(w, 	Rect(10, 10, 30, 30))
		.centered_(true)
		.action_({|v,x,y,m|
			postf("below ratio : %\n", 0.5 + v.value);
			control.setAt(1, 0.5 + v.value);
			})
		.value_(0.5);
	kHiRatio = Knob.new(w, 	Rect(10, 40, 30, 30)).centered_(true)
		.centered_(true)
		.action_({|v,x,y,m|
			postf("above ratio : %\n", 0.5 + v.value);
			control.setAt(2, 0.5 + v.value);
			})
		.value_(0.5);
	kAttack = Knob.new(w, 	Rect(10, 70, 30, 30)).centered_(true)
		.action_({|v,x,y,m|
			postf("attack time : %\n", v.value);
			control.setAt(3, v.value);
			})
		.value_(0.1);
	kRelease = Knob.new(w, 	Rect(10, 100, 30, 30)).centered_(true)
		.action_({|v,x,y,m|
			postf("release time: %\n", v.value);
			control.setAt(4, v.value);
			})
		.value_(0.1);
	kMakeup = Knob.new(w, 	Rect(10, 130, 30, 30)).centered_(true)
		.centered_(true)
		.action_({|v,x,y,m|
			postf("makeup db   : %\n", v.value - 0.5);
			control.setAt(5, 4 * (v.value - 0.5));
			})
		.value_(0.5);

	a.drawsPeak_(true);
	b.drawsPeak_(true);
	w.alpha = 0.8;
	w.alwaysOnTop_(true);
	w.front;
};

~setSlopeBelow = { arg val;
	control.setAt(1, val);
};

~setSlopeAbove = { arg val;
	control.setAt(2, val);
};

~setAttack = { arg val;
	control.setAt(3, val);
};

~setRelease = { arg val;
	control.setAt(4, val);
};