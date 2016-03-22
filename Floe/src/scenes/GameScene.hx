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
import entities.WaterTile;
import entities.GroundTile;
import entities.Obstacle;
import entities.GameManager;
import entities.Tile;

import com.haxepunk.Sfx;


class GameScene extends Scene
{
	//declare static entities 
	private static var music:Sfx;
	public  static var GM:GameManager;
	private static var musicPlaying:Bool = false;
	
	//Use a single boolean variable to check if the static assets have been set up.
	private static var staticAssetSetup:Bool = false;
	
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
	
	private function generateLevel(){
		var dimensionX = 10; // max width of the generated level area.
		//var dimensionY = 8;   not used at the moment.
		
		var placeX = 32; //Starting X & Y position for placing tiles.
		var placeY = 32;
		
		var playerX = 0; //Player's starting X & Y position.
		var playerY = 0;
		
		var numOfTiles = 60; //controls number of water tiles initially placed.
		
		var PC = new Player(playerX, playerY);
		add(PC);
		
		while(numOfTiles > 0){
			if(HXP.random > .1){
				add(new WaterTile(placeX, placeY));
				numOfTiles -= 1;
				
				GM.waterAdded();
			}
			else{
				if(HXP.random > .5){
					add(new GroundTile(placeX, placeY));
				}
				else{
					add(new Obstacle(placeX, placeY));
				}
			}
			placeX += 32;
			if(placeX > 32 * dimensionX){
				placeX = 32;
				placeY +=32;
			}
		}
		
		HXP.console.log(["Level has been generated!"]);
	}
	
	public override function begin()
	{
		HXP.console.log(["Level is loading..."]);
		
		if(!musicPlaying){
			music.loop();
			musicPlaying = true;
		}
		
		add(GM);
		
		generateLevel();
		
	}
	
	public override function end(){
	
		removeAll();
	
	}
	
	//Called when going to the gameOver scene, and not the next level.
	// Stops the looping music.
	// Returns the GameManager object for the gameOver scene to use.
	
	public function gameOver(){
		music.stop();
		return GM;
	}
}