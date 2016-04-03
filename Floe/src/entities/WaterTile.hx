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
	private var frozen:Bool = false;

	
	
	public function new(x:Int, y:Int)
	{
		super(x, y);

		type = "waterTile";
		
		//need to reset graphic
		if(!graphicInit) {
			WaterTile.commonImage = new Image("graphics/water.png");
			commonFrozenImage = new Image("graphics/Ground_Winter.png");
			graphicInit = true;
		}
		
		graphic = commonImage;
		
		scenes.GameScene.GM.waterAdded();

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
		
		/*
			Recursively check number of  neighbors. 
			keep adding neighbors -1 (can't count neighbor you came from). 
			Probably need to use ids to ensure we don't double count, although if our freeze threshold is 3, we don't need to.
			*/
		
		var shouldFreeze = true;
		

		//Insert some actual code here.
		
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