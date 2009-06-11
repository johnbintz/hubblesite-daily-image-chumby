import flash.MovieClip;

class HubbleSiteDailyImageChumby {
  private static var imageHolder:MovieClip;
  private static var logoHolder:MovieClip;
  private static var myClip:MovieClip;
  private static var logoWidth:Int = 280;
  
	static public function main() {
	  var initialized:Bool = false;
	 
		myClip = flash.Lib.current;
		
		myClip.onEnterFrame = function() {
		  initialized = true;
		  myClip.onEnterFrame = function():Void {};
		  loadLogo();
		}
  }
  
  public static function loadImage() {
    imageHolder = myClip.createEmptyMovieClip("imageholder", myClip.getNextHighestDepth());

    var loadVars = new flash.LoadVars();
    loadVars.onData = function(s:String) {
      var xmlfast = new haxe.xml.Fast(Xml.parse(s).firstElement());
      
      var loader:flash.MovieClipLoader = new flash.MovieClipLoader();
      loader.onLoadComplete = function(target:MovieClip) {
        target.onEnterFrame = function() {
          target._alpha = 0;
          if (target._width > target._height) {
            var newHeight:Float = (target._height * flash.Stage.width) / target._width;
            target._width = flash.Stage.width;
            target._y = (flash.Stage.height - newHeight) / 2;
            target._height = newHeight;
          } else {
            var newWidth:Float = (target._width * flash.Stage.height) / target._height;
            target._height = flash.Stage.height;
            target._x = (flash.Stage.width - newWidth) / 2;
            target._width = newWidth;
          }
          target.onEnterFrame = function() {};
          
          fadeIn(target, function(){});
        }
      }
      loader.loadClip(xmlfast.node.image_url.innerHTML, imageHolder);
    }
    loadVars.load('http://hubblesite.org/gallery/album/daily_image.php');		   
  }
  
  public static function loadLogo() {
    logoHolder = myClip.createEmptyMovieClip("logoholder", myClip.getNextHighestDepth());
    
    var loader:flash.MovieClipLoader = new flash.MovieClipLoader();
    loader.onLoadComplete = function(target:MovieClip) {
      target.onEnterFrame = function() {
        target.onEnterFrame = function() {};
        
        var newHeight:Float = (target._height * logoWidth) / target._width;
        target._width = logoWidth;
        target._x =  (flash.Stage.width - logoWidth) / 2;
        target._y = (flash.Stage.height - newHeight) / 2;
        target._height = newHeight;
        
        fadeIn(target, function() {
          var t:haxe.Timer = new haxe.Timer(1500);
          t.run = function() {
            t.stop();
            loadImage();
          }
        });
      } 
    }
    loader.loadClip("http://hubblesite.org/gallery/graphics/gallery_nav_logo.gif", logoHolder);
  }
  
  public static function fadeIn(target:MovieClip, c:Void->Void) {
    var timer:haxe.Timer = new haxe.Timer(40);
    target._alpha = 0;
    timer.run = function() {
      target._alpha += 10;
      if (target._alpha >= 100) {
        timer.stop();
        c();
      } 
    }    
  }
}