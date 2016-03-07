package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Obstacle extends Entity{
	
	public override function new(x:Int, y:Int){
		super(x,y);
		graphic = new Image("graphics/groundRock.png");
		setHitbox(32, 32);
		type = "obstacle";
	}
	
	
	
}