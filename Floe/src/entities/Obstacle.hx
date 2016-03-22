package entities;

import entities.Tile;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Obstacle extends Tile {

	//A child of Tile needs its own copy of the static vars it will use 
	static public var commonImage:Image;
	static private var graphicInit:Bool = false;
	
	public override function new(x:Int, y:Int){
		super(x,y);
		if(!graphicInit) {
			Obstacle.commonImage = new Image("graphics/groundRock.png");
			graphicInit = true;
		}
		//need to reset graphic
		graphic = commonImage;
		type = "obstacle";
	}	
}