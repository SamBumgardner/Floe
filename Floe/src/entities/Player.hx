package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import entities.WaterTile;

import com.haxepunk.HXP;

enum Direction {
	Up;
	Down;
	Left;
	Right;
	None;
}


class Player extends Entity
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	private var idleAnim:Image;
	private var bumpSound:Sfx;
	
	private static var frameDelay:Int 	= 7; // The number of frames a single move takes after the initial step. 
	private var frameCountdown:Int 		= 0; // How many frames are left to do in the current move
	private static var moveSpeed:Int 	= 4; // The number of pixels moved per frame.
	
	// Used to tell how recently a direction key was pressed, 
	// relative to the other priority variables.
	private var leftPriority:Int 	= 0; 
	private var rightPriority:Int	= 0;
	private var upPriority:Int		= 0;
	private var downPriority:Int 	= 0;
	
	// Used to tell if the top-priority direction was pressed this frame, or if it was held.
	private var pressedThisFrame:Bool = false;

	private var horizontalMove:Int 	= 0; // Used to track user input with left/right keys.
	private var verticalMove:Int 	= 0; // Used to track user input with up/down keys.
	
	private var currentMove:Direction 	= None;
	private var inputBlocked:Bool 		= false; // True if the character is mid-move
	private var sliding:Bool			= false; // True if the character is sliding on water/ice
	
	
	// Arrays of types used for checking collisions
	// Note: the types are from the subclass, not from the superclass.
	
	private static var backgroundTypes = ["groundTile", "waterTile"];
	private static var actorTypes = ["obstacle"];
	
	
	// Contains references to collision functions.
	// Used in checkGround() and checkNextStep()
	
	private var collisionFunctions = new Map();
	
	
	
	public function new(x:Int, y:Int)
	{
	
		super(x, y);
		setHitbox(32, 32);
		
		bumpSound = new Sfx("audio/bump.mp3");
		idleAnim = new Image("graphics/goodfriend.png");
		graphic = idleAnim;
		
		collisionFunctions = [ 
		
		"obstacle" => obstacleCollision,
		"waterTile" => waterTileCollision,
		"groundTile" => groundTileCollision

		]; 
		
	}
	
	
	
	///////////////////////////////////////////
	//            PLAYER  ACTIONS            //
	///////////////////////////////////////////
	
	
	public function takeDamage(damage:Int){
		scenes.GameScene.GM.damagePlayer(damage);
		//Play an injury animation & sound effect here.
	}
	
	
	
	///////////////////////////////////////////
	//             INPUT PARSING             //
	///////////////////////////////////////////
	
	
	//resets horizontalMove and verticalMove to 0, and checks arrow key input.
	
	private function checkInputs(){
		horizontalMove = 0;
		verticalMove = 0;
		
		if (Input.check(Key.LEFT)){		horizontalMove--; }		
		if (Input.check(Key.RIGHT)){ 	horizontalMove++; }	
		if (Input.check(Key.UP)){    	verticalMove--;   }	
		if (Input.check(Key.DOWN)){		verticalMove++;   }
		
	};
	
	
	
	// Helper function for setInputPrecedence(), increments all Priority variables.
	
	private function incrementPriorities(){
	
		leftPriority++;
		rightPriority++;
		upPriority++;
		downPriority++;
		
	};
	
	
	
	// Identifies the most recently pressed movement key.
	// Used in startMovement
	
	private function setInputPrecedence(){
	
		pressedThisFrame = false; //Resets variable here for new frame.
	
		if (Input.pressed(Key.LEFT)){ 	
			leftPriority = 0; 	
			incrementPriorities();
			pressedThisFrame = true;
		}		
		if (Input.pressed(Key.RIGHT)){	
			rightPriority = 0; 	
			incrementPriorities();
			pressedThisFrame = true;
		}	
		if (Input.pressed(Key.UP)){ 	
			upPriority = 0; 	
			incrementPriorities();
			pressedThisFrame = true;
		}	
		if (Input.pressed(Key.DOWN)){ 	
			downPriority = 0; 	
			incrementPriorities();
			pressedThisFrame = true;
		}
	};
	

	
	// Looks at input variables 'horizontalMove' and 'verticalMove'
	// Determines if Player should move, and if so, what direction.
	
	private function evaluateInput(){
		
		// No input is active
		if( horizontalMove == 0 && verticalMove == 0 ){ 
			currentMove = None;
		}
		
		// Both a vertical and horizontal input are active
		else if( horizontalMove != 0 && verticalMove != 0 ){ 
			
			var horizontalPrio:Int; //Temporary variables used to compare priorities of the inputs.
			var verticalPrio:Int;
			
			var horizontalDir:Direction; //Temporary variables used to tell which inputs are being held.
			var verticalDir:Direction;
			
			
			// --- Check which horizontal direction is active ---
			
			if(horizontalMove == -1){ //Player is holding left
				horizontalPrio = leftPriority;
				horizontalDir = Left;
			}
			else{ //Player is holding right
				horizontalPrio = rightPriority;
				horizontalDir = Right;
			}
			
			
			// --- Check which vertical direction is active ---
			
			if(verticalMove == -1){ //Player is holding up
				verticalPrio = upPriority;
				verticalDir = Up;
			}
			else{ //Player is holding down
				verticalPrio = downPriority;
				verticalDir = Down;
			}
			
			
			// --- Compare priorities and set currentMove ---
			
			if(horizontalPrio < verticalPrio){
				currentMove = horizontalDir;
			}
			else{
				currentMove = verticalDir;
			}
			
		}
		
		else{ //Only one input is active
			
			// --- Check which horizontal direction is active, if any ---
			
			if(horizontalMove == -1){ //Player is holding left
				currentMove = Left;
			}
			else if(horizontalMove == 1){ //Player is holding right
				currentMove = Right;
			}
			
			
			// --- Check which vertical direction is active, if any ---
			
			else if(verticalMove == -1){ //Player is holding up
				currentMove = Up;
			}
			else if(verticalMove == 1){ //Player is holding down
				currentMove = Down;
			}
		}
	}

	
	
	///////////////////////////////////////////
	//            PLAYER MOVEMENT            //
	///////////////////////////////////////////
	
	// Helper function for checkNextStep
	// attempts to do collision with the passed-in entity
	
	private function attemptCollision(e:Entity){
		if( e != null ){
					
			//HXP.console.log(["Detected collision with ", e.type, " in the direction ", currentMove]);
		
			(collisionFunctions[e.type])(e); //call that object's collision function.	
		
		}
	}
	
	
	
	// Check if there is another actor in the direction the player is attempting to move in.
	// If so, attemptCollision() is used to resolve the situation.

	private function checkNextStep(){
		switch currentMove{
			case Left: {
				// Checks 1px left of player for collision with actorType entities
				var e:Entity = collideTypes(actorTypes, x - 1, y); 
				
				attemptCollision(e);
			}
			case Right: {
				// Checks 1px to the right
				var e:Entity = collideTypes(actorTypes, x + 1, y); 
				
				attemptCollision(e);
			
			}
			case Up: {
				// Checks 1px above
				var e:Entity = collideTypes(actorTypes, x, y - 1); 
				
				attemptCollision(e);
			
			}
			case Down: {
				// Checks 1px below
				var e:Entity = collideTypes(actorTypes, x, y + 1); 
				
				attemptCollision(e);
			}
			
			case None: {} //Does nothing
		}
	};
	
	
	
	// Starts player movement and locks player control for the next [[frameDelay]] frames
	
	private function startMovement(){
		
		switch currentMove{
			case Left: moveBy(-1 * moveSpeed, 0);
			case Right: moveBy(moveSpeed, 0);
			case Up: moveBy(0, -1 * moveSpeed);
			case Down: moveBy(0, moveSpeed);
			
			case None: return null; // exits function early, skips setting other variables
		}
		
		inputBlocked = true; // The player cannot change direction until they have finished the move.
		frameCountdown = frameDelay;
		
		return null; // Required by haxe's compiler (since there's a return statement for None.
		
	};
	
	
	
	// While the player's control is locked out, move in the player's movement direction.
	
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
	
	
	
	// Called when the player finishes a movement cycle to see what sort of ground
	// the player is standing on. Calls the appropriate
	
	private function checkGround(){
		var e:Entity = collideTypes(backgroundTypes, x, y);
		if (e != null)
		{
			HXP.console.log(["Detected collision with ", e.type, " beneath Player."]);
			(collisionFunctions[e.type])(e); //calls appropriate collision function.
		}
		else{ //TEMPORARY CODE: remove after level generation is completely fixed!
			collisionFunctions["groundTile"](e);
		
		}
	};
	
	
	
	// Ends the player's movement, or could prevent it from starting.
	
	private function stopMovement(){
		
		if(frameCountdown != 0){
			HXP.console.log(["ERROR: stopMovement was called while frameCountdown != 0"]);
		}
		
		currentMove = None;
		inputBlocked = false;
		sliding = false;
		
		frameCountdown = -1; // Ensures that the game doesn't keep checking what the ground is every frame.
		
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when a player finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	private function waterTileCollision( e:Entity ){
		sliding = true;
		var w:WaterTile = cast(e, WaterTile);
		if(!w.isFrozen()){
			w.freeze();
		}
		checkNextStep();
		startMovement();
	}
	
	
	
	private function groundTileCollision( e:Entity ){
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	
	private function obstacleCollision( e:Entity ){
		if( sliding == true || pressedThisFrame == true ){
			bumpSound.play(.5);
		}
		stopMovement();
	}
	
	
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	// General Plan for update:
	
	// if input is locked, just scoot along
	
	// 		On the last move, check ground to see if it's ice/water
	//		If it's ground, call stop movement
	
	// if input is not locked, parse input    *still parse some inputs, like priority stuff. 
	
	// if currentMove != None, attempt move   *use bool to tell if this should run, even if input is locked.
	
	// 		check for collision in that direction
	
	//		Move in currentDirection (if None, don't move)
	
	
	
	
	public override function update()
	{	

		checkInputs();
		setInputPrecedence();
	
		if( frameCountdown > 0 ){
			
			continueMovement();
		
		}
		else if( frameCountdown <= 0 ){
		
			if( frameCountdown == 0 ){ //Means that movement just ended.
			
				// If the player continues movement here, frameCountdown is reset to frameDelay
				// If the player stops movement here, frameCountdown is set to -1, so it isn't called every frame.
				
				checkGround();
			}
		
			if( frameCountdown <= 0 ){ // Don't want to do this if the frameCountdown was reset.
				
				evaluateInput();
				
				if( currentMove != None){
					checkNextStep();
					startMovement();
				}
			}
		}
			
		//Temporary system for damaging the player.
			
		if (Input.pressed(Key.D)){ takeDamage(1);}
	
		
		
		super.update();
	}
}