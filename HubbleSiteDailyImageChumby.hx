class HubbleSiteDailyImageChumby {
	static public function main() {
		var xml:Xml = Xml.createElement("gallery");
		var myClip:flash.MovieClip = flash.Lib.current;

		var t:flash.TextField = myClip.createTextField("test", 1, 0, 0, 200, 200);

		flash.XMLRequest.load('http://hubblesite.org/gallery/album/daily_image.php',
													xml,
													onData
											    );
  }
	
	static private function onData(data : Null<String>):Void {
		trace("made it here");
	}
}