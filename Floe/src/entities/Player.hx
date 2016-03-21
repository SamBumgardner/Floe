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

//Note about bump sound effect logic:
/*
	To prevent the bump from sounding on every frame, I set bumpStop to true after playing the sound.
	If bumpStop is true, then the sound will not be played, even if they player is holding movement
	toward a rock or is sliding into one.
	
	After pressing any key, bumpStop is reset, allowing the sound to play again.
*/



class Player extends Entity
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private var maxHealth:Int;
	private var currentHealth:Int;
	
	private var bumpSound:Sfx;
	private var stopBump:Bool; //hacky way to make this only play once.
	
	
	private static var frameDelay:Int;
	private var frameCountdown:Int;
	private static var moveSpeed:Int;
	
	// Used to tell how recently a direction key was pressed, relative to
	// the other priority variables.
	private var leftPriority:Int = 0; 
	private var rightPriority:Int= 0;
	private var upPriority:Int = 0;
	private var downPriority:Int = 0;
	
	// Used to tell if the top-priority direction was pressed this frame, or if it was held.
	private var pressedThisFrame:Bool = false;

	private var horizontalMove:Int = 0; //Used to track user input with left/right keys.
	private var verticalMove:Int = 0;	//Used to track user input with up/down keys.
	
	private var currentMove:Direction = None;
	private var lastMove:Direction = None;
	private var sliding:Bool = False;
	
	private var idleAnim:Image;
	
	
	public function new(x:Int, y:Int)
	{
	
		super(x, y);
		setHitbox(32, 32);
		moveSpeed = 4;
		moveTime = 8; 
		
		bumpSound = new Sfx("audio/bump.mp3");
		stopBump = false;
	
		maxHealth = 3;
		currentHealth = maxHealth;
		
		horizontalMove = 0;
		verticalMove = 0;
		sliding = false;
		
		idleAnim = new Image("graphics/goodfriend.png");
		
		graphic = idleAnim;
		
		frameDelay = 7; 
		frameCountdown = 0; 
		
		numberOfMoves = 0;		
	}
	
	///////////////////////////////////////////
	//            PLAYER  ACTIONS            //
	///////////////////////////////////////////
	
	private function canSlide(){

		if(lastMove < 2){
			var o:Entity = collide("obstacle", x + lastMove, y);
			if (o != null)
			{
				return false;
			}
		}
		else{
		
			var o:Entity = collide("obstacle", x, y + lastMove - 3);
			if (o != null)
			{
				return false;
			}
		}
		//If it gets to here, it's safe to slide
		return true;
	}
		
		
	
	
	private function slide()
	{
		
		sliding = true;
		switch lastMove{
			case Left: moveBy(-1 * moveSpeed, 0);
			case Right: moveBy(moveSpeed, 0);
			case Up: moveBy(0, -1 * moveSpeed);
			case Down: moveBy(0, moveSpeed);
		}
		frameCountdown = frameDelay;
	}
	
	private function isDead(){
	
		//only need to call this after taking damage.
	
		if(currentHealth <= 0){
			HXP.engine.gameOver();
		}
	
	}
	
	public function takeDamage(damage:Int){
	
		currentHealth -= damage;
		HXP.console.log(["Took ", damage, " damage! Only ", currentHealth, " health remaining."]);
		isDead();//Check if the player died as a result.
	}
	
	
	//Called when the player finishes a movement cycle to see if the player should start sliding.
	//Only moves player if the player has a non-zero value in the "last move" variable &&
	//If the tile underfoot is slippery, like ice.
	private function checkGround(){
		
	};
	
	//Ends the player's movement, setting variables used for sliding and such.
	private function stopMovement(){
		
	};
	
	
	
	///////////////////////////////////////////
	//             INPUT PARSING             //
	///////////////////////////////////////////
	
	
	//Called near the start of update (if not in the middle of movement) to get the user's inputs.
	private function checkInputs(){
		
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
	

	
	// Last step in the input sequence determines whether the player should move, and if so, what direction.
	private function evaluateInput(){
		
		//No input is active
		if( horizontalMove == 0 && verticalMove == 0 ){ 
			currentMove = None;
		}
		
		//Both a vertical and horizontal input are active
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
				verticalPrio = downPriority
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
			else{ //Player is holding right
				currentMove = Right;
			}
			
			
			// --- Check which vertical direction is active, if any ---
			
			if(verticalMove == -1){ //Player is holding up
				currentMove = Up;
			}
			else{ //Player is holding down
				currentMove = Down;
			}
			
			
		}
	}
	
	
	
	
	///////////////////////////////////////////
	//            PLAYER MOVEMENT            //
	///////////////////////////////////////////
	
	
	
	//Starts player movement, locking player control for the next x frames
	//Also sets a variable to track the player's movement direction (in case the player starts sliding on ice.
	//Also resets the player's "Can't move" variables, since the player is in a different direction.
	private function startMovement(){
		
	};
	
	
	//While the player's control is locked out, move in the player's movement direction.
	private function continueMovement(){
		switch lastMove{
			case Left: moveBy(-1 * moveSpeed, 0);
			case Right: moveBy(moveSpeed, 0);
			case Up: moveBy(0, -1 * moveSpeed);
			case Down: moveBy(0, moveSpeed);
			}
		frameCountdown--;
	};
	
	
	
	
	
	//Called when a movement key is pressed. identifies if a particular route for movement is blocked.
	//If it is, set a boolean variable for that direction to show that it's blocked.
	//That variable will be reset after the player successfully moves.
	//Possibly execute some code every time this fails.
	private function checkNextStep(){
		
	};
	
	
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	
	public override function update()
	{	
		//check if the bump sound should be played again.
		if (Input.pressed(Key.LEFT) || Input.pressed(Key.RIGHT)
			|| Input.pressed(Key.UP) || Input.pressed(Key.DOWN)){stopBump = false;}
	
	
		if(frameCountdown <= 0){
			var w:Entity = collide("waterTile", x, y);
			if (w != null)
			{
				var w:WaterTile = cast(w, WaterTile);
				if(!w.isFrozen()){
					w.freeze();
				}
				
				if(canSlide() && lastMove != 0){ //check if the player can move in lastMove
					slide();
				}
				else if(lastMove != 0){
					if(!stopBump){
						bumpSound.play(0.5);
						stopBump = true;
					}
					lastMove = 0;
				}
			}
			
			if(sliding == false)
			{
				
				//use incrementation so that opposite keys cancel each other out.
				if (Input.check(Key.LEFT)){ horizontalMove--; }
				
				if (Input.check(Key.RIGHT)){horizontalMove++;}
				
				if (Input.check(Key.UP)){verticalMove--;}
				
				if (Input.check(Key.DOWN)){verticalMove++;}
			
			
				//Horizontal movement has priority over vertical movement if both are pressed on the same frame.
				
				if(horizontalMove != 0){
					//check if there is an obstacle blocking movement.
					var o:Entity = collide("obstacle", x + horizontalMove, y);
					if (o != null)
					{
						//Do nothing.
					}
					else{	
						moveBy(horizontalMove * moveSpeed, 0);
						if(horizontalMove == -1){lastMove = Left;}
						if(horizontalMove == 1){lastMove = Right;}
						
						frameCountdown = frameDelay;
						//numberOfMoves++;
						//HXP.console.log([numberOfMoves]);
					}
				}
				else if(verticalMove != 0){
					var o:Entity = collide("obstacle", x, y + verticalMove);
					if (o != null)
					{
						//Do nothing.
					}
					else{	
						moveBy(0, verticalMove * moveSpeed);
						if(verticalMove == -1){lastMove = Up;}
						if(verticalMove == 1){lastMove = Down;}
						
						frameCountdown = frameDelay;
						//numberOfMoves++;
						//HXP.console.log([numberOfMoves]);
					}
				}
			
			
			
				//These must be reset for future frames.
				horizontalMove = 0;
				verticalMove = 0;
			}
			sliding = false;
			
		}
		else{ //This means that the player is mid-movement, either sliding.
			switch lastMove{
			case -1: moveBy(-1 * moveSpeed, 0);
			case 1: moveBy(moveSpeed, 0);
			case 2: moveBy(0, -1 * moveSpeed);
			case 4: moveBy(0, moveSpeed);
			}
			frameCountdown--;
		}
		
		//HXP.console.log([frameCountdown]);
		
		
		//Temporary system for damaging the player.
			
		if (Input.pressed(Key.D)){ takeDamage(1);}
	
		
		
		super.update();
	}
}