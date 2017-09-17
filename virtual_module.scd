~create = { arg e, path, extra;
	var currentDir = ~path.dirname;
	var thisPath = currentDir +/+ path;
	Import.addPathKey(thisPath);
	Import.addOpenCommand(thisPath);
	Import.registerModule(currentEnvironment);

}
