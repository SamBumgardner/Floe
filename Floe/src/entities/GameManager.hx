package entities;

///This  class will belong to the game's engine, and is responsible for:
// Communication with the engine
// Tracking level completion
// Tracking player score
// Providing information about score when asked

import com.haxepunk.HXP;
import com.haxepunk.Entity;

class GameManager extends Entity{
	
	private var unfrozenWaterCount:Int;
	private var totalScore:Int;
	
	public function new(x:Int = 0, y:Int = 0){
		super(x, y);
		
		unfrozenWaterCount = 0;
		totalScore = 0;
		//I need to use the random seed for something.
	}
	
	public function waterAdded(){
		unfrozenWaterCount++;
	}
	public function waterFrozen(){
		unfrozenWaterCount--;
		addScore(10);
		
		HXP.console.log([unfrozenWaterCount, " unfrozen water tiles remain."]);
		
		if(unfrozenWaterCount <= 0){
			HXP.console.log(["Level Complete!"]);
			HXP.engine.nextLevel();
		}
	}
	
	public function addScore(points:Int){
		totalScore += points;
	}
	
	public function getScore(){
		return totalScore;
	}
	
	public function newLevelSetup(){
		unfrozenWaterCount = 0;
	}
	
}