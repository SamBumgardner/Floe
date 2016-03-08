package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import entities.WaterTile;

import com.haxepunk.HXP;

//Note about bump sound effect logic:
/*
	To prevent the bump from sounding on every frame, I set bumpStop to true after playing the sound.
	If bumpStop is true, then the sound will not be played, even if they player is holding movement
	toward a rock or is sliding into one.
	
	After pressing any key, bumpStop is reset, allowing the sound to play again.
*/



class Player extends Entity
{
	
	private var maxHealth:Int;
	private var currentHealth:Int;
	
	private var bumpSound:Sfx;
	private var stopBump:Bool; //hacky way to make this only play once.
	
	
	private var frameDelay:Int;
	private var frameCountdown:Int;
	private var moveSpeed:Int;
	private var moveTime:Int;
	
	private var horizontalMove:Int; //Used to track user input with left/right keys.
	private var verticalMove:Int;	//Used to track user input with up/down keys.
	
	private var lastMove:Int;
	private var sliding:Bool;
	private var numberOfMoves:Int;
	
	
	private var idleAnim:Image;
	
	
	public function new(x:Int, y:Int)
	{
	
		super(x, y);
		setHitbox(32, 32);
		moveSpeed = 4;
		moveTime = 8; 
		
		bumpSound = new Sfx("audio/bump.mp3");
		stopBump = false;
		
		HXP.console.watch(["sliding"]);
	
		maxHealth = 3;
		currentHealth = maxHealth;
		
		horizontalMove = 0;
		verticalMove = 0;
		sliding = false;
		
		idleAnim = new Image("graphics/goodfriend.png");
		
		graphic = idleAnim;
		
		frameDelay = 7; // For some reason this is different for moving and sliding. Sliding needs to be 8, while moving has to be seven.
		frameCountdown = 0; 
		
		numberOfMoves = 0;
		
	}
	
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
			case -1: moveBy(-1 * moveSpeed, 0);
			case 1: moveBy(moveSpeed, 0);
			case 2: moveBy(0, -1 * moveSpeed);
			case 4: moveBy(0, moveSpeed);
		}
		frameCountdown = frameDelay;
	}
	
	private function isDead(){
	
		//only need to call this after taking damage.
	
		if(currentHealth < 0){
			HXP.engine.gameOver();
		}
	
	}
	
	public function takeDamage(damage:Int){
	
		currentHealth -= damage;
		isDead();//Check if the player died as a result.
	}
	
	public override function update()
	{	
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
				//check if the bump sound should be played again.
				if (Input.pressed(Key.LEFT) || Input.pressed(Key.RIGHT)
					|| Input.pressed(Key.UP) || Input.pressed(Key.DOWN)){stopBump = false;}
				
				
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
						if(!stopBump){
							bumpSound.play(0.5);
							stopBump = true;
						}
					}
					else{	
						moveBy(horizontalMove * moveSpeed, 0);
						lastMove = horizontalMove;
						
						frameCountdown = frameDelay;
						//numberOfMoves++;
						//HXP.console.log([numberOfMoves]);
					}
				}
				else if(verticalMove != 0){
					var o:Entity = collide("obstacle", x, y + verticalMove);
					if (o != null)
					{
						if(!stopBump){
							bumpSound.play(0.5);
							stopBump = true;
						}
					}
					else{	
						moveBy(0, verticalMove * moveSpeed);
						lastMove = verticalMove + 3; //offset so that there is no conflict with horizontal move in the switch statement.
						
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
		
		
		super.update();
	}
}