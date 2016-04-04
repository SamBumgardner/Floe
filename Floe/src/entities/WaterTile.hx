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
	
	
	// does callback function to every adjacent water tile.
	// Callbacks must take an entity and a direction as arguments.
	
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
	
	
	public function isFrozen()
	{
		return frozen;
	}
	
	
	public function freeze()
	{
		graphic = commonFrozenImage;
		frozen = true;
		scenes.GameScene.GM.waterFrozen();
		
		callOnAllWaterNeighbors( function(e:Entity, unused:Direction){
		
		(cast e).autoFreezeCheck();} );
		
	}
	
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
	// Loops over the Direction enum to go through adjacent tiles. Pretty cool stuff.
	//
	// starts with parent's neighbors, adds 1 for each unfrozen child, then recursively calls for children to add their number of neighbors.
	// if the number of neighbors ever exceeds minimumUnfrozen, you break out and return num_of_neighbors.
	
	// When parents receive children number back, have to subtract their own number, then add it to their total.
	
	private function checkUnfrozenNeighbors( parentNeighbors:Int, parentDirection:Direction){
		HXP.console.log(["checkUnfrozenNeighbors was called on: ", x, y]);
		
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
						HXP.console.log(["WaterTile at ", e.x, " ", e.y, " was checked."]);
						
						neighborWaterTiles.push( e );
						neighborWaterTilesDirections.push(direction);
						numOfNeighbors++;
					
						if( numOfNeighbors >= minimumUnfrozen){
						return numOfNeighbors;
						}
					}
					else{
						HXP.console.log(["But", e.x, e.y, "had already been Checked"]);
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
	
	
	
	public function autoFreezeCheck(){	
		var parentDirection:Direction = None;
	

				if( checkUnfrozenNeighbors( 0, None ) < minimumUnfrozen ){ 
					HXP.console.log(["failed!"]);
					recursiveDontFreeze();
					recursiveFreeze(); 
					
				}
				else{HXP.console.log(["Tile at", x, y, "passed!"]);
					recursiveDontFreeze();
				}
			
			
	}
	
	
	
	private function recursiveFreeze( ?parentDirection:Direction ){
		chainFreeze();
		
	
		callOnAllWaterNeighbors(
			function(e:Entity, parentingDirection:Direction){
				(cast e).recursiveFreeze(parentingDirection);
			},
			parentDirection
		);
	}
	
	private function recursiveDontFreeze( ?parentDirection:Direction ){
		if(beenChecked == true){
			//HXP.console.log(["WaterTile at ", x, " ", y, " was reset."]);
		
			HXP.console.log(["WaterTile at ", x, " ", y, " was reset."]);
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