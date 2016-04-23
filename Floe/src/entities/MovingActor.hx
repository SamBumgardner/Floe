package entities;

/*
  MovingActor
  This is an abstract class for moving actors (both actor and enemy) to inherit from.
  It contains private functions necessary for moving.
*/

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import utilities.DirectionEnum;


class MovingActor extends Entity {


	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////

	
	private var currentMove:Direction = None; // Tracks direction of movement.
	private var currentFacing:Direction = Down; // Set in checkNextStep()
	
	private var shouldSetAnim:Bool = true;
	
	private var frameCountdown:Int = 0; // How many frames of movement are left in the current move
	
	private var inputBlocked:Bool = false; // True if the character is mid-move

	private var tileSize:Int = 32;
	
	// Values for these are set by the child class
	
	private var frameDelay:Int; 	// The number of frames a single move takes after the initial step. 
	private var moveSpeed:Int; 		// The number of pixels moved per frame.

	
	// Arrays of types used for checking collisions
	
	private static var backgroundTypes = ["groundTile", "waterTile"];
	private static var actorTypes = ["obstacle", "border", "player", "sampleEnemy",
		"fireEnemy", "mistEnemy", "waterEnemy", "borderEnemy", "lightningEnemy"];

	
	// Contains references to collision functions.
	// Used in checkGround() and checkNextStep()
	
	private var collisionFunctions = new Map();
	
	// Used for first-time setup  of assets.
	// Child classes also need this, since static variables aren't inherited.
	private static var assetsInitialized:Bool = false; 
	private var sprite:Spritemap;
	private var prePauseAnim:String;
	private var prePauseFrame:Int;
	
	
	
	
	
	public function new(x:Int, y:Int)
	{
		// call the entity constructor so we can access entity's fields
		super(x, y);
		
		
		// map of references to functions.
		collisionFunctions = [ 
		
		"obstacle" 		=> obstacleCollision,
		"waterTile"		=> waterTileCollision,
		"groundTile"	=> groundTileCollision,
		"player" 		=> playerCollision,
		"sampleEnemy"	=> sampleEnemyCollision,
		"fireEnemy"		=> fireEnemyCollision,
		"mistEnemy" 	=> mistEnemyCollision,
		"waterEnemy" 	=> waterEnemyCollision,
		"border"		=> borderCollision,
		"borderEnemy"	=> borderEnemyCollision,
		"lightningEnemy"=> lightningEnemyCollision  //update for specific behavior 
													//(need to add function placeholder then override in player and enemy)

		]; 
		
		if( assetsInitialized == false ){
			assetsInitialized = true;
		}
	}
	
	
	///////////////////////////////////////////
	//            ACTOR ANIMATION            //
	///////////////////////////////////////////
	
	// setMoveAnimation()
	//
	// Sets the actor's animation to the moving animation that matches
	// their current direction, unless shouldSetAnim is false, or 
	// currentDirection is None.
	//
	// Called in startMovement()
	
	private function setMoveAnimation(){
		
		if(shouldSetAnim == true){
			switch currentMove{
				case Left: 	sprite.play("leftMove", false, false);
				case Right: sprite.play("rightMove", false, false);
				case Up: 	sprite.play("upMove", false, false);
				case Down:	sprite.play("downMove", false, false);
				
				case None: {} //Does nothing
			}
		}
	}
	
	
	// setIdleAnimation()
	//
	// Sets the actor's animation to the idle version of  that matches
	// their currentFacing, unless shouldSetAnim is false.
	//
	// Called in child classes after Actor is guaranteed to be stopped.
	
	private function setIdleAnimation(){
	
		if(shouldSetAnim == true){
			switch currentFacing{
				case Left: 	sprite.play("leftIdle", false, false);
				case Right: sprite.play("rightIdle", false, false);
				case Up: 	sprite.play("upIdle", false, false);
				case Down:	sprite.play("downIdle", false, false);
				
				case None: {} //Does nothing
			}
		}
	}
	
	
	///////////////////////////////////////////
	//             ACTOR ACTIONS             //
	///////////////////////////////////////////
	
	// paused() 
	//
	// Called when the entity should be paused.
	// Responsible for preventing update() from being called,
	// and stopping animations.
	
	public function pause(){
		active = false;
		prePauseAnim = sprite.currentAnim;
		if(prePauseAnim != ""){
			prePauseFrame = sprite.index;
			//HXP.console.log([type, x, y, prePauseFrame]);
			sprite.stop();
		}
	}
	
	// resumed()
	//
	// Undoes the actions of paused()
	
