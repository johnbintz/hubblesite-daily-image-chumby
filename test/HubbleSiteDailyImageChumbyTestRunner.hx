class HubbleSiteDailyImageChumbyTestRunner {
  static function main() {
    var r = new haxe.unit.TestRunner();
		r.add(new RemoteXMLReaderTest());
    r.run();
  }
}
