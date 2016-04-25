package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import utilities.DirectionEnum; 
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class FireEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	
	private var currentScene:GameScene; 
	
	private static var defeatDelay:Int = 20;
	private var defeatCountdown:Int = -1;


	// Constructor for FireEnemy
	
	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		layer = 0;
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
		
		sprite = new Spritemap("graphics/FireSprite.png", 32, 32);
		
		// The animation is split into 60 individual frames to ensure the animation changes
		// even if the player rapidly pauses/unpauses.
		sprite.add("idle", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
							2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
							3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
							4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4], 60, true);
		sprite.add("defeated", [5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,
								7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,
								9,9,9,9,9,9,9,9], 30, false);
		sprite.play("idle");
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
	// Not needed for this enemy
	
	private override function calcDestination(){
	};
	
	
	// defeated()
	//
	// Called when the FireEnemy should be destroyed.
	
	public function defeated(){
		attackDamage = 0;
		sprite.play("defeated");
		defeatCountdown = defeatDelay;
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
		var w:WaterTile = (cast e);
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
	}
	
	private override function borderCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	// playerCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function playerCollision( e:Entity ){
		(cast e).takeDamage(attackDamage);
		defeated();
	}
	
	
	// fireEnemyCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function fireEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	// mistEnemyCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function mistEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	// lightningEnemyCollision( e:Entity )
	//
	// Prevent the fireEnemy from moving into it.
	
	private override function lightningEnemyCollision(e:Entity) {
    moveWasBlocked = true;
		stopMovement();
  }
	
	
	///////////////////////////////////////////
	//            MOVEMENT FUNCTIONS         //
	///////////////////////////////////////////
	
	
	// selectDirection()
	//
	// Instead of setting a direction, uses its own system of 
	// movementCycleCount and moveSet to move in spirals around
	// the map.
	
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

	
	// selectOtherDirection()
	//
	// Instead of pathfinding, just calls selectDirection again.
	
	private override function selectOtherDirection(){
		selectDirection();
	}
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	// update()
	//
	// Called every frame to update the entity.
	
	public override function update(){
		if(defeatCountdown == -1){
			super.update();
		}
		else{
			if(defeatCountdown > 0){
				defeatCountdown--;
			}
			else{
				scene.remove(this);
			}
		}
	
	}

}