package entities;

/* WaterTile interacts with GameScene's static variable GM at the following lines:
 * 
 * 	Line 39 in the freeze() function
 *  Line 87 in the autoFreeze() function
 * 
 * 
*/
	  
 

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

class WaterTile extends Entity
{
	private var frozen:Bool = false;
	
	
	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		setHitbox(32,32);
		type = "waterTile";
		graphic = new Image("graphics/water.png");
		layer = 1;
		
		scenes.GameScene.GM.waterAdded();
	}
	public function isFrozen()
	{
		return frozen;
	}
	public function freeze()
	{
		graphic = new Image("graphics/Ground_Winter.png");
		frozen = true;
		scenes.GameScene.GM.waterFrozen();
		
	}
	public function autoFreezeCheck()
	{
		/*This is going to figure out if the water is supposed to freeze over.*/
		
		//Merged numOfNeighbors functionality into this function.
		
		/*Going to use this to implement a hacky sort of water-freezing solution. 
			Recursively check number of  neighbors. 
			keep adding neighbors -1 (can't count neighbor you came from). 
			Probably need to use ids to ensure we don't double count, although if our freeze threshold is 3, we don't need to.
			*/
		
		var shouldFreeze = true;
		
		var w1:Entity = collide("waterTile", x + 16, y);
		var w2:Entity = collide("waterTile", x - 16, y);
		var w3:Entity = collide("waterTile", x, y + 16);
		var w4:Entity = collide("waterTile", x, y - 16);
		if (w1 != null)
		{
			var w1:WaterTile = cast(w1, WaterTile);
			
			if(!w1.isFrozen()){
				shouldFreeze = false;
			}
			
		}
		if (w2 != null)
		{
			var w2:WaterTile = cast(w2, WaterTile);
			
			if(!w2.isFrozen()){
				shouldFreeze = false;
			}
			
		}
		if (w3 != null)
		{
			var w3:WaterTile = cast(w3, WaterTile);
			
			if(!w3.isFrozen()){
				shouldFreeze = false;
			}
			
		}
		if (w4 != null)
		{
			var w4:WaterTile = cast(w4, WaterTile);
			
			if(!w4.isFrozen()){
				shouldFreeze = false;
			}
			
		}
		if (shouldFreeze){
			scenes.GameScene.GM.addScore(10); //Double points for doing autofreezing.
			freeze();
		}
	}
	
	public override function update()
	{
		if(!frozen){
			autoFreezeCheck();
		}
	}
}