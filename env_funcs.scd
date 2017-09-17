~insert_env = { arg segments = 5;
	var env = Env.newClear(segments);
	EnvGen.kr(\env.kr(env.asArray), \gate.tr(1), doneAction: 2);
};



~insert_ctl = { arg segments = 4;
	var ctl = \ctl.kr(4);
	ctl;
};


