package entities;

///This  class will belong to the game's engine, and is responsible for:
// Communication with the engine
// Tracking level completion
// Tracking player score
// Providing information about score when asked

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import entities.HUD;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class GameManager extends Entity{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private var unfrozenWaterCount:Int 	= 0;
	private var totalScore:Int 			= 0;
	private var playerHealth:Int 		= 3;
	public var lake:Int				= 1;
	public static var hud:HUD;
	
	private var waitTime:Int;
	public var levelCompleted:Bool = false;
	public var levelFailed:Bool = false;
	
	
	// Constructor
	
	public function new(x:Int = 0, y:Int = 0){
		super(x, y);
		type = "manager";
		hud = new HUD(0, 0, playerHealth);
	}
	
	
	
	///////////////////////////////////////////
	//            MANAGER ACTIONS            //
	///////////////////////////////////////////
	
	
	// waterAdded()
	//
	// Called when a water tile is added to the game scene, or is unfrozen.
	
	public function waterAdded(){
		unfrozenWaterCount++;
	}
	
	
	// waterFrozen()
	//
	// Called by WaterTile as part of its freeze() function.
	// Decrements count of water tiles, and checks if the level has been completed.
	
	public function waterFrozen(){
		unfrozenWaterCount--;
		//addScore(10);

		//HXP.console.log([unfrozenWaterCount, " unfrozen water tiles remain."]);
		
		if(unfrozenWaterCount <= 0){
			//HXP.console.log(["Level Complete!"]);
			
			var entitiesInLevel:Array<Entity> = [];
			HXP.scene.getAll(entitiesInLevel);
			
			for( entity in entitiesInLevel ){
				if(entity.type != "player" && entity.type != "manager"){
					entity.active = false;
				}
				else if(entity.type == "manager"){
					// Do nothing
				}
				else{ //Is player
					(cast entity).levelComplete();
				}
			}
			
			// Number of frames to delay moving onto the next level 
			waitTime = 99;
			levelCompleted = true;
		}
	}
	
	
	// damagePlayer(damage:Int)
	//
	// Updates variables and hud reduce the player's health after they take damage.
	// If the player is at zero health, it begins the game over sequence.
	
	public function damagePlayer(damage:Int){
		playerHealth -= damage;
		hud.updateHealth(playerHealth);
		//HXP.console.log(["Took ", damage, " damage! Only ", playerHealth, " health remaining."]);
		if(playerHealth <= 0){
			
			var entitiesInLevel:Array<Entity> = [];
			HXP.scene.getAll(entitiesInLevel);
			
			for( entity in entitiesInLevel ){
				if(entity.type != "player" && entity.type != "manager"){
					entity.active = false;
				}
				else if( entity.type == "player" ){ //Is player
					(cast entity).levelFailed();
				}
			}
			
			// Number of frames to delay moving onto the next level 
			(cast HXP.scene).endMusic();
			waitTime = 99;
			levelFailed = true;
		}
	}
	
	
	// Adds specified amount of hp to playerHealth and updates hud
	
	public function addHealth(hpToAdd:Int) {
		playerHealth += hpToAdd;
		hud.updateHealth(playerHealth);
	}
	
	
	// Advances the level (lake)
	
	public function nextLake() {
		if (waitTime == 0){
				addScore( 50 * lake );
				
				levelCompleted = false;
				HXP.engine.nextLevel();
				lake++;
				if (lake % 2 == 1) {
						addHealth(1);
				}
				hud.updateLake(lake);
			}
			else{
				waitTime--;
			}
	}
	
	
	//Returns the player's health as an integer
	
	public function getHealth() {
		return playerHealth;
	}
	
	
	//Called by various entities, increases score
	
	public function addScore(points:Int){
		totalScore += points;
		hud.updateScore(totalScore);
	}
	
	
	//Returns the player's score as an integer
	
	public function getScore(){
		return totalScore;
	}

	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	public override function update(){
		if( levelFailed == true ){
			if (waitTime == 0){
				levelFailed = false;
				HXP.engine.gameOver();
			}
			else{
				waitTime--;
			}
		}
		else if( levelCompleted == true || (HXP.console.debug && Input.pressed(Key.N))){
			nextLake();
		}
		
		super.update();
	}
}