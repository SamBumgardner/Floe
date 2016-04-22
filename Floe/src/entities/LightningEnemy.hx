package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class LightningEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	// Graphic asset-holding variables
	private static var idleAnim:Image;
	
	private static var assetsInitialized:Bool = false; 
	
	private var currentScene:GameScene; 


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		
		frameDelay = 1; 
		moveSpeed = 16;
		recalcTime = 10000; //only recalc when done resting undercertain conditions
		maxEndurance = 20; // moves one time before resting.
		restTime = 120;	   // rests for 120 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
    
		type = "lightningEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/LightningEnemy.png");
			assetsInitialized = true;
		}
		
		graphic = idleAnim;
		currentScene = cast(HXP.scene, GameScene);
		
	}
	
	
	///////////////////////////////////////////
	//             ENEMY ACTIONS             //
	///////////////////////////////////////////
	
	// These functions are exactly what the title says: enemy actions.
	// It serves as a catch-all for methods that aren't strictly related to movement,
	// collisions, or direction selection.
	
	
	// calcDestination()
	//
	// Sets the destinationX and destinationY
	
  //should be "move ten units toward the PC in either the x or the y direction (which ever is greater favor Y on ties)"
	private override function calcDestination(){
    var pcTileX:Int = cast(currentScene.PC.x - (currentScene.PC.x % 32), Int);
    var pcTileY:Int = cast(currentScene.PC.y - (currentScene.PC.y % 32), Int);
    var myTileX:Int = cast(x - x % 32, Int);
    var myTileY:Int = cast(y - y % 32, Int);
    if(Math.abs(pcTileX - myTileX) < Math.abs(pcTileY - myTileY)) {
      destinationX = myTileX;
      destinationY = pcTileY;
		}
    else {
      destinationX = pcTileX;
      destinationY = myTileY;
    }
    
		HXP.console.log(["My destination is: ", destinationX, ", ", destinationY]);
		super.calcDestination();
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when SampleEnemy finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	// waterTileCollision( e:Entity )
	//
	// LightningEnemy moves over all tiles
	
	private override function waterTileCollision( e:Entity ){}
	
	// groundTileCollision( e:Entity )
	//
	//
	
	private override function groundTileCollision( e:Entity ){}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	// obstacleCollision( e:Entity )
	//
	// Lightning Enemy ignore obstacles
	
	private override function obstacleCollision( e:Entity ){}
	
	private override function borderCollision( e:Entity ){
		stopMovement();
    rest();
	}
	
	
	// playerCollision( e:Entity )
	//
	// Prevent the sampleEnemy from moving into it.
	
	private override function playerCollision( e:Entity ){
		stopMovement();
		cast(e, Player).takeDamage(attackDamage);
	}
	
	
	// sampleEnemyCollision( e:Entity )
	//
	// Prevent the LightningEnemy from moving into it, no path finding.
	
	private override function sampleEnemyCollision( e:Entity ){
		stopMovement();
    rest();
	}
	
	private override function borderEnemyCollision( e:Entity ){
		stopMovement();
    rest();
	}
	
	private override function waterEnemyCollision( e:Entity ){
		if (cast(e, WaterEnemy).submerged == false){
			stopMovement();
      rest();
		}
	}
  private override function fireEnemyCollision( e:Entity ){
		stopMovement();
    rest();
	}
  private override function mistEnemyCollision( e:Entity ){
		stopMovement();
    rest();
	}
  private override function lightningEnemyCollision(e:Entity) {
    //HXP.console.log(["lightningEnemyCollision"]);
    stopMovement();
    rest();
  }
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	///////////////////////////////////////////
	//     Rest                              //
	///////////////////////////////////////////
	
	//lightningEnemy always recalcs its destination after it rests
  private override function rest() {
    super.rest();
    recalcCountdown = restTime-1;
  }
  
  
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	//The Sample Enemy simply uses Enemy's update function.




}