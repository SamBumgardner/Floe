package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import entities.WaterTile;

class IceTile extends Entity
{
	public function new(x:Int, y:Int)
	{
		super(x, y);
		setHitbox(32,32);
		type = "iceTile";
		graphic = new Image("graphics/ice.png");
		layer = 1;
	}
	public function melt()
	{
		scene.add(new WaterTile(200, 200));
		scene.remove(this);
	}
}