package entities;

///Long term idea: this class will be used as a middle man for user interactions, and hold general game information that doesn't belong to other classes.

import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import entities.WaterTile;
import entities.Player;

import com.haxepunk.HXP;

class GameManager extends Entity{
	
	private var unfrozenWaterCount:Int;
	private var totalScore:Int;
	
	public function new(x:Int, y:Int, playerObj:Player){
		super(x, y);
		
		unfrozenWaterCount = 0;
		
	}
	
	public function waterAdded(){
		unfrozenWaterCount++;
	}
	public function waterFrozen(){
		unfrozenWaterCount--;
		
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
	
	public override function update(){
	
	}
	
	
	
}