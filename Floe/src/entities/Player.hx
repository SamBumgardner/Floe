package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import entities.WaterTile;

import entities.MovingActor; //This actually just for the Direction enum, I think.

import com.haxepunk.HXP;


class Player extends MovingActor
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	// Graphic/Audio asset-holding variables
	private static var idleAnim:Image;
	private static var bumpSound:Sfx;
	
	private static var assetsInitialized:Bool = false; 
	
	
	// Used to tell how recently a direction key was pressed, 
	// relative to the other priority variables.
	private var leftPriority:Int 	= 0; 
	private var rightPriority:Int	= 0;
	private var upPriority:Int		= 0;
	private var downPriority:Int 	= 0;
	
	
	// Used to tell if the top-priority direction was pressed this frame, or if it was held.
	private var pressedThisFrame:Bool = false;

	
	// Variables used to track user input from the arrow keys.
	private var horizontalMove:Int 	= 0; 
	private var verticalMove:Int 	= 0; 
	
	
	// Tells if the character is sliding on water/ice
	private var sliding:Bool = false; 
	

	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		frameDelay = 7;
		moveSpeed = 4;
		
		setHitbox(32, 32);
		
		if( assetsInitialized == false ){
			bumpSound = new Sfx("audio/bump.mp3");
			idleAnim = new Image("graphics/goodfriend.png");
			assetsInitialized = true;
		}
		
		graphic = idleAnim;
		
		
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
	
	// checkInputs()
	//
	// Resets horizontalMove and verticalMove to 0, and checks arrow key input.
	
	private function checkInputs(){
		horizontalMove = 0;
		verticalMove = 0;
		
		if (Input.check(Key.LEFT)){		horizontalMove--; }		
		if (Input.check(Key.RIGHT)){ 	horizontalMove++; }	
		if (Input.check(Key.UP)){    	verticalMove--;   }	
		if (Input.check(Key.DOWN)){		verticalMove++;   }
		
	};
	
	
	
	// incrementPriorities()
	//
	// Helper function for setInputPrecedence(), increments all Priority variables.
	
	private function incrementPriorities(){
	
		leftPriority++;
		rightPriority++;
		upPriority++;
		downPriority++;
		
	};
	
	
	
	// setInputPrecedence()
	//
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
	


	// evaluateInput()
	//
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

	
	// stopMovement()
	//
	// Overrides MovingActor's stopMovement() to track sliding as well.
	
	private override function stopMovement(){
		super.stopMovement();
		sliding = false;
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when a player finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	// waterTileCollision( e:Entity )
	//
	// Freezes the water tile and attempts to move again.
	
	private override function waterTileCollision( e:Entity ){
		sliding = true; // used in obstacle collision to tell if the player slid into it.
		var w:WaterTile = cast(e, WaterTile);
		if(!w.isFrozen()){
			w.freeze();
		}
		checkNextStep();
		startMovement();
	}
	
	// groundTileCollision( e:Entity )
	//
	// The player does not slide around.
	
	private override function groundTileCollision( e:Entity ){
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	// obstacleCollision( e:Entity )
	//
	// Prevent the player from moving into it.
	// If the player slid into the rock or tried to walk into it while adjacent to it,
	// play a sound to alert the user that their movement was prevented.
	
	private override function obstacleCollision( e:Entity ){
		if( sliding == true || pressedThisFrame == true ){
			bumpSound.play(.2);
		}
		stopMovement();
	}
	
	private override function sampleEnemyCollision( e:Entity ){
		stopMovement();
		takeDamage(cast(e, SampleEnemy).attackDamage);
	}
	
	
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
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
				
				if( currentMove != None ){
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