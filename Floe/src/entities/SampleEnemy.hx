package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import utilities.DirectionEnum; 
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
		sprite = new Spritemap("graphics/sampleEnemy.png", 32, 32);

		sprite.add("upMove", [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
							  6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
							  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
							  6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6], 60, true); 
		
		sprite.add("leftMove", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
								8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
								4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4], 60, true);
		
		sprite.add("downMove", [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
								7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
								11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,
								7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7], 60, true);
		
		sprite.add("rightMove", [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
								 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
								 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
								 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5], 60, true);
		
		sprite.play("downMove");
		graphic = sprite;
		currentScene = (cast HXP.scene);
		
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
		destinationX = (cast currentScene.PC.x - (currentScene.PC.x % 32));
		destinationY = (cast currentScene.PC.y - (currentScene.PC.y % 32));
		
		//HXP.console.log(["My destination is: ", destinationX, ", ", destinationY]);
		
		super.calcDestination();
	};
	

	///////////////////////////////////////////
	//            ENEMY ANIMATION            //
	///////////////////////////////////////////

	
	// setIdleAnimation()
	//
	// Overrides function from MovingActor, disables any animation-changing,
	// since this enemy's idle and moving animations are identical.
	
	private override function setIdleAnimation(){}	
	
	
	
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
		(cast e).takeDamage(attackDamage);
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
		if ((cast e).submerged == false){
			moveWasBlocked = true;
			stopMovement();
		}
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