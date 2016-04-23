package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import utilities.DirectionEnum; 
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class MistEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	private static var assetsInitialized:Bool = false; 
	
	private var currentScene:GameScene;


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		layer = -2;
		frameDelay = 31; 
		moveSpeed = 1;
		recalcTime = 40;
		maxEndurance = 64; // moves four times before resting.
		restTime = 32;	   // rests for 32 frames.
		attackDamage = 0;
		acceptableDestDistance = 3;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "mistEnemy";
		
		if( assetsInitialized == false ){
			assetsInitialized = true;
		}
		
		// The animation is split into 60 individual frames to ensure the animation changes
		// even if the player rapidly pauses/unpauses.
		sprite = new Spritemap("graphics/mist.png", 32, 32);
		sprite.add("idle", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
							2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
							3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
							4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,], 60, true);
		
		
		sprite.play("idle");
		graphic = sprite;
		
		currentScene = (cast HXP.scene);
		
	}
	
	///////////////////////////////////////////
	//            ENEMY ANIMATION            //
	///////////////////////////////////////////
	
	// setMoveAnimation()
	//
	// Overrides function from MovingActor, disables any animation-changing.
	
	private override function setMoveAnimation(){}
	
	
	// setIdleAnimation()
	//
	// Overrides function from MovingActor, disables any animation-changing.
	
	private override function setIdleAnimation(){}
	
	
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
		destinationX = (cast currentScene.PC.x - (currentScene.PC.x % 32));
		destinationY = (cast currentScene.PC.y - (currentScene.PC.y % 32));
		
		//HXP.console.log(["My destination is: ", destinationX, ", ", destinationY]);
		
		super.calcDestination();
	};
	
	// checkifAtDestination()
	//
	// If the mistEnemy is within the acceptable distance.
	
	private override function checkIfAtDestination( maxDist:Int ){
		super.checkIfAtDestination( maxDist );
		if ( 	atDestination &&
				(x == currentScene.PC.x - (currentScene.PC.x % 32) || 
				y == currentScene.PC.y - (currentScene.PC.y % 32)) ){
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
		(cast e).cursePlayer(300);	// flip player controls
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
	private override function lightningEnemyCollision(e:Entity) {
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