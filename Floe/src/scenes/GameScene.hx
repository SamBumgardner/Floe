package scenes;

import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.Entity;
import entities.Player;
import entities.SampleEnemy;
import entities.FireEnemy;
import entities.MistEnemy;
import entities.WaterEnemy;
import entities.BorderEnemy;
import entities.LightningEnemy;
import entities.Tile;
import entities.WaterTile;
import entities.GroundTile;
import entities.Obstacle;
import entities.Border;
import entities.GameManager;
import entities.PauseMenu;
import entities.HUD;

import com.haxepunk.Sfx;


class GameScene extends Scene {


	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////


	//declare static entities 
	private static var music:Sfx;
	public  static var GM:GameManager;
	private static var pausedMenu:PauseMenu;
	private static var musicPlaying:Bool = false;
	
	//Use a single boolean variable to check if the static assets have been set up.
	private static var staticAssetSetup:Bool = false;
	
	public var PC:Player;
	
	// Used for pausing/unpausing the game.
	private var entitiesInLevel:Array<Entity> = [];
	private var gamePaused:Bool = false;
	
	// Heads up display
	private var hud:HUD;
	
	public function new(?gameManager:GameManager) //leading ? means optional parameter.
	{
		super();
		
		if(gameManager != null){ //This only happens when a new game is started.
			GM = gameManager;
			musicPlaying = false;
		}
		
		if(!staticAssetSetup){
			//All entity and asset assignments for static variables go here.
			music = new Sfx("audio/bgm.mp3");
			staticAssetSetup = true;
			pausedMenu = new PauseMenu();
		}
		hud = GameManager.hud;
		
	}
	

	///////////////////////////////////////////
	//           LEVEL  GENERATION           //
	///////////////////////////////////////////	
	
	// addEnemy( x:Int, y:Int )
	//
	// Picks an enemy type, then adds that enemy to location (x, y)
	//
	// There's only one enemy type at the moment, so it's rather basic.
	
	private function addEnemy( x:Int, y:Int ){
		var rand = HXP.random % .5;
		if(rand < .11){
			add( new SampleEnemy(x, y) );
		}
		
		else if (rand < .22){
			add( new FireEnemy(x, y) );
		}
		
		else if (rand < .33){
			add( new MistEnemy(x, y) );
		}
    else if (rand < .44){
      add( new LightningEnemy(x, y));
    }
	}
	
	
	// generateLevel()
	//
	// Procedurally generates level using HaxePunk's seeded RNG.
	
	private function generateLevel(){
		
		var tileSize = 32;
		
		var originX = 0;
		var originY = tileSize * 2;
		
		var maxX = tileSize * 19;
		var maxY = tileSize * 17;
		
		
		var placeX = originX; 
		var placeY = originY;
		
		var playerX = tileSize * 10; // Player's starting X & Y position.
		var playerY = tileSize * 16;
		
		
		var enemyCount = 0; // Counts number of enemies placed in the level.
		var maxEnemies = 3;
		
		// To ensure all levels can be completed, we require 2+ non-obstacle tiles
		// to be placed horizontally between obstacles in the lake.
		var minimumSpaceBetweenObstacles = 2;
		var tilesSinceLastObstacle = 0;
		var RocksInPreviousRow = [];
		var RocksInCurrentRow = [];
		
		PC = new Player(playerX, playerY);
		add(PC);
		
		
		while( placeY <= maxY ){
			while( placeX <= maxX ){
				
				if( placeX == originX || placeY == originY || 
					placeX == maxX || placeY == maxY){
				
					add(new Border(placeX, placeY));
					
					placeX += tileSize;
					continue;
				}
				
				if( placeX == originX + tileSize || placeY == originY + tileSize || 
					placeX == maxX - tileSize || placeY == maxY - tileSize){
				
					if( placeY == originY + tileSize ) {
						if (HXP.random > .96 && enemyCount < maxEnemies){
							add( new BorderEnemy(placeX, placeY));
							enemyCount++;
						}
					}
					
					add(new GroundTile(placeX, placeY));
					
					placeX += tileSize;
					continue;
				}
			
				if(HXP.random > .15){
					add(new WaterTile(placeX, placeY));
					tilesSinceLastObstacle++;
					if (HXP.random > .99 && enemyCount < maxEnemies){
						add( new WaterEnemy(placeX, placeY));
						enemyCount++;
					}
					
					if(HXP.random < .05 && enemyCount < maxEnemies){
						addEnemy(placeX, placeY); //this will now randomly generate lightning Enemies
						enemyCount++;
					}
				}
				else{
					if(	HXP.random > .90 || tilesSinceLastObstacle < minimumSpaceBetweenObstacles ||
						RocksInPreviousRow.indexOf(placeX) != -1 || 
						RocksInPreviousRow.indexOf(placeX + tileSize) != -1 ||
						RocksInPreviousRow.indexOf(placeX - tileSize) != -1 ){
						
						add(new GroundTile(placeX, placeY));
						tilesSinceLastObstacle++;
						
						if(HXP.random < .1 && enemyCount < maxEnemies){
							addEnemy(placeX, placeY);
							enemyCount++;
						}
					}
					else{
						add(new Obstacle(placeX, placeY));
						tilesSinceLastObstacle = 0;
						RocksInCurrentRow.push(placeX);
					}
				}
			
				placeX += tileSize;
			}
			RocksInPreviousRow = RocksInCurrentRow.copy();
			RocksInCurrentRow = [];
			placeX = 0;
			placeY += tileSize;
		}
		
		//HXP.console.log(["Level has been generated!"]);
	}
	
	
	
