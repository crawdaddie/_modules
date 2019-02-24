// preset utils
~add = {
	~savePreset = M { name;
		var path = ~path.dirname ++ name;
		currentEnvironment = Object.readFromArchive(path);
	};

	~loadFromPreset = { arg e, name;
		var env = e;
	};
};



