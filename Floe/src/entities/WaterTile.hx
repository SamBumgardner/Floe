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

import entities.MovingActor; //This is just for the Direction enum


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
	
	
	///////////////////////////////////////////
	//          AUTOMATIC  FREEZING          //
	///////////////////////////////////////////
	
	
	// checkTile(e:Entity)
	//
	// Helper function for checkUnfrozenNeighbors
	// Identifies if e is an unfrozen water tile.
	//
	// Note: e MUST be castable to the WaterTile class!
	// 		 If not, we get silent, undefined behavior.
	
	
	private function checkNeighbor(){
		if( e != null ){
			if( (cast e).isFrozen() == false ){
				return true;
			}
		}
		return false;
	}
	
	
	
	// checkUnfrozenNeighbors( parentNeighbors:Int, parentDirection:Direction, minimumUnfrozen:Int )
	//
	// Loops over the Direction enum to go through adjacent tiles. Pretty cool stuff.
	//
	// starts with parent's neighbors, adds 1 for each unfrozen child, then recursively calls for children to add their number of neighbors.
	// if the number of neighbors ever exceeds minimumUnfrozen, you break out and return num_of_neighbors.
	
	// When parents receive children number back, have to subract their own number, then add it to their total.
	
	checkUnfrozenNeighbors( parentNeighbors:Int, parentDirection:Direction, minimumUnfrozen:Int ){
	
		var numOfNeighbors = parentNeighbors;
		var neighborWaterTiles = [];
		var neighborWaterTilesDirections = [];
		
		
		// Check which neighboring tiles are unfrozen water tiles (not including the parentDirection)
		
		for( direction in Type.allEnums(Direction) ){ // Performs this loop once for each direction.
		
			if (direction == None || direction == parentDirection) { continue; }
			else{
			
				switch direction{
					case Up:	var e:Entity = collide("waterTile", x, y - size);
					case Down:	var e:Entity = collide("waterTile", x, y + size);
					case Left:  var e:Entity = collide("waterTile", x - size, y);
					case Right: var e:Entity = collide("waterTile", x + size, y); 
				}
				
				if( checkNeighbor( e ) ){
					neighborWaterTiles.push( e );
					neighborWaterTilesDirections.push(direction);
					numOfNeighbors++;
					
					if( numOfNeighbors >= minimumUnfrozen){
						return numOfNeighbors;
					}
				}
			}
		}
		
		
		var myNumOfNeighbors = numOfNeighbors;
		
		var i = 0; 	//index moving through neighborWaterTilesDirections
		
		var parentingDirection:Direction; // the value to be passed along as parentDirection in recursion.
		
		// Recursively call this function on the unfrozen neighbors, adding results along the way.
		
		for (neighbor in neighborWaterTiles){
			switch neighborWaterTilesDirections[i]{
				case Up: 	parentingDirection = Down;
				case Down:  parentingDireciton = Up;
				case Left:	parentingDirection = Right;
				case Right:	parentingDirection = Left;
			}
		
			numOfNeighbors += (cast neighbor).checkUnfrozenNeighbors( myNumOfNeighbors, parentingDirection, minimumUnfrozen) - myNumOfNeighbors;
			if( numOfNeighbors >= minimumUnfrozen){
						return numOfNeighbors;
			}
			i++;
		}
		
		return numOfNeighbors;
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