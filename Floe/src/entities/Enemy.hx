package entities;

import com.haxepunk.Entity;

import entities.MovingActor; //This actually just for the Direction enum, I think.

import com.haxepunk.HXP;

enum Dimension {
	X;
	Y;
}


class Enemy extends MovingActor
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	

	private var size:Int;

	
	public var attackDamage:Int;

	private var maxEndurance:Int;
	private var currentEndurance:Int;
	
	private var restTime:Int;
	private var restCountdown:Int = 0;

	private var recalcTime:Int;
	private var recalcCountdown:Int = 0;

	private var destinationX:Int;
	private var destinationY:Int;
	
	private var destDistanceX:Int;
	private var destDistanceY:Int;
	private var atDestination:Bool;
	private var acceptableDestDistance:Int;
	
	private var tiebreakerDimension:Dimension  = X;
	private var tiebreakerDirectionX:Direction = Right;
	private var tiebreakerDirectionY:Direction = Down;
	
	private var moveWasBlocked:Bool = false;
	private var originalMoveDimension:Dimension;
	

	public function new(x:Int, y:Int)
	{
	
		super(x, y);
		setHitbox(32, 32);
		
	
	}
	
	
	
	///////////////////////////////////////////
	//             ENEMY ACTIONS             //
	///////////////////////////////////////////
	
	// attack()
	//
	// Performs some sort of action that could damage the player.
	// Specific behavior is defined in child classes.
	
	private function attack(){};
	
	
	// rest()
	//
	// Sets a frame counter (restCountdown) that makes the enemy inactive 
	// for the next restTime frames.
	//
	// Child classes should override this function to insert their own animations
	// and/or sound effects.
	
	private function rest(){
		restCountdown = restTime;
		currentEndurance = maxEndurance;
	};
	
	
	// calcDestination()
	//
	// Determines the enemy's destination.
	// Sets a frame counter (recalcCountdown) to determine when the enemy
	// should next call calcDestination.
	//
	// Specific behavior should be defined in child classes.
	//
	// Note: call super.calcDestinatoin at the end of the overridden function.
	
	private function calcDestination(){
		recalcCountdown = recalcTime;
		setDestDistances();
	}
	
	
	// checkIfAtDestination( acceptableDistance:Int )
	//
	// Where acceptableDistance is a distance, in number of tiles.
	//
	// Checks if the enemy is "close enough" to its destination to treat
	// atDestination as true.
	
	private function checkIfAtDestination( maxDist:Int ){
		
		if ( Math.sqrt(Math.pow(destDistanceX, 2) + Math.pow(destDistanceY, 2) ) <= maxDist * tileSize ){
			atDestination = true;
		}
		else{
			atDestination = false;
		}
	}
	
	
	// cannotMove()
	//
	// Determines the enemy's behavior when it completely fails to move.
	// Default behavior is to call rest().
	//
	// Specific behavior should be redefined in child classes when necessary.
	
	private function cannotMove(){
		rest();
	}
	
	///////////////////////////////////////////
	//          DIRECTION  SELECTION         //
	///////////////////////////////////////////
	
	
	// setDestDistances()
	//
	// Determines how far the enemy has to move in each direction to reach
	// its destination. 
	// Should be called after finishing a move or calling calcDestination.
	
	private function setDestDistances(){
		destDistanceX = cast(destinationX - x, Int);
		destDistanceY = cast(destinationY - y, Int);
		
		checkIfAtDestination(acceptableDestDistance);
	}
	
	
	// tiebreakX()
	//
	// Determines which X direction to move in if both are equally good.
	// SetsCurrent move to tiebreakX's value, then sets
	// tiebreakX to the other X direction.
	
	private function tiebreakX(){
		currentMove = tiebreakerDirectionX;
		
		if( tiebreakerDirectionX == Left ){ tiebreakerDirectionX = Right; }
		else							  { tiebreakerDirectionX = Left; }
	}
	
	
	// pickXDirection()
	//
	// Identifies which horizontal direction the destination is in,
	// and sets currentMove equal to that direction.
	
	private function pickXDirection(){
		if 		( destDistanceX < 0 )	{ currentMove = Left; }
		else if ( destDistanceX > 0 )	{ currentMove = Right; }
		else if ( destDistanceX == 0 )	{ tiebreakX(); }
	}
	
	
	// tiebreakY()
	//
	// Determines which Y direction to move in if both are equally good.
	// setsCurrent move to tiebreakY's value, then sets
	// tiebreakY to the other Y direction.
	
	private function tiebreakY(){
	currentMove = tiebreakerDirectionY;
		
		if( tiebreakerDirectionX == Up ) {
			tiebreakerDirectionX = Down;
		}
		else{
			tiebreakerDirectionY = Up;
		}
	}
	
	
	// pickYDirection()
	//
	// Identifies which vertical direction the destination is in,
	// and sets currentMove equal to that direction.
	
	private function pickYDirection(){
		if 		( destDistanceY < 0 )	{ currentMove = Up; }
		else if	( destDistanceY > 0 )	{ currentMove = Down; }
		else if ( destDistanceY == 0 )	{ tiebreakY(); }
	}
	
	// tiebreakDimensions()
	//
	// Helper function for selectDirection()
	// Chooses a dimension to move in based on the tiebreakerDimension variable,
	// then switches the tiebreakerDimension's value.
	
	private function tiebreakDimensions(){
		switch tiebreakerDimension{
				case X: {	pickXDirection();
							originalMoveDimension = X;
							tiebreakerDimension = Y;}
				case Y:	{	pickYDirection();
							originalMoveDimension = Y;
							tiebreakerDimension = X;}
			}
	}
	
	
	// selectDirection()
	//
	// Generates the enemy's "input" for movement.
	// Selects the direction that has the largest (magnitude) destDistance.
	// If it needs to move equally far vertically and horizontally to reach its destination,
	// then it alternates between the two.
	
	private function selectDirection(){
		if ( atDestination ){
			currentMove = None;
		}
		else if ( Math.abs(destDistanceX) > Math.abs(destDistanceY) ){
			originalMoveDimension = X;
			pickXDirection();
		
		}
		else if	( Math.abs(destDistanceX) < Math.abs(destDistanceY) ){
			originalMoveDimension = Y;
			pickYDirection();
		
		}
		else if ( Math.abs(destDistanceX) == Math.abs(destDistanceY) ){
			
			tiebreakDimensions();
			
		}
	}
	
	
	// selectOtherDirection()
	//
	// Alternate version of select direction, called after the enemy finds a blocking 
	// collision in the spot they'd like to move to.
	
	private function selectOtherDirection(){
		if ( originalMoveDimension == Y ){
			pickXDirection();
		}
		else if ( originalMoveDimension == X ){
			pickYDirection();
		}
	}
	
	
	
	///////////////////////////////////////////
	//            ENEMY  MOVEMENT            //
	///////////////////////////////////////////
	
	// startMovement()
	//
	// Overrides MovingActor's startMovement
	// makes moving decrease the enemy's currentEndurance
	
	private override function startMovement(){
		currentEndurance--;
		super.startMovement();
	}
	
	// continueMovement()
	//
	// Overrides MovingActor's continueMovement
	// makes moving decrease the enemy's currentEndurance
	
	private override function continueMovement(){
		currentEndurance--;
		super.continueMovement();
	}
	
	// stopMovement()
	//
	// Overrides MovingActor's stopMovement().
	// If the enemy finished moving (and wasn't just stopped in place)
	// it recalculates its destDistance variables.
	
	private override function stopMovement(){
		super.stopMovement();
		if( !moveWasBlocked ){ setDestDistances(); }
	}
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	// update()
	//
	// This function is called every frame.
	// Here's a quick breakdown of the logic involved:
	//
	//	If the enemy is not resting and...
	//		
	//		is ready to recalulate destination:
	//			then recalculate destination
	//		
	//		is in the middle of moving:
	//			then keep moving
	//
	//		is not in the middle of moving and...
	//			
	//			just finished moving: 
	//				then check what kind of ground it stopped on
	//
	//			is still not moving after checking the ground and...
	//				if the enemy has run out of endurance:
	//					it starts resting, and exits the update loop.
	//
	//				pick a direction to move in (or just to stay still)
	//
	//				if it picked a direction to move in and...
	//			
	//					that direction is blocked:
	//						then pick a different direction to move in (or None)
	//
	//						if it picked a direction to move in and...
	//
	//							that direction is blocked:
	//								do whatever it does when it can't move
	//
	//					Alternatively, if any direction it picked was not blocked, then:
	//						it moves in that direction
	//
	//	If the enemy was resting:
	//		Then keep waiting for it to wake up
	//
	
	
	public override function update(){
	
		if ( restCountdown <= 0 ){
		// --- enemy is not resting ---
		
			if( recalcCountdown < 0 ){
				calcDestination();
			}
			
			if( frameCountdown > 0 ){
				continueMovement();
			}
			else if( frameCountdown <= 0 ){
				
				if( frameCountdown == 0 ){
					checkGround();
				}
				
				if( frameCountdown <= 0 ){
				
					if( currentEndurance <= 0 ){
						rest();
						return;
					}
				
					selectDirection();
					
					if( currentMove != None ){
						checkNextStep();
						
						if( currentMove == None ){ 
						// --- First attempted move was blocked, try again in a different direction ---
						
							selectOtherDirection();
							checkNextStep();
							
							if( currentMove == None ){
							// --- Both moves failed ---
								cannotMove();
							}
						}

						startMovement();
					}
				}
			}
		}
		else{ // --- enemy is resting ---
			restCountdown--;
		}

		recalcCountdown--;
		
		super.update();

	}

}