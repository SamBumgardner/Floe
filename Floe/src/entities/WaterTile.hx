package entities;

/* WaterTile interacts with GameScene's static variable GM at the following lines:
 * 
 * 	Line 39 in the freeze() function
 *  Line 87 in the autoFreeze() function
 * 
 * 
*/
	  
 

import entities.Tile;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import scenes.GameScene;
import entities.GameManager;

class WaterTile extends Tile {
	static public var commonImage:Image;
	static public var commonFrozenImage:Image;
	static private var graphicInit:Bool = false;
	private var frozen:Bool;
	
	
	public function new(x:Int, y:Int)
	{
		HXP.console.log(["calling super"]);
		super(x, y);
		HXP.console.log(["called super"]);
		type = "waterTile";
		HXP.console.log(["set type"]);
		
		//need to reset graphic
		if(!graphicInit) {
			WaterTile.commonImage = new Image("graphics/water.png");
			commonFrozenImage = new Image("graphics/Ground_Winter.png");
			graphicInit = true;
		}
		HXP.console.log(["statics initialized"]);
		
		graphic = commonImage;
		HXP.console.log(["set graphic"]);
		
		frozen = false;
		HXP.console.log(["set froozen"]);
	}
	public function isFrozen()
	{
		return frozen;
	}
	public function freeze()
	{
		graphic = commonFrozenImage;
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