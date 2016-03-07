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
	
	private var PC:Player;
	private var unfrozenWaterCount:Int;
	
	public function new(x:Int, y:Int, playerObj:Player){
		super(x, y);
		PC = playerObj;
		
		unfrozenWaterCount = 0;
		
	}
	
	public function waterAdded(){
		unfrozenWaterCount++;
	}
	public function waterFrozen(){
		unfrozenWaterCount--;
		
		HXP.console.log([unfrozenWaterCount]);
		
		if(unfrozenWaterCount <= 0){
			HXP.console.log(["Level Complete!"]);
			HXP.engine.nextLevel();
		}
	}
	
	public override function update(){
	
		if (Input.pressed(Key.D)){ PC.takeDamage(1);}
	
	}
	
	
	
}