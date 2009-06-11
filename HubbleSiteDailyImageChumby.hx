import flash.MovieClip;
import flash.TextField;
import haxe.Timer;

class HubbleSiteDailyImageChumby {
  private static var imageHolder:MovieClip;
  private static var logoHolder:MovieClip;
  private static var myClip:MovieClip;
  private static var xmlFast:haxe.xml.Fast;
  private static var textBlock:TextField;

  private static var hubbleSiteLogo:String = "http://hubblesite.org/gallery/album/graphics/hs_logo_image_ofthe_day.jpg";
  private static var logoWidth:Int = 280;

  private static var dailyImageURL:String = "http://hubblesite.org/gallery/album/daily_image.php";  
  
  /**
   * Initialize the widget.
   */
	static public function main() {
		myClip = flash.Lib.current;
		
		myClip.onEnterFrame = function() {
		  myClip.onEnterFrame = function():Void {};
		  loadLogo();
		}
  }

  /**
   * Load the HubbleSite Image of the Day logo.
   */
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
          var t:Timer = new Timer(3000);
          t.run = function() {
            t.stop();
            loadXml();
          }
        });
      } 
    }
    loader.loadClip(hubbleSiteLogo, logoHolder);
  }
  
  /**
   * Load the XML data from HubbleSite.
   */
  public static function loadXml() {
    var loadVars = new flash.LoadVars();
    loadVars.onData = function(s:String) {
      xmlFast = new haxe.xml.Fast(Xml.parse(s).firstElement());
      showTitle();
    }
    loadVars.load(dailyImageURL);		       
  }

  /**
   * Show the image title.
   */
  public static function showTitle() {
    myClip.createTextField("title",
                          50,
                          20,
                          50,
                          flash.Stage.width - 40,
                          flash.Stage.height - 100);
    textBlock = Reflect.field(myClip, "title");
    
    var textFormat:flash.TextFormat = new flash.TextFormat();
    textFormat.align = "center";    
    
    textBlock._visible = false;
    textBlock.multiline = true;
    textBlock.wordWrap = true;
    textBlock.selectable = false;
    textBlock.html = true;
    textBlock.setNewTextFormat(textFormat);    
    
    textBlock.htmlText = "<p align='center'><font face='Helvetica' size='22' color='#ffffff'><b>"
                       + xmlFast.node.title.innerHTML
                       + "</b></font></p>";
    
    fadeOut(logoHolder, function() {
      logoHolder.removeMovieClip();
      var show_t:Timer = new Timer(250);
      show_t.run = function() {
        show_t.stop();
        textBlock._visible = true;
        var t:Timer = new Timer(xmlFast.node.title.innerHTML.length * 70);
        t.run = function() {
          loadImage(); t.stop();
        };
      }
    });
  }
    
  /**
   * Load the image.
   */
  public static function loadImage() {
    imageHolder = myClip.createEmptyMovieClip("imageholder", myClip.getNextHighestDepth());

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
        textBlock._visible = false;          
        fadeIn(target, function(){});
        
        target.onEnterFrame = function() {};
      }
    }
    loader.loadClip(xmlFast.node.image_url.innerHTML, imageHolder);
  }

  /**
   * Fade a movie clip.
   */
  public static function fade(target:MovieClip, c:Void->Void, ?out:Bool = false) {
    var timer:Timer = new Timer(40);
    
    target._alpha = (out ? 100 : 0);
    
    timer.run = function() {
      target._alpha += (out ? -10 : 10);
      if ((target._alpha <= 0) || (target._alpha >= 100)) {
        timer.stop(); c();
      }
    }            
  }
  
  public static function fadeIn(target:MovieClip, c:Void->Void) {
    fade(target, c, false);
  }
  
  public static function fadeOut(target:MovieClip, c:Void->Void) {
    fade(target, c, true); 
  }
}