var subscribers = Set();

~sequencer = 'sequencer'.import.new(120);

~parentEnv = Environment.make {
	~quant = 1;
	~x = nil;
	~y = nil;
	~emit = M { arg status;
		~status = status;
		subscribers.do(_.setStatus(~x, ~y, status));
		currentEnvironment;
	};
	~play = M {}
};

~colProtos = Array.fill(128, { Environment() });

~matrix = Array2D.new(128, 128);

~insertAt = M { arg x, y, fn;
	var env = { fn.import }.try({ arg err;
		Environment.make(fn);	
	});

	env.parent_(~parentEnv)
		.proto_(~colProtos[x])
		.know_(true)
		.make({ ~x = x; ~y = y })
		.emit('READY');

	~matrix[y, x] = env;
};

~move = M { arg x, y, xx, yy;
	var env = ~matrix[y, x];
	
	~matrix[y, x] = nil;
	
	env.emit('OFF')
		.proto_(~colProtos[xx])
		.make({ ~x = xx; ~y = yy })
		.emit('READY');

	~matrix[yy, xx] = env;
};

~copyItem = M { arg x, y, xx, yy;
	var env = ~matrix[y, x].copy;
	
	env.proto_(~colProtos[xx])
		.make({ ~x = xx; ~y = yy })
		.emit('READY');
	
	~matrix[yy, xx] = env;
};

// ~moveCol = M { arg x, xx;
// 	~matrix.colAt(x).do({ arg item, y;
// 		currentEnvironment.move(x, y, xx, y);
// 		});
// };

// ~moveRow = M { arg y, yy;
// 	~matrix.rowAt(y).do({ arg item, x;
// 		currentEnvironment.move(x, y, x, yy);
// 		});
// };

~get = M { arg x, y; 
	~matrix[y, x];
};

~getPlaying = M { arg x;
	currentEnvironment.getCol(x)
		.removeEvery([nil])
		.select({ arg item; item.status == 'PLAYING'});
};

~play = M { arg x, y;
	var toStop = currentEnvironment.getPlaying(x)
		.reject({ arg item; item.x == x && item.y == y });
	~sequencer.play(~matrix[y, x], toStop);
};

~stop = M { arg x, y; 
	~sequencer.stop(~matrix[y, x]);
};


~getRow = M { arg y;
	~matrix.rowAt(y);
};

~getCol = M { arg x;
	~matrix.colAt(x);
};

~parentUse = M { arg fn;
	~parentEnv.use(fn);
};

~colUse = M { arg x, fn;
	~colProtos[x].use(fn);
};

/*
----------------------------------
 launchpad actions
----------------------------------
*/

~initLaunchpad = M {
	~launchpad = 'launchpad'.import;
	subscribers.add(~launchpad);
	~launchpad.addSubscriber(currentEnvironment);
};


~noteOn = M { arg x, y;
	currentEnvironment.play(x, y);
};

~noteOff = M { arg x, y;
};

~rowNoteOn = M { arg y;
	currentEnvironment.getRow(y)
		.do({ arg item, x;
			if (item.notNil, {
				currentEnvironment.play(x, y);
				})
			});
};

~rowNoteOff = M { arg y;
};