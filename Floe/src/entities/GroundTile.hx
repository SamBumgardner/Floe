package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class GroundTile extends Entity
{
	
	
	public function new(x:Int, y:Int)
	{
		super(x, y);
		setHitbox(32,32);
		type = "groundTile";
		graphic = new Image("graphics/Ground_Basic.png");
		layer = 1;
	}

}