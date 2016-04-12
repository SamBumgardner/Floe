package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class WaterEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	// Graphic asset-holding variables
	private static var idleAnim:Image;
	
	private static var assetsInitialized:Bool = false; 
	
	private var currentScene:GameScene;
	
	public var submerged = false;
	private var timeLeftSubmerged = 0;
	private var timeLeftEmerged = 100;


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		
		frameDelay = 15; 
		moveSpeed = 0;
		recalcTime = 120;
		maxEndurance = 0; // moves two times before resting.
		restTime = 60;	   // rests for 60 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "waterEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/waterEnemy.png");
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
	
	private function submerge(timeToSubmerge:Int){
		timeLeftSubmerged = timeToSubmerge;
		submerged = true;
		graphic = new Image("graphics/water.png");
	}
	
	private function emerge(timeToEmerge:Int){
		timeLeftEmerged = timeToEmerge;
		submerged = false;
		graphic = new Image("graphics/waterEnemy.png");
	}
	
	private function stateDecay(){
		if (submerged){
			timeLeftSubmerged--;
			if (timeLeftSubmerged <= 0){
				emerge(150);
			}
		}
		else if (!submerged){
			timeLeftEmerged--;
			if (timeLeftEmerged <= 0){
				submerge(50);
			}
		}
	}
		
	
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
		if (!submerged){
			cast(e, Player).takeDamage(attackDamage);
		}
		else if (submerged){
			scene.remove(this);
		}
	}	
	
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	public override function update(){
		// enemy does not move, so all we need to do is toggle 'submerged'
		stateDecay();
	}




}