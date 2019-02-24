var subscribers = Set();
~lp_colors = Dictionary.with(*[
	'OFF' -> 0x0C,
	'RED_THIRD' -> 0x0D,
	'RED_HALF' -> 0x0E,
	'RED_FULL' -> 0x0F,
	'RED_BLINK' -> 0x0B,
	'GREEN_THIRD' -> 0x1C,
	'GREEN_HALF' -> 0x2C,
	'GREEN_FULL' -> 0x3C,
	'GREEN_BLINK' -> 0x38,	
	'AMBER_THIRD' -> 0x1D,
	'AMBER_HALF' -> 0x2E,
	'AMBER_FULL' -> 0x3F,
	'AMBER_BLINK' -> 0x3B
]);

~statusDict = Dictionary.with(*[
	'OFF' -> 'OFF',
	'PLAYING' -> 'GREEN_FULL',
	'QUEUED_PLAY' -> 'AMBER_BLINK',
	'STOPPED' -> 'AMBER_FULL',
	'READY' -> 'AMBER_FULL',
	'QUEUED_STOP' -> 'GREEN_BLINK'
	]);

// midi output
MIDIClient.init();
MIDIClient.destinations.do({ arg item;
	if (item.name.contains("Launchpad"), {
		var lp_name = item.name;
		~lp_send = MIDIOut.newByName(lp_name, lp_name);
		format("connected to '%'", lp_name).postln;
		})
	});

// midi input
MIDIIn.connectAll();
~lp_inport = MIDIClient.sources.detect({ arg item;
	item.device.find("Launchpad").notNil
	}) !? _.uid ? 0;

MIDIdef.noteOn(\noteOnListener, { arg val, note, channel, src;
	var x, y;
	x = note % 16;
	y = (note / 16).asInteger;
	// [val, note, channel, src, x, y].postln;
	if (x == 8, {
		subscribers.do(_.rowNoteOn(y))
	}, {
		subscribers.do(_.noteOn(x, y))	
	})
	}, srcID: ~lp_inport);

MIDIdef.noteOff(\noteOffListener, { arg val, note, channel, src;
	var x, y;
	x = note % 16;
	y = (note / 16).asInteger;
	if (x == 8, {
		subscribers.do(_.rowNoteOff(y))
	}, {
		subscribers.do(_.noteOff(x, y))	
	})
	}, srcID: ~lp_inport);


// clear Launchpad
~lp_send.control(0, 0, 0x00); 	// CC0 - 0 = reset
~lp_send.control(0, 0, 0x28); // CC0 - 40 = enable blinking

~setColor = M { arg x, y, color;
	~lp_send.noteOn(0, 16 * y + x, ~lp_colors[color]);
};

~setStatus = M { arg x, y, status;
	currentEnvironment.setColor(x, y, ~statusDict[status.asSymbol]);
};

~addSubscriber = { arg ev, sub;
	subscribers.add(sub);
};

