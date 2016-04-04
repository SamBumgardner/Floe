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

	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	// For initializing assets
	static public var commonImage:Image;
	static public var commonFrozenImage:Image;
	static private var graphicInit:Bool = false;
	
	static public var size:Int = 32;
	private var frozen:Bool = false;
	
	private static var minimumUnfrozen:Int = 4;

	public var beenChecked:Bool = false;
	
	public function new(x:Int, y:Int){
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
	
	
	///////////////////////////////////////////
	//             WATER ACTIONS             //
	///////////////////////////////////////////
	
	
	// callOnAllWaterNeighbors(callBack:Entity->Direction->Void, ?parentDirection:Direction)
	//
	// There were several cases where a function needed to be applied to all water tiles
	// adjacent to the current water tile.
	// 
	// This function takes a function as a parameter, and applies to every adjacent water tile.
	// Callbacks must take an entity and a direction as arguments, even if they don't use them.
	//
	// The parentDirection parameter can be used to specify which neighboring tile called this on
	// them, so they won't try to call backwards while doing recursion.
	//
	// The "parenting direction" passed into the callback is the direction from the targeted neighbor
	// back to the current water tile. It's prevents wasteful backward iterations during recursion.
	
	
	private function callOnAllWaterNeighbors(callBack:Entity->Direction->Void, ?parentDirection:Direction){
		
		var parentingDirection:Direction;
		var e:Entity;
		
		for( direction in Type.allEnums(Direction) ){ // Performs this loop once for each direction.
		
			if (direction == None || direction == parentDirection) { continue; }
			else{
			
				switch direction{
					case Up:	{e = collide("waterTile", x, y - size);
								 parentingDirection = Down;}
					case Down:	{e = collide("waterTile", x, y + size);
								 parentingDirection = Up;}
					case Left:  {e = collide("waterTile", x - size, y);
								 parentingDirection = Right;}
					case Right: {e = collide("waterTile", x + size, y);
								 parentingDirection = Left;}
					case None:	{continue;}
				}
				
				if( checkNeighbor( e ) ){
					callBack(e, parentingDirection);
				}
			}
		}
	}
	
	
	// isFrozen()
	//
	// Getter for the frozen variable, which is a Bool.
	
	public function isFrozen()
	{
		return frozen;
	}
	
	
	// freeze()
	//
	// Called when Player walks over a water tile.
	// forces adjacent tiles to check if they should automatically freeze.
	
	public function freeze()
	{
		graphic = commonFrozenImage;
		frozen = true;
		scenes.GameScene.GM.waterFrozen();
		
		callOnAllWaterNeighbors( function(e:Entity, unused:Direction){
		
		(cast e).autoFreezeCheck();} );
		
	}
	
	
	// chainFreeze()
	//
	// Called by tiles that are recursively freezing.
	// These score extra points, and also can't trigger further recursion.
	
	public function chainFreeze()
	{
		graphic = commonFrozenImage;
		frozen = true;
		scenes.GameScene.GM.addScore(10); // This won't be the final implementation for awarding extra points on chainfreeze
		scenes.GameScene.GM.waterFrozen();
	}
	
	
	
	
	
	///////////////////////////////////////////
	//      RECURSIVE NEIGHBOR COUNTING      //
	///////////////////////////////////////////
	
	
	// checkNeighbor(e:Entity)
	//
	// Helper function for checkUnfrozenNeighbors
	// Identifies if e is an unfrozen water tile.
	//
	// Note: e MUST be castable to the WaterTile class!
	// 		 If not, we get silent, undefined behavior.
	
	
	private function checkNeighbor(e:Entity){
		if( e != null ){
			if( (cast e).isFrozen() == false){
				
				return true;
			}
		}
		return false;
	}
	
	
	
	// checkUnfrozenNeighbors( parentNeighbors:Int, parentDirection:Direction)
	//
	// First half is almost exactly like callOnAllWaterNeighbors(), but temporary data structures
	// were involved that meant the whole loop thing had to be re-coded here.
	// 
	// It first counts its number of unfrozen neighbors that haven't already been counted in this step.
	// Then it calls this function recursively on those unfrozen neighbors.
	// Neighbors that have been counted already  get beenChecked set to true.
	//
	// If it counts neighbors equal to or greater than the freezing threshold, or if it runs out
	// of unchecked neighbors to count, it returns the total it found.
	// Which will cascade back to the original caller. 
 	//
	// starts with parent's neighbors, adds 1 for each unfrozen child, then recursively calls for children to add their number of neighbors.
	// if the number of neighbors ever exceeds minimumUnfrozen, you break out and return num_of_neighbors.
	// Each "original caller" adds up its neighbors numbers, again returning if it has enough neighbors,
	// or it has already added up the return values of all of its neighbors.
	//
	// The ultimate return value is the number of interconnected water tiles that were counted before 
	// either counting up to the threshold, or running out of water tiles.
	
	private function checkUnfrozenNeighbors( parentNeighbors:Int, parentDirection:Direction){

		
		beenChecked = true;
		
		var numOfNeighbors = parentNeighbors;
		var neighborWaterTiles = [];
		var neighborWaterTilesDirections = [];
		
		
		// Check which neighboring tiles are unfrozen water tiles (not including the parentDirection)
		
		for( direction in Type.allEnums(Direction) ){ // Performs this loop once for each direction.
		
			if (direction == None || direction == parentDirection) { continue; }
			else{
				var e:Entity;
			
				switch direction{
					case Up:	e = collide("waterTile", x, y - size);
					case Down:	e = collide("waterTile", x, y + size);
					case Left:  e = collide("waterTile", x - size, y);
					case Right: e = collide("waterTile", x + size, y); 
					case None: continue;
				}
				
				if( checkNeighbor( e ) ){
					if( (cast e).beenChecked == false ){
						(cast e).beenChecked = true;
						
						
						neighborWaterTiles.push( e );
						neighborWaterTilesDirections.push(direction);
						numOfNeighbors++;
					
						if( numOfNeighbors >= minimumUnfrozen){
						return numOfNeighbors;
						}
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
				case Down:  parentingDirection = Up;
				case Left:	parentingDirection = Right;
				case Right:	parentingDirection = Left;
				case None: continue;
			}
		
			numOfNeighbors += (cast neighbor).checkUnfrozenNeighbors( myNumOfNeighbors, parentingDirection) - myNumOfNeighbors;
			if( numOfNeighbors >= minimumUnfrozen){
					return numOfNeighbors;
			}
			i++;
		}
		
		return numOfNeighbors;
	}
	
	
	
	///////////////////////////////////////////
	//          AUTOMATIC  FREEZING          //
	///////////////////////////////////////////
	
	
	// autoFreezeCheck()
	//
	// Calls checkUnfrozenNeighbors().
	// If the result is less than the freezeThreshold then the tiles freeze.
	//
	// recursiveResetChecked is run regardless, to prepare water tiles for the
	// next round of counting.
	
	public function autoFreezeCheck(){	
		var parentDirection:Direction = None;
	

				if( checkUnfrozenNeighbors( 1, None ) < minimumUnfrozen ){ 
					recursiveDontFreeze();
					recursiveFreeze(); 
					
				}
				else{
					recursiveDontFreeze();
				}
			
			
	}
	
	
	// recursiveFreeze( ?parentDirection:Direction )
	//
	// Takes parentDirection as an optionalParameter. The first time it isn't needed,
	// But it is used in subsequent calls to ensure that callOnAllWaterNeighbors
	// Doesn't move backward during its recursion.
	
	private function recursiveFreeze( ?parentDirection:Direction ){
		chainFreeze();
		
	
		callOnAllWaterNeighbors(
			function(e:Entity, parentingDirection:Direction){
				(cast e).recursiveFreeze(parentingDirection);
			},
			parentDirection
		);
	}
	
	// recursiveDontFreeze( ?parentDirection:Direction )
	//
	// Same as recursiveFreeze, but resets the beenChecked variables instead of freezing.
	
	private function recursiveDontFreeze( ?parentDirection:Direction ){
		if(beenChecked == true){

			beenChecked = false;
		
			callOnAllWaterNeighbors(
				function(e:Entity, parentingDirection:Direction){
					(cast e).recursiveDontFreeze(parentingDirection);
				},
				parentDirection
			);
		}
	}
	
	
	
	public override function update(){
		super.update();
	}
	
}