	///////////////////////////////////////////
	//            LEVEL START/END            //
	///////////////////////////////////////////
	
	
	// begin()
	//
	// Called when Main sets an instance of GameScene as the current scene.
	
	public override function begin()
	{
		//HXP.console.log(["Level is loading..."]);
		
		if(!musicPlaying){
			music.loop(HXP.engine.musicVolume);
			musicPlaying = true;
		}
		
		add(GM);
		
		generateLevel();
		
		add(hud);
		
		hud.updateScore(GM.getScore());
	}
	
	// end()
	//
	// Called automatically when a level is finished.
	
	public override function end(){
		removeAll();
		super.end();
	}
	
	
	// endMusic()
	//
	// Called when going to the gameOver scene, and not the next level.
	// Stops the looping music.

	
	public function endMusic(){
		music.stop();
	}
	
	// gameOver()
	//
	// Called when going to the gameOver scene, and not the next level.
	// Returns the GameManager object for the gameOver scene to use.
	
	public function gameOver(){
		return GM;
	}
	
	///////////////////////////////////////////
	//          PAUSE/UNPAUSE  GAME          //
	///////////////////////////////////////////
	
	// pauseGame()
	//
	// Iterates through list of entities in the scene, and sets active to false.
	// Will also bring up the pause menu.


	private function pauseGame(){
		
		// --- first-time setup ---

		getAll(entitiesInLevel);

		for( entity in entitiesInLevel ){
			if(entity.type != "manager" && entity.type != ""){
				(cast entity).pause();
			}
		}
		
		music.stop();
		add(pausedMenu);
		
		//HXP.console.log(["Paused the game!"]);
	}
	
	// unpauseGame()
	//
	// Reverses the actions of pauseGame.
	
	private function unpauseGame(){
		
		remove( (cast pausedMenu) );
		
		for( entity in entitiesInLevel ){
			if(entity.type != "manager" && entity.type != ""){
				(cast entity).unpause();
			}
		}

		entitiesInLevel.splice(0, entitiesInLevel.length);
		
		music.resume();
		gamePaused = false;
		//HXP.console.log(["Unpaused the game!"]);
	}
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////	
	
	
	// update()
	//
	// Called every frame to update the scene.
	// Used to check if the player paused or unpaused the game.
	
	public override function update(){
		if(Input.pressed(Key.ESCAPE)){
			if( !GM.levelCompleted && !GM.levelFailed ){
				if( !gamePaused ){
					gamePaused = true;
					pauseGame();
				}
				else if( gamePaused ){
					gamePaused = false;
					unpauseGame();
				}
			}
		}
		
		super.update();
	}
	
}