package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Obstacle extends Entity{
	
	public override function new(){
		graphic = new Image("graphics\block.png");
		setHitbox(32, 32);
		type = "obstacle";
	}
	
	
	
}