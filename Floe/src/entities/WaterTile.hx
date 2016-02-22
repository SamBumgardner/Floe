package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import entities.IceTile;
import com.haxepunk.HXP;

class WaterTile extends Entity
{
	public function new(x:Int, y:Int)
	{
		super(x, y);
		setHitbox(32,32);
		type = "waterTile";
		graphic = new Image("graphics/water.png");
		layer = 1;
	}
	public function freeze()
	{
		scene.add(new IceTile(Std.int(x), Std.int(y)));
		scene.remove(this);
	}
	public function freezeCheck(){
		/*This is going to figure out if the water is supposed to freeze over.*/
	
	}
	private function numOfNeighbors(){
		/*Going to use this to implement a hacky sort of water-freezing solution. 
			Recursively check number of  neighbors. 
			keep adding neighbors -1 (can't count neighbor you came from). 
			Probably need to use ids to ensure we don't double count, although if our freeze threshold is 3, we don't need to.
			*/
	}
}