	public function unpause(){
		active = true;
		if(prePauseAnim != ""){
			sprite.play(prePauseAnim);
			sprite.index = prePauseFrame;
			//HXP.console.log([type, x, y, sprite.index]);
		}
	}
	
	///////////////////////////////////////////
	//            ACTOR  MOVEMENT            //
	///////////////////////////////////////////
	
	// attemptCollision(e:Entity)
	//
	// Helper function for checkNextStep
	// attempts to do collision with the passed-in entity
	
	private function attemptCollision(e:Entity){
		if( e != null ){
			(collisionFunctions[e.type])(e); //call that object's collision function.	
		}
	}
	
	
	// checkNextStep()
	//
	// Check if there is another actor in the direction the actor is attempting to move in.
	// If so, attemptCollision() is used to resolve the situation.

	private function checkNextStep(){
		switch currentMove{
			case Left: {
				// Checks 1px left of actor for collision with actorType entities
				var e:Entity = collideTypes(actorTypes, x - tileSize, y); 
				currentFacing = currentMove;
				attemptCollision(e);
			}
			case Right: {
				// Checks 1px to the right
				var e:Entity = collideTypes(actorTypes, x + tileSize, y); 
				currentFacing = currentMove;
				attemptCollision(e);
			
			}
			case Up: {
				// Checks 1px above
				var e:Entity = collideTypes(actorTypes, x, y - tileSize); 
				currentFacing = currentMove;
				attemptCollision(e);
			
			}
			case Down: {
				// Checks 1px below
				var e:Entity = collideTypes(actorTypes, x, y + tileSize); 
				currentFacing = currentMove;
				attemptCollision(e);
			}
			
			case None: {} //Does nothing
		}
	};
	
	
	
	// startMovement()
	//
	// Starts actor movement and locks actor control for the next [[frameDelay]] frames
	
	private function startMovement(){
		
		switch currentMove{
			case Left: moveBy(-1 * moveSpeed, 0);
			case Right: moveBy(moveSpeed, 0);
			case Up: moveBy(0, -1 * moveSpeed);
			case Down: moveBy(0, moveSpeed);
			
			case None: return null; // exits function early, skips setting other variables
		}
		setMoveAnimation();
		inputBlocked = true; // The actor cannot change direction until they have finished the move.
		frameCountdown = frameDelay;
		
		return null; // Required by haxe's compiler (since there's a return statement for None)
		
	};
	
	
	
	// continueMovement()
	//
	// While the actor's control is locked out, move in the actor's movement direction.
	
	private function continueMovement(){
		
		switch currentMove{
			case Left: moveBy(-1 * moveSpeed, 0);
			case Right: moveBy(moveSpeed, 0);
			case Up: moveBy(0, -1 * moveSpeed);
			case Down: moveBy(0, moveSpeed);
			
			case None: {};
		}
		
		frameCountdown--;
	};
	
	
	
	// checkGround()
	//
	// Called when the actor finishes a movement cycle to see what sort of ground
	// the actor is standing on. Calls the appropriate collision function.
	
	private function checkGround(){
		var e:Entity = collideTypes(backgroundTypes, x, y);
		if (e != null)
		{
			(collisionFunctions[e.type])(e); //calls appropriate collision function.
		}
		else{ //TEMPORARY CODE: handles case if there is no tile below. remove after level generation is completely fixed!
			collisionFunctions["groundTile"](e);
		
		}
	};
	
	
	
	// stopMovement()
	//
	// Called to clear values of currentMove & inputBlocked
	
	private function stopMovement(){
		
		if(frameCountdown > 0){
			//HXP.console.log(["ERROR: stopMovement was called while frameCountdown > 0"]);
		}
		
		currentMove = None;
		inputBlocked = false;
		
		frameCountdown = -1; // Ensures that the game doesn't keep checking what the ground is every frame.
		
	};
	
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	
	// These are placeholder functions for background collisions.
	// Override them in the child class to get the desired behavior.
	
	private function waterTileCollision( e:Entity ){}
	
	private function groundTileCollision( e:Entity ){}
	
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	// These are placeholder functions for actor collisions.
	// Override them in the child class to get the desired behavior.
	
	private function obstacleCollision( e:Entity ){}
	
	private function borderCollision( e:Entity ){}
	
	private function playerCollision( e:Entity ){}
	
	private function sampleEnemyCollision( e:Entity ){}
	
	private function fireEnemyCollision( e:Entity ){}
	
	private function mistEnemyCollision( e:Entity ){}
	
	private function waterEnemyCollision( e:Entity ){}
	
	private function borderEnemyCollision( e:Entity ){}
  
  private function lightningEnemyCollision( e:Entity ) {}

}