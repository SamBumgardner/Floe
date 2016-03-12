package scenes;

import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.Player;
import entities.WaterTile;
import entities.GroundTile;
import entities.Obstacle;
import entities.GameManager;

import com.haxepunk.Sfx;


class GameScene extends Scene
{
	//declare static entities 
	private static var music:Sfx;
	public  static var GM:GameManager;
	
	//Use a single boolean variable to check if the static entities and assets have been set up.
	private static var staticSetup:Bool = false;
	
	public function new(?gameManager:GameManager) //leading ? means optional parameter.
	{
		super();
		
		music.loop();
		if(!staticSetup){
			//All entity and asset assignments for static variables go here.
			
			music = new Sfx("audio/bgm.mp3");
			GM = gameManager;
			
			staticSetup = true;
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
		}
		
		add(GM);
		
		generateLevel();
		
	}
	
	public override function end(){
	
		music.stop();
		removeAll();
	
	}
	
	//Called when going to the gameOver scene, and not the next level.
	// Stops the looping music.
	// Returns the GameManager object for the gameOver scene to use.
	public function gameOver(){
		return GM;
	}
}