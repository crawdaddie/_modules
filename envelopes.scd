// env + gui module



~new = { arg module, envelope;
	var envir = Environment.make({
		var env, editor, sort;
		~env = envelope ? Env.new([0,1,0.5,0.5,0],[0.1,0.4,0.5,0.1].normalize, curve: 0);
		sort = ~env.levels.sort;
		editor = EnvScaleView.new;
		editor.minRange_(sort.first);
		editor.maxRange_(sort.last);
		editor.env = ~env;
		~edit = {
			var view = editor.view;
			if (editor.view.isClosed,
				{
					editor = EnvScaleView.new;
					editor.env = env;
					editor.view.front;
				},
				{
					view.front;
				}
			);
		};
		~editor = editor;
		// ~env = env;
	});
	envir.know = true;
	envir;
};


~newRand = { arg module; 
	var envir = Environment.make({
		var env, editor;
		env = Env.new([0,1,0.5,0.5,0],[0.1,0.4,0.5,0.1].normalize, curve: 0);
		editor = EnvScaleView.new;
		editor.env = env;
		~edit = {
			var view = editor.view;

			if (editor.view.isClosed,
				{
					editor = EnvScaleView.new;
					editor.env = env;
					editor.view.front;
				},
				{
					view.front;
				}
			);
		};
		~editor = editor;
		~env = env;
	});
	envir.know = true;
	envir;
};

~newAutomation = { arg module, points = 5;
	var envir = Environment.make({
		var editor;
		~env = Env.new(Array.fill(points, {rrand(0,1.0)}), Array.fill(points - 1, {rrand(0.1,1.0)}).normalize, curve: 0);
		editor = EnvScaleView.new;
		~editor = editor;
		editor.env = ~env;
		~edit = {
			editor.view.front;
		};
	});
	envir.know = true;
	envir;
};

~insertToSynth = { arg module, points = 3, ctlname = \ampenv;
		var ampenv = Env.adsr(0.1, 0.2, 0.5, 1);
		ctlname.asSymbol.kr(ampenv.asArray);
};


