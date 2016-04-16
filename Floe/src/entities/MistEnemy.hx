package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class MistEnemy extends Enemy
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
		
		frameDelay = 31; 
		moveSpeed = 1;
		recalcTime = 40;
		maxEndurance = 64; // moves four times before resting.
		restTime = 20;	   // rests for 20 frames.
		attackDamage = 0;
		acceptableDestDistance = 3;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "mistEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/ZombieFlyManEnemy.png");
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
	
	private override function calcDestination(){
		destinationX = cast(currentScene.PC.x - (currentScene.PC.x % 32), Int);
		destinationY = cast(currentScene.PC.y - (currentScene.PC.y % 32), Int);
		
		//HXP.console.log(["My destination is: ", destinationX, ", ", destinationY]);
		
		super.calcDestination();
	};
	
	private override function checkIfAtDestination( maxDist:Int ){
		
		if ( (Math.sqrt(Math.pow(destDistanceX, 2) + Math.pow(destDistanceY, 2) ) <= maxDist * tileSize ) && (
			destDistanceX == (currentScene.PC.x % 32) || destDistanceY == (currentScene.PC.y % 32)) ){
			atDestination = true;
		}
		else{
			atDestination = false;
		}
	}
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when MistEnemy finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	// waterTileCollision( e:Entity )
	//
	// SampleEnemy's movement ends.
	
	private override function waterTileCollision( e:Entity ){
		stopMovement();
	}
	
	// groundTileCollision( e:Entity )
	//
	// SampleEnemy's movement ends.
	
	private override function groundTileCollision( e:Entity ){
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	private override function obstacleCollision( e:Entity ){
	}
	
	// borderCollision( e:Entity )
	//
	// Prevent the mistEnemy from moving into it.
	
	private override function borderCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	// playerCollision( e:Entity )
	//
	// MistEnemy curses player.
	
	private override function playerCollision( e:Entity ){
		cast(e, Player).cursePlayer(300);	// flip player controls
	}
	
	
	// fireEnemyCollision( e:Entity )
	//
	// Prevent the mistEnemy from moving into it.
	
	private override function fireEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	// mistEnemyCollision( e:Entity )
	//
	// Prevent the mistEnemy from moving into it.
	
	private override function mistEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	//The Sample Enemy simply uses Enemy's update function.




}