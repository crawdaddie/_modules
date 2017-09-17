// preset utils
~add = {
	~savePreset = { arg e, name;
		e.use {
			var path = ~path.dirname ++ name;
			currentEnvironment = Object.readFromArchive(path);
		}
	};

	~loadFromPreset = { arg e, name;
		var env = e;
	};
};



