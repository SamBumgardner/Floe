package entities;

import entities.Tile;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Border extends Tile {

	static public var borderImage:Image;
	static private var graphicInit:Bool = false;
	
	
	// Constructor
	
	public override function new(x:Int, y:Int){
		super(x,y);
		if(!graphicInit) {
			Border.borderImage = new Image("graphics/rock.png");
			graphicInit = true;
		}
		
		graphic = borderImage;
		
		type = "border";
	}	
}