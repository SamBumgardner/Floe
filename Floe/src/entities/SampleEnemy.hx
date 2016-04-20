package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class SampleEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	// Graphic asset-holding variables
	
	private static var assetsInitialized:Bool = false;
	
	private var currentScene:GameScene; 


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		
		layer = 0;
		frameDelay = 15; 
		moveSpeed = 2;
		recalcTime = 120;
		maxEndurance = 32; // moves two times before resting.
		restTime = 60;	   // rests for 60 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "sampleEnemy";
		
		if( assetsInitialized == false ){
			//Not used at the moment.
			assetsInitialized = true;
		}
		sprite = new Spritemap("graphics/DefaultAnimationPlaceholder.png", 32, 32);
		sprite.add("upIdle", [3], 3, true); 
		sprite.add("leftIdle", [1], 3, true);
		sprite.add("downIdle", [4], 3, true);
		sprite.add("rightIdle", [2], 3, true);
		sprite.add("upMove", [7], 1, true); 
		sprite.add("leftMove", [5], 3, true);
		sprite.add("downMove", [8], 3, true);
		sprite.add("rightMove", [6], 3, true);
		
		sprite.play("downIdle");
		graphic = sprite;
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
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when SampleEnemy finishes moving onto a tile.
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
	
	
	// obstacleCollision( e:Entity )
	//
	// Prevent the sampleEnemy from moving into it.
	
	private override function obstacleCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	private override function borderCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
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
	// Prevent the sampleEnemy from moving into it.
	
	private override function sampleEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	private override function borderEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	private override function waterEnemyCollision( e:Entity ){
		if (cast(e, WaterEnemy).submerged == false){
			moveWasBlocked = true;
			stopMovement();
		}
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