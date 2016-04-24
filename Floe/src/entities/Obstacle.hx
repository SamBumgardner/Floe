package entities;

import entities.Tile;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Obstacle extends Tile {

	static public var rockImage:Image;
	static private var graphicInit:Bool = false;
	
	// new()
	//
	// Constructor for the Obstacle class.
	
	public override function new(x:Int, y:Int){
		super(x,y);
		layer = 1;
		if(!graphicInit) {
			Obstacle.rockImage = new Image("graphics/groundRock.png");
			graphicInit = true;
		}
		
		graphic = rockImage;

		type = "obstacle";
	}	
}