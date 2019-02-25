// sequencer for use with playableGrid

~new = M { arg bpm;
	Environment.make({
		~clock = TempoClock.new(bpm/60);
		~play = M { arg item, toStop;
			
			item.emit('QUEUED_PLAY');
			toStop.do(_.emit('QUEUED_STOP'));
			
			~clock.play({
				item.play;
				item.emit('PLAYING');
				
				toStop.do({ arg stoppingItem;
					stoppingItem.stop;
					stoppingItem.emit('STOPPED');
				});
			
			}, item.quant);
		};

		~stop = M { arg item, toStop;

			item.emit('QUEUED_STOP');

			~clock.play({
				item.stop;
				item.emit('STOPPED');
				}, item.quant)
		}
	}).know_(true)
}