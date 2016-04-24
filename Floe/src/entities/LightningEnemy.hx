package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import utilities.DirectionEnum; 
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class LightningEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	// Graphic asset-holding variables
	
	private var currentScene:GameScene; 


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		layer = 0;
		frameDelay = 1; 
		moveSpeed = 16;
		recalcTime = 10000; //the enemy should not recalc expcept just before it stops resting, 
							//this enemy sets the true recalc time when it rests;
		maxEndurance = 20; // moves one time before resting.
		restTime = 120;	   // rests for 120 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
    
		type = "lightningEnemy";
		
		sprite = new Spritemap("graphics/lightningEnemy.png", 32, 32);
		
		sprite.add("idle", [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
							5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
							], 30, true);
		sprite.add("charged", [0,1,2,3], 30, true);
		sprite.add("leftMove", [9], 1, false);
		sprite.add("rightMove", [9], 1, false);
		sprite.add("upMove", [8], 1, false);
		sprite.add("downMove", [8], 1, false);
		
		sprite.play("idle");
		graphic = sprite;
		currentScene = (cast HXP.scene);
		
	}
	
	
	// setIdleAnimation()
	//
	// Sets the actor's animation to the idle version of  that matches
	// their currentFacing, unless shouldSetAnim is false.
	//
	// Called in child classes after Actor is guaranteed to be stopped.
	
	private override function setIdleAnimation(){
		sprite.play("idle");
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
    //
	// The rule is "move ten units toward the PC in either the x or the y direction
	// (which ever is greater, favor Y on ties)"
	
	private override function calcDestination(){
    var pcTileX:Int = (cast currentScene.PC.x - (currentScene.PC.x % 32));
    var pcTileY:Int = (cast currentScene.PC.y - (currentScene.PC.y % 32));
    var myTileX:Int = (cast x - x % 32);
    var myTileY:Int = (cast y - y % 32);
    if(Math.abs(pcTileX - myTileX) < Math.abs(pcTileY - myTileY)) {
      destinationX = myTileX;
      destinationY = pcTileY;
		}
    else {
      destinationX = pcTileX;
      destinationY = myTileY;
    }
    
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
	// Lightning Enemy ignores obstacles
	
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
		(cast e).takeDamage(attackDamage);
		rest();
	}
	
	
	// All of these collision functions serve the same purpose, but for different enemies:
	//
	// Prevent the LightningEnemy from moving into it, and do not trigger path finding.
	
	private override function sampleEnemyCollision( e:Entity ){
		stopMovement();
		rest();
	}
	
	private override function borderEnemyCollision( e:Entity ){
		stopMovement();
		rest();
	}
	
	private override function waterEnemyCollision( e:Entity ){
		if ((cast e).submerged == false){
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
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	// update() is called every frame.
	
	public override function update() {
		if(restCountdown == 60){
			sprite.play("charged");
		}
		super.update();
	}



}