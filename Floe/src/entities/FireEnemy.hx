package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class FireEnemy extends Enemy
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
		maxEndurance = 16; // moves once before resting.
		restTime = 20;	   // rests for 60 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;
		specialLoad = 6;   // counter for when ice melts
		moveSet = 0;
		moveCycleCount = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "fireEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/fireEnemy.png");
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
	// Not needed for this enemy
	
	private override function calcDestination(){
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when FireEnemy finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	// waterTileCollision( e:Entity )
	//
	// FireEnemy's movement ends.
	
	private override function waterTileCollision( e:Entity ){
		stopMovement();
		var w:WaterTile = cast(e, WaterTile);
		if(w.isFrozen()){
			specialLoad++;
			if(specialLoad % 5 == 0){
				w.thaw();
				var tempX:Int = (-32);
				
				//This section melts the surrounding tiles//
				while(tempX < 64){
					var tempY:Int = (-32);
					while(tempY < 64){
						e = w.collide("waterTile", x + tempX, y + tempY);
						if( e != null ){
							if( (cast e).isFrozen() == true){
								(cast e).thaw();
							}
						}
						tempY += 32;
					}
					tempX += 32;
				}
			}
		}
	}
	
	// groundTileCollision( e:Entity )
	//
	// fireEnemy's movement ends.
	
	private override function groundTileCollision( e:Entity ){
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	// obstacleCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	private override function obstacleCollision( e:Entity ){
		//moveWasBlocked = true;
		//stopMovement();
	}
	
	private override function borderCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	// playerCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function playerCollision( e:Entity ){
		cast(e, Player).takeDamage(attackDamage);
		scene.remove(this);
	}
	
	
	// fireEnemyCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function fireEnemyCollision( e:Entity ){
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
	
	
	private override function selectDirection(){
		if(moveCycleCount % 10 < 4){
			moveCycleCount++;
			checkGround();
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Up;
				}
				else if(moveSet % 4 == 1){
					currentMove = Left;
				}
				else if(moveSet % 4 == 2){
					currentMove = Down;
				}
				else{
					currentMove = Right;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}
	
		else if(moveCycleCount % 10 > 3 && moveCycleCount % 10 < 7){
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Left;
				}
				else if(moveSet % 4 == 1){
					currentMove = Down;
				}
				else if(moveSet % 4 == 2){
					currentMove = Right;
				}
				else{
				currentMove = Up;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}

		else if(moveCycleCount % 10 == 7 || moveCycleCount % 10 == 8){
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Down;
				}
				else if(moveSet % 4 == 1){
					currentMove = Right;
				}
				else if(moveSet % 4 == 2){
					currentMove = Up;
				}
				else{
					currentMove = Left;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}

		else{
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Right;
				}
				else if(moveSet % 4 == 1){
					currentMove = Up;
				}
				else if(moveSet % 4 == 2){
					currentMove = Left;
				}
				else{
					currentMove = Down;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}
	}

	private override function selectOtherDirection(){
		if(moveCycleCount % 10 < 4){
			moveCycleCount++;
			checkGround();
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Up;
				}
				else if(moveSet % 4 == 1){
					currentMove = Left;
				}
				else if(moveSet % 4 == 2){
					currentMove = Down;
				}
				else{
					currentMove = Right;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}
	
		else if(moveCycleCount % 10 > 3 && moveCycleCount % 10 < 7){
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Left;
				}
				else if(moveSet % 4 == 1){
					currentMove = Down;
				}
				else if(moveSet % 4 == 2){
					currentMove = Right;
				}
				else{
				currentMove = Up;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}

		else if(moveCycleCount % 10 == 7 || moveCycleCount % 10 == 8){
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Down;
				}
				else if(moveSet % 4 == 1){
					currentMove = Right;
				}
				else if(moveSet % 4 == 2){
					currentMove = Up;
				}
				else{
					currentMove = Left;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}

		else{
			moveCycleCount++;
			if(moveWasBlocked == false){
				if(moveSet % 4 == 0){
					currentMove = Right;
				}
				else if(moveSet % 4 == 1){
					currentMove = Up;
				}
				else if(moveSet % 4 == 2){
					currentMove = Left;
				}
				else{
					currentMove = Down;
				}
			}
			else{
				moveWasBlocked = true;
				currentMove = None;
				moveSet++;
			}
		}
	}
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	//The fire Enemy simply uses Enemy's update function.

}