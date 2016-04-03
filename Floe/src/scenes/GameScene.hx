package scenes;

/* Where to find the non-overloaded public functions and static things:
 *	Game Manager stuff:
 * 		I declare the game manager as a public static variable at line 31.
 * 		A GameManager can optionally be passed in as a parameter to new. 
 *		It's assigned value in new() at line 45
 *
 * 	GameOver stuff:
 *		public function GameOver is set up at line 116
 * 
 */



import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.Player;
import entities.SampleEnemy;
import entities.Tile;
import entities.WaterTile;
import entities.GroundTile;
import entities.Obstacle;
import entities.GameManager;

import com.haxepunk.Sfx;


class GameScene extends Scene {


	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////


	//declare static entities 
	private static var music:Sfx;
	public  static var GM:GameManager;
	private static var musicPlaying:Bool = false;
	
	//Use a single boolean variable to check if the static assets have been set up.
	private static var staticAssetSetup:Bool = false;
	
	public var PC:Player;
	
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
		}
		
	}
	

	///////////////////////////////////////////
	//           lEVEL  GENERATION           //
	///////////////////////////////////////////	
	
	// placeBorderObstacles()
	
	private function placeBorderObstacles()
	{
		
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
		
		PC = new Player(playerX, playerY);
		add(PC);
		
		
		while( placeY <= maxY ){
			while( placeX <= maxX ){
			
				if( placeX == originX || placeY == originY || 
					placeX == maxX || placeY == maxY){
				
					add(new Obstacle(placeX, placeY, "border"));
					
					placeX += tileSize;
					continue;
				}
				
				if( placeX == originX + tileSize || placeY == originY + tileSize || 
					placeX == maxX - tileSize || placeY == maxY - tileSize){
				
					add(new GroundTile(placeX, placeY));
					
					placeX += tileSize;
					continue;
				}
			
			
				if(HXP.random > .1){
					add(new WaterTile(placeX, placeY));

					
					if(HXP.random < .05 && enemyCount < maxEnemies){
						add(new SampleEnemy(placeX, placeY));
						enemyCount++;
					}
				}
				else{
					if(HXP.random > .5){
						add(new GroundTile(placeX, placeY));
						
						if(HXP.random < .1 && enemyCount < maxEnemies){
							add(new SampleEnemy(placeX, placeY));
							enemyCount++;
						}
					}
					else{
						add(new Obstacle(placeX, placeY, "rock"));
					}
				}
			
				placeX += tileSize;
			}
			placeX = 0;
			placeY += tileSize;
		}
		
		HXP.console.log(["Level has been generated!"]);
	}
	
	
	
	///////////////////////////////////////////
	//            LEVEL START/END            //
	///////////////////////////////////////////
	
	
	// begin()
	//
	// Called when Main sets an instance of GameScene as the current scene.
	
	public override function begin()
	{
		HXP.console.log(["Level is loading..."]);
		
		if(!musicPlaying){
			music.loop(HXP.engine.musicVolume);
			musicPlaying = true;
		}
		
		add(GM);
		
		generateLevel();
		
	}
	
	
	// end()
	//
	// Called automatically when a level is finished.
	
	public override function end(){
		removeAll();
	}
	
	
	// gameOver()
	//
	// Called when going to the gameOver scene, and not the next level.
	// Stops the looping music.
	// Returns the GameManager object for the gameOver scene to use.
	
	public function gameOver(){
		music.stop();
		return GM;
	}
}