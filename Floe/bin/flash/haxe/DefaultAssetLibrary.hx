package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Future;
import lime.app.Preloader;
import lime.app.Promise;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.net.HTTPRequest;
import lime.system.CFFI;
import lime.text.Font;
import lime.utils.Bytes;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if (openfl && !flash)
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__font_04b_03___ttf);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#end
		
		#if flash
		
		className.set ("graphics/debug/console_debug.png", __ASSET__graphics_debug_console_debug_png);
		type.set ("graphics/debug/console_debug.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_hidden.png", __ASSET__graphics_debug_console_hidden_png);
		type.set ("graphics/debug/console_hidden.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_logo.png", __ASSET__graphics_debug_console_logo_png);
		type.set ("graphics/debug/console_logo.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_output.png", __ASSET__graphics_debug_console_output_png);
		type.set ("graphics/debug/console_output.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_pause.png", __ASSET__graphics_debug_console_pause_png);
		type.set ("graphics/debug/console_pause.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_play.png", __ASSET__graphics_debug_console_play_png);
		type.set ("graphics/debug/console_play.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_step.png", __ASSET__graphics_debug_console_step_png);
		type.set ("graphics/debug/console_step.png", AssetType.IMAGE);
		className.set ("graphics/debug/console_visible.png", __ASSET__graphics_debug_console_visible_png);
		type.set ("graphics/debug/console_visible.png", AssetType.IMAGE);
		className.set ("graphics/preloader/haxepunk.png", __ASSET__graphics_preloader_haxepunk_png);
		type.set ("graphics/preloader/haxepunk.png", AssetType.IMAGE);
		className.set ("font/04B_03__.ttf", __ASSET__font_04b_03___ttf);
		type.set ("font/04B_03__.ttf", AssetType.FONT);
		className.set ("font/04B_03__.ttf.png", __ASSET__font_04b_03___ttf_png);
		type.set ("font/04B_03__.ttf.png", AssetType.IMAGE);
		className.set ("graphics/Blank 32x32.png", __ASSET__graphics_blank_32x32_png);
		type.set ("graphics/Blank 32x32.png", AssetType.IMAGE);
		className.set ("graphics/block.png", __ASSET__graphics_block_png);
		type.set ("graphics/block.png", AssetType.IMAGE);
		className.set ("graphics/friend.png", __ASSET__graphics_friend_png);
		type.set ("graphics/friend.png", AssetType.IMAGE);
		className.set ("graphics/goodfriend.png", __ASSET__graphics_goodfriend_png);
		type.set ("graphics/goodfriend.png", AssetType.IMAGE);
		className.set ("graphics/Ground Rock.png", __ASSET__graphics_ground_rock_png);
		type.set ("graphics/Ground Rock.png", AssetType.IMAGE);
		className.set ("graphics/Ground Trees.png", __ASSET__graphics_ground_trees_png);
		type.set ("graphics/Ground Trees.png", AssetType.IMAGE);
		className.set ("graphics/ground.png", __ASSET__graphics_ground_png);
		type.set ("graphics/ground.png", AssetType.IMAGE);
		className.set ("graphics/ground2.png", __ASSET__graphics_ground2_png);
		type.set ("graphics/ground2.png", AssetType.IMAGE);
		className.set ("graphics/Ground_Basic.png", __ASSET__graphics_ground_basic_png);
		type.set ("graphics/Ground_Basic.png", AssetType.IMAGE);
		className.set ("graphics/Ground_Winter.png", __ASSET__graphics_ground_winter_png);
		type.set ("graphics/Ground_Winter.png", AssetType.IMAGE);
		className.set ("graphics/ice.png", __ASSET__graphics_ice_png);
		type.set ("graphics/ice.png", AssetType.IMAGE);
		className.set ("graphics/ice2.png", __ASSET__graphics_ice2_png);
		type.set ("graphics/ice2.png", AssetType.IMAGE);
		className.set ("graphics/ice_placeholder.png", __ASSET__graphics_ice_placeholder_png);
		type.set ("graphics/ice_placeholder.png", AssetType.IMAGE);
		className.set ("graphics/otherFriend.png", __ASSET__graphics_otherfriend_png);
		type.set ("graphics/otherFriend.png", AssetType.IMAGE);
		className.set ("graphics/rock.png", __ASSET__graphics_rock_png);
		type.set ("graphics/rock.png", AssetType.IMAGE);
		className.set ("graphics/water.png", __ASSET__graphics_water_png);
		type.set ("graphics/water.png", AssetType.IMAGE);
		className.set ("graphics/watermove.png", __ASSET__graphics_watermove_png);
		type.set ("graphics/watermove.png", AssetType.IMAGE);
		className.set ("graphics/water_placeholder.png", __ASSET__graphics_water_placeholder_png);
		type.set ("graphics/water_placeholder.png", AssetType.IMAGE);
		
		
		#elseif html5
		
		var id;
		id = "graphics/debug/console_debug.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_hidden.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_logo.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_output.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_pause.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_play.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_step.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/debug/console_visible.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/preloader/haxepunk.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "font/04B_03__.ttf";
		className.set (id, __ASSET__font_04b_03___ttf);
		
		type.set (id, AssetType.FONT);
		id = "font/04B_03__.ttf.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/Blank 32x32.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/block.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/friend.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/goodfriend.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/Ground Rock.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/Ground Trees.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/ground.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/ground2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/Ground_Basic.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/Ground_Winter.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/ice.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/ice2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/ice_placeholder.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/otherFriend.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/rock.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/water.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/watermove.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "graphics/water_placeholder.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		
		
		var assetsPrefix = null;
		if (ApplicationMain.config != null && Reflect.hasField (ApplicationMain.config, "assetsPrefix")) {
			assetsPrefix = ApplicationMain.config.assetsPrefix;
		}
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("graphics/debug/console_debug.png", __ASSET__graphics_debug_console_debug_png);
		type.set ("graphics/debug/console_debug.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_hidden.png", __ASSET__graphics_debug_console_hidden_png);
		type.set ("graphics/debug/console_hidden.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_logo.png", __ASSET__graphics_debug_console_logo_png);
		type.set ("graphics/debug/console_logo.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_output.png", __ASSET__graphics_debug_console_output_png);
		type.set ("graphics/debug/console_output.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_pause.png", __ASSET__graphics_debug_console_pause_png);
		type.set ("graphics/debug/console_pause.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_play.png", __ASSET__graphics_debug_console_play_png);
		type.set ("graphics/debug/console_play.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_step.png", __ASSET__graphics_debug_console_step_png);
		type.set ("graphics/debug/console_step.png", AssetType.IMAGE);
		
		className.set ("graphics/debug/console_visible.png", __ASSET__graphics_debug_console_visible_png);
		type.set ("graphics/debug/console_visible.png", AssetType.IMAGE);
		
		className.set ("graphics/preloader/haxepunk.png", __ASSET__graphics_preloader_haxepunk_png);
		type.set ("graphics/preloader/haxepunk.png", AssetType.IMAGE);
		
		className.set ("font/04B_03__.ttf", __ASSET__font_04b_03___ttf);
		type.set ("font/04B_03__.ttf", AssetType.FONT);
		
		className.set ("font/04B_03__.ttf.png", __ASSET__font_04b_03___ttf_png);
		type.set ("font/04B_03__.ttf.png", AssetType.IMAGE);
		
		className.set ("graphics/Blank 32x32.png", __ASSET__graphics_blank_32x32_png);
		type.set ("graphics/Blank 32x32.png", AssetType.IMAGE);
		
		className.set ("graphics/block.png", __ASSET__graphics_block_png);
		type.set ("graphics/block.png", AssetType.IMAGE);
		
		className.set ("graphics/friend.png", __ASSET__graphics_friend_png);
		type.set ("graphics/friend.png", AssetType.IMAGE);
		
		className.set ("graphics/goodfriend.png", __ASSET__graphics_goodfriend_png);
		type.set ("graphics/goodfriend.png", AssetType.IMAGE);
		
		className.set ("graphics/Ground Rock.png", __ASSET__graphics_ground_rock_png);
		type.set ("graphics/Ground Rock.png", AssetType.IMAGE);
		
		className.set ("graphics/Ground Trees.png", __ASSET__graphics_ground_trees_png);
		type.set ("graphics/Ground Trees.png", AssetType.IMAGE);
		
		className.set ("graphics/ground.png", __ASSET__graphics_ground_png);
		type.set ("graphics/ground.png", AssetType.IMAGE);
		
		className.set ("graphics/ground2.png", __ASSET__graphics_ground2_png);
		type.set ("graphics/ground2.png", AssetType.IMAGE);
		
		className.set ("graphics/Ground_Basic.png", __ASSET__graphics_ground_basic_png);
		type.set ("graphics/Ground_Basic.png", AssetType.IMAGE);
		
		className.set ("graphics/Ground_Winter.png", __ASSET__graphics_ground_winter_png);
		type.set ("graphics/Ground_Winter.png", AssetType.IMAGE);
		
		className.set ("graphics/ice.png", __ASSET__graphics_ice_png);
		type.set ("graphics/ice.png", AssetType.IMAGE);
		
		className.set ("graphics/ice2.png", __ASSET__graphics_ice2_png);
		type.set ("graphics/ice2.png", AssetType.IMAGE);
		
		className.set ("graphics/ice_placeholder.png", __ASSET__graphics_ice_placeholder_png);
		type.set ("graphics/ice_placeholder.png", AssetType.IMAGE);
		
		className.set ("graphics/otherFriend.png", __ASSET__graphics_otherfriend_png);
		type.set ("graphics/otherFriend.png", AssetType.IMAGE);
		
		className.set ("graphics/rock.png", __ASSET__graphics_rock_png);
		type.set ("graphics/rock.png", AssetType.IMAGE);
		
		className.set ("graphics/water.png", __ASSET__graphics_water_png);
		type.set ("graphics/water.png", AssetType.IMAGE);
		
		className.set ("graphics/watermove.png", __ASSET__graphics_watermove_png);
		type.set ("graphics/watermove.png", AssetType.IMAGE);
		
		className.set ("graphics/water_placeholder.png", __ASSET__graphics_water_placeholder_png);
		type.set ("graphics/water_placeholder.png", AssetType.IMAGE);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						onChange.dispatch ();
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == TEXT && assetType == BINARY) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), Bytes));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):Bytes {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return Bytes.ofData (cast (Type.createInstance (className.get (id), []), flash.utils.ByteArray));
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return Bytes.ofData (bitmapData.getPixels (bitmapData.rect));
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), Bytes);
		
		#elseif html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Bytes);
		else return Bytes.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes.getString (0, bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.getString (0, bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String):Future<AudioBuffer> {
		
		var promise = new Promise<AudioBuffer> ();
		
		#if (flash)
		
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				promise.complete (audioBuffer);
				
			});
			soundLoader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			soundLoader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getAudioBuffer (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<AudioBuffer> (function () return getAudioBuffer (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadBytes (id:String):Future<Bytes> {
		
		var promise = new Promise<Bytes> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = Bytes.ofString (event.currentTarget.data);
				promise.complete (bytes);
				
			});
			loader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			promise.completeWith (request.load (path.get (id) + "?" + Assets.cache.version));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Bytes> (function () return getBytes (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadImage (id:String):Future<Image> {
		
		var promise = new Promise<Image> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				promise.complete (Image.fromBitmapData (bitmapData));
				
			});
			loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var image = new js.html.Image ();
			image.onload = function (_):Void {
				
				promise.complete (Image.fromImageElement (image));
				
			}
			image.onerror = promise.error;
			image.src = path.get (id) + "?" + Assets.cache.version;
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Image> (function () return getImage (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = Bytes.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = Bytes.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = Bytes.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = Bytes.readFile ("../Resources/manifest");
			#elseif (ios || tvos)
			var bytes = Bytes.readFile ("assets/manifest");
			#else
			var bytes = Bytes.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				if (bytes.length > 0) {
					
					var data = bytes.getString (0, bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if (ios || tvos)
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadText (id:String):Future<String> {
		
		var promise = new Promise<String> ();
		
		#if html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			var future = request.load (path.get (id) + "?" + Assets.cache.version);
			future.onProgress (function (progress) promise.progress (progress));
			future.onError (function (msg) promise.error (msg));
			future.onComplete (function (bytes) promise.complete (bytes.getString (0, bytes.length)));
			
		} else {
			
			promise.complete (getText (id));
			
		}
		
		#else
		
		promise.completeWith (loadBytes (id).then (function (bytes) {
			
			return new Future<String> (function () {
				
				if (bytes == null) {
					
					return null;
					
				} else {
					
					return bytes.getString (0, bytes.length);
					
				}
				
			});
			
		}));
		
		#end
		
		return promise.future;
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_debug_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_hidden_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_logo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_output_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_pause_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_play_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_step_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_debug_console_visible_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_preloader_haxepunk_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__font_04b_03___ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__font_04b_03___ttf_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_blank_32x32_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_block_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_friend_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_goodfriend_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground_rock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground_trees_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground_basic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ground_winter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ice_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ice2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_ice_placeholder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_otherfriend_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_rock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_water_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_watermove_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__graphics_water_placeholder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }


#elseif html5










@:keep #if display private #end class __ASSET__font_04b_03___ttf extends lime.text.Font { public function new () { super (); name = "04b03"; } } 





















#else



#if (windows || mac || linux || cpp)


@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_debug.png") #if display private #end class __ASSET__graphics_debug_console_debug_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_hidden.png") #if display private #end class __ASSET__graphics_debug_console_hidden_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_logo.png") #if display private #end class __ASSET__graphics_debug_console_logo_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_output.png") #if display private #end class __ASSET__graphics_debug_console_output_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_pause.png") #if display private #end class __ASSET__graphics_debug_console_pause_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_play.png") #if display private #end class __ASSET__graphics_debug_console_play_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_step.png") #if display private #end class __ASSET__graphics_debug_console_step_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/debug/console_visible.png") #if display private #end class __ASSET__graphics_debug_console_visible_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/graphics/preloader/haxepunk.png") #if display private #end class __ASSET__graphics_preloader_haxepunk_png extends lime.graphics.Image {}
@:font("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/font/04B_03__.ttf") #if display private #end class __ASSET__font_04b_03___ttf extends lime.text.Font {}
@:image("C:/HaxeToolkit/haxe/lib/HaxePunk/2,5,5/assets/font/04B_03__.ttf.png") #if display private #end class __ASSET__font_04b_03___ttf_png extends lime.graphics.Image {}
@:image("assets/graphics/Blank 32x32.png") #if display private #end class __ASSET__graphics_blank_32x32_png extends lime.graphics.Image {}
@:image("assets/graphics/block.png") #if display private #end class __ASSET__graphics_block_png extends lime.graphics.Image {}
@:image("assets/graphics/friend.png") #if display private #end class __ASSET__graphics_friend_png extends lime.graphics.Image {}
@:image("assets/graphics/goodfriend.png") #if display private #end class __ASSET__graphics_goodfriend_png extends lime.graphics.Image {}
@:image("assets/graphics/Ground Rock.png") #if display private #end class __ASSET__graphics_ground_rock_png extends lime.graphics.Image {}
@:image("assets/graphics/Ground Trees.png") #if display private #end class __ASSET__graphics_ground_trees_png extends lime.graphics.Image {}
@:image("assets/graphics/ground.png") #if display private #end class __ASSET__graphics_ground_png extends lime.graphics.Image {}
@:image("assets/graphics/ground2.png") #if display private #end class __ASSET__graphics_ground2_png extends lime.graphics.Image {}
@:image("assets/graphics/Ground_Basic.png") #if display private #end class __ASSET__graphics_ground_basic_png extends lime.graphics.Image {}
@:image("assets/graphics/Ground_Winter.png") #if display private #end class __ASSET__graphics_ground_winter_png extends lime.graphics.Image {}
@:image("assets/graphics/ice.png") #if display private #end class __ASSET__graphics_ice_png extends lime.graphics.Image {}
@:image("assets/graphics/ice2.png") #if display private #end class __ASSET__graphics_ice2_png extends lime.graphics.Image {}
@:image("assets/graphics/ice_placeholder.png") #if display private #end class __ASSET__graphics_ice_placeholder_png extends lime.graphics.Image {}
@:image("assets/graphics/otherFriend.png") #if display private #end class __ASSET__graphics_otherfriend_png extends lime.graphics.Image {}
@:image("assets/graphics/rock.png") #if display private #end class __ASSET__graphics_rock_png extends lime.graphics.Image {}
@:image("assets/graphics/water.png") #if display private #end class __ASSET__graphics_water_png extends lime.graphics.Image {}
@:image("assets/graphics/watermove.png") #if display private #end class __ASSET__graphics_watermove_png extends lime.graphics.Image {}
@:image("assets/graphics/water_placeholder.png") #if display private #end class __ASSET__graphics_water_placeholder_png extends lime.graphics.Image {}



#end
#end

#if (openfl && !flash)
@:keep #if display private #end class __ASSET__OPENFL__font_04b_03___ttf extends openfl.text.Font { public function new () { var font = new __ASSET__font_04b_03___ttf (); src = font.src; name = font.name; super (); }}

#end

#end