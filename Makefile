test: force_look
	haxe test.hxml && neko HubbleSiteDailyImageChumbyTestRunner.n
	rm HubbleSiteDailyImageChumbyTestRunner.n

force_look:
	true