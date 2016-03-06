package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import entities.WaterTile;

import com.haxepunk.HXP;

class Player extends Entity
{
	
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
		HXP.console.watch(["sliding"]);
	
		super(x, y);
		setHitbox(32, 32);
		moveSpeed = 4;
		moveTime = 8; // doesn't do anything yet.
		
		horizontalMove = 0;
		verticalMove = 0;
		sliding = false;
		
		idleAnim = new Image("graphics/goodfriend.png");
		
		graphic = idleAnim;
		
		frameDelay = 7; // For some reason this is different for moving and sliding. Sliding needs to be 8, while moving has to be seven.
		frameCountdown = 0; 
		
		numberOfMoves = 0;
		
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
		frameCountdown = frameDelay; //The + 1 is necessary because sliding technically gets one less frame of movement than walking, because of how I set up update function.
	}
	
	
	
	public override function update()
	{	
		if(frameCountdown <= 0){
			var w:Entity = collide("waterTile", x, y);
			if (w != null)
			{
				var w:WaterTile = cast(w, WaterTile);
				w.freeze();
				slide();
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
					moveBy(horizontalMove * moveSpeed, 0);
					lastMove = horizontalMove;
					
					frameCountdown = frameDelay;
					//numberOfMoves++;
					//HXP.console.log([numberOfMoves]);
				}
				else if(verticalMove != 0){
					moveBy(0, verticalMove * moveSpeed);
					lastMove = verticalMove + 3; //offset so that there is no conflict with horizontal move in the switch statement.
					
					frameCountdown = frameDelay;
					//numberOfMoves++;
					//HXP.console.log([numberOfMoves]);
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