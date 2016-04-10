package entities;

///This  class will belong to the game's engine, and is responsible for:
// Communication with the engine
// Tracking level completion
// Tracking player score
// Providing information about score when asked

import com.haxepunk.HXP;
import com.haxepunk.Entity;

class GameManager extends Entity{
	
	private var unfrozenWaterCount:Int 	= 0;
	private var totalScore:Int 			= 0;
	private var playerHealth:Int 		= 3;
	
	public function new(x:Int = 0, y:Int = 0){
		super(x, y);
	}
	
	//Called by WaterTile upon construction
	public function waterAdded(){
		unfrozenWaterCount++;
	}
	
	public function waterThawed(){
		unfrozenWaterCount++;
		HXP.console.log([unfrozenWaterCount, " unfrozen water tiles remain."]);
	}
	
	//Called by WaterTile as part of its freeze() function
	public function waterFrozen(){
		unfrozenWaterCount--;
		//addScore(10);
		
		HXP.console.log([unfrozenWaterCount, " unfrozen water tiles remain."]);
		
		if(unfrozenWaterCount <= 0){
			HXP.console.log(["Level Complete!"]);
			HXP.engine.nextLevel();
		}
	}
	
	public function damagePlayer(damage:Int){
		playerHealth -= damage;
		HXP.console.log(["Took ", damage, " damage! Only ", playerHealth, " health remaining."]);
		if(playerHealth <= 0){
			HXP.engine.gameOver();
		}
	}
	
	//Called by various entities, increases score
	public function addScore(points:Int){
		totalScore += points;
	}
	
	//Returns the player's score as an integer
	public function getScore(){
		return totalScore;
	}
}