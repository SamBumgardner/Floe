package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class BorderEnemy extends Enemy
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
		
		frameDelay = 15; 
		moveSpeed = 2;
		recalcTime = 120;
		maxEndurance = 16; // moves one time before resting.
		restTime = 16;	   // rests for 30 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;
		moveSet = 0;
		reverseEnemy = false;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "borderEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/borderEnemy.png");
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
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when BorderEnemy finishes moving onto a tile.
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
	// Prevent the borderEnemy from moving into it.
	
	private override function obstacleCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	// borderCollision( e:Entity )
	//
	// Prevent the borderEnemy from moving into it.
	
	private override function borderCollision( e:Entity ){
		moveWasBlocked = true;
		
		if(reverseEnemy == true){
			moveSet--;
		}
		
		if(reverseEnemy == false){
			moveSet++;
		}
		
		stopMovement();
	}
	
	
	// playerCollision( e:Entity )
	//
	// Prevent the borderEnemy from moving into it.
	
	private override function playerCollision( e:Entity ){
		moveSet += 2;
		reverseEnemy = !reverseEnemy;
		stopMovement();
		cast(e, Player).takeDamage(attackDamage);
	}
	
	
	// sampleEnemyCollision( e:Entity )
	//
	// Prevent the borderEnemy from moving into it.
	
	private override function sampleEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		moveSet += 2;
		reverseEnemy = !reverseEnemy;
		stopMovement();
	}
	
	// borderEnemyCollision( e:Entity )
	//
	// Prevent the borderEnemy from moving into it.
	
	private override function borderEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		moveSet += 2;
		reverseEnemy = !reverseEnemy;
		stopMovement();
	}
  
	private override function lightningEnemyCollision(e:Entity) {
    moveWasBlocked = true;
    moveSet += 2;
		reverseEnemy = !reverseEnemy;
		stopMovement();
  }
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	
	///////////////////////////////////////////
	//            MOVEMENT FUNCTIONS         //
	///////////////////////////////////////////
	
	private override function cannotMove(){
		restCountdown = restTime * 2;
		currentEndurance = maxEndurance;
	}

	private override function selectDirection(){
		if(moveSet >= 0){
			if(moveSet % 4 == 0){
				currentMove = Right;
			}
		
			if(moveSet % 4 == 1){
				currentMove = Down;
			}
		
			if(moveSet % 4 == 2){
				currentMove = Left;
			}
		
			if(moveSet % 4 == 3){
				currentMove = Up;
			}
		}
		else{
			if((Math.abs(moveSet) + 2) % 4 == 0){
				currentMove = Left;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 1){
				currentMove = Down;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 2){
				currentMove = Right;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 3){
				currentMove = Up;
			}
		}
	}
	
	private override function selectOtherDirection(){
		if(moveSet >= 0){
			if(moveSet % 4 == 0){
				currentMove = Right;
			}
		
			if(moveSet % 4 == 1){
				currentMove = Down;
			}
		
			if(moveSet % 4 == 2){
				currentMove = Left;
			}
		
			if(moveSet % 4 == 3){
				currentMove = Up;
			}
		}
		else{
			if((Math.abs(moveSet) + 2) % 4 == 0){
				currentMove = Left;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 1){
				currentMove = Down;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 2){
				currentMove = Right;
			}
		
			if((Math.abs(moveSet) + 2) % 4 == 3){
				currentMove = Up;
			}
		}
	}
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	//The Border Enemy simply uses Enemy's update function.
}