~setUp = { arg e, initialSize = 16;
	~output = NodeProxy.audio(s, 2);
	~proxyList = Array.fill(initialSize, { arg i;
		var proxy = NodeProxy.audio(s, 2);
		~output.put(i, proxy);
		proxy;
		});
	~insert = { arg e, index, source;
		e.use {
			~proxyList[index].source = source;
		}
	};
};


