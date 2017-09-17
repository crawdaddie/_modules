// fx utils

// ~sends = [];

~setUp = { arg e, fx;
	var calling_env = currentEnvironment;
	~input = NodeProxy.audio(s, 2);
	fx.map(\in, ~input);
	
	// // add calling environment (an effect module) to list of 'sends'
	// e.use {
	// 	~sends.add(calling_env);
	// };


	~addToInput = { arg e, prox, index;
		e.use {
			if ( ~input.source.notNil, {
				if (index.notNil {
					~input.put(index, prox);
					}, {
					~input.add(prox)
				});
				}, {
				~input.source = prox;
			});
			~input;
		}
	};
};


