var subscribers = Set();
var rows = 128, columns = 128;

var sequencer = 'sequencer'.import.new(120);

var fsm = Dictionary.with(*[
		'OFF' -> 'READY',
		'PLAYING' -> 'QUEUED_STOP',
		'QUEUED_PLAY' -> 'PLAYING',
		'STOPPED' -> ['READY', 'OFF'],
		'READY' -> ['QUEUED_PLAY', 'OFF'],
		'QUEUED_STOP' -> 'STOPPED'
	]);

~states = M {
	fsm.keys;
};

~parentEnv = Environment.make {
	/*
	--------------------------------------------------------------
	necessary keys inherited by grid items for proper functioning:
	--------------------------------------------------------------
	*/
	~quant = 1;
	~x = nil;
	~y = nil;
	~clock = sequencer.clock;
	~status = 'OFF';
	~emit = M { arg status;
		/*
		use this block instead if you want to control the state transitions
		of grid items as a finite state machine (not totally necessary)
		if (Set.with(*fsm[~status]).includes(status), {
			~status = status;
			subscribers.do(_.setStatus(~x, ~y, status));
			format("PLAYABLE GRID: % %", ~status, [~x, ~y]).postln;
			});
		currentEnvironment;			
		*/
		~status = status;
		subscribers.do(_.setStatus(~x, ~y, status));
		format("PLAYABLE GRID: % %", ~status, [~x, ~y]).postln;
		currentEnvironment;
	};

	/*
	-------------------------------------------------------------
	everything else you can define yourself, especially 'play'
	and 'stop' methods
	-------------------------------------------------------------
	*/
	~play = M {}
};

~colProtos = Array.fill(columns, { arg i;
	Environment.make {
		/*
		-------------------------------------------------------------
		you can put here useful keys inherited by each item in the
		column, eg a bus or proxy for sending audio to,
		or input bus/proxies
		-------------------------------------------------------------
		*/
	}
});

~matrix = Array2D.new(rows, columns);

~insertAt = M { arg x, y, fn;
	var env = { fn.import }.try({ arg err;
		Environment.make(fn).know_(true);	
	});

	env.parent_(~parentEnv)
		.proto_(~colProtos[x])
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
		.reject({ arg item; item.y == y });
	sequencer.play(~matrix[y, x], toStop);
};

~stop = M { arg x, y; 
	sequencer.stop(~matrix[y, x]);